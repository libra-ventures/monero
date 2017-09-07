defmodule ExMonero.Request do
  require Logger

  @moduledoc """
  Makes requests to AWS.
  """

  @type http_status :: pos_integer
  @type success_content :: %{body: binary, headers: [{binary, binary}]}
  @type success_t :: {:ok, success_content}
  @type error_t :: {:error, {:http_error, http_status, binary}}
  @type response_t :: success_t | error_t

  def request(http_method, url, data, headers, config, service) do
    body = case data do
      []  -> "{}"
      d when is_binary(d) -> d
      _   -> config[:json_codec].encode!(data)
    end

    request_and_retry(http_method, url, service, config, headers, body, {:attempt, 1})
  end

  def request_and_retry(_method, _url, _service, _config, _headers, _req_body, {:error, reason}), do: {:error, reason}

  def request_and_retry(method, url, service, config, headers, req_body, {:attempt, attempt}) do
    url = replace_spaces(url)

    if config[:debug_requests] do
      Logger.debug("Request URL: #{inspect url}")
      Logger.debug("Request HEADERS: #{inspect headers}")
      Logger.debug("Request BODY: #{inspect req_body}")
    end

    case config[:http_client].request(method, url, req_body, headers, Map.get(config, :http_opts, [])) do
      {:ok, response = %{status_code: status}} when status in 200..299 ->
        {:ok, response}
      {:ok, %{status_code: status, headers: resp_headers} = resp} when status == 401 ->
        reason = client_error(resp)
        case  attempt_again?(attempt, reason, config) do
          {:attempt, attempt} ->
            with {:ok, full_headers} <- ExMonero.Auth.headers(method, url, config, resp_headers, headers) do
              request_and_retry(method, url, service, config, full_headers, req_body, {:attempt, attempt})
            end
          {:error, reason} -> {:error, reason}
        end
      {:ok, %{status_code: status, body: body}} when status >= 500 ->
        reason = {:http_error, status, body}
        request_and_retry(method, url, service, config, headers, req_body, attempt_again?(attempt, reason, config))
      {:error, %{reason: reason}} ->
        Logger.warn("ExMonero: HTTP ERROR: #{inspect reason}")
        request_and_retry(method, url, service, config, headers, req_body, attempt_again?(attempt, reason, config))
    end
  end

  def client_error(%{status_code: status} = error) do
    {:http_error, status, error}
  end

  def attempt_again?(attempt, reason, config) do
    if attempt >= config[:retries][:max_attempts] do
      {:error, reason}
    else
      attempt |> backoff(config)
      {:attempt, attempt + 1}
    end
  end

  def backoff(attempt, config) do
    (config[:retries][:base_backoff_in_ms] * :math.pow(2, attempt))
    |> min(config[:retries][:max_backoff_in_ms])
    |> trunc
    |> :rand.uniform
    |> :timer.sleep
  end

  defp replace_spaces(url) do
    String.replace(url, " ", "%20")
  end
end