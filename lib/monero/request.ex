defmodule Monero.Request do
  @moduledoc """
  Makes requests to Monero backend and attempts to retry if needed
  """

  require Logger

  @type http_status :: pos_integer
  @type success_content :: %{body: binary, headers: [{binary, binary}]}
  @type success_t :: {:ok, success_content}
  @type error_t :: {:error, {:http_error, http_status, binary}}
  @type response_t :: success_t | error_t

  @doc "Fire a request. Not inteded to be called by the user, see `Monero.request`"
  def request(http_method, url, data, headers, config, service) do
    body = case data do
      [] -> "{}"
      d when is_binary(d) -> d
      _ -> config[:json_codec].encode!(data)
    end

    request_and_retry(http_method, url, service, config, headers, body, {:attempt, 1})
  end

  defp request_and_retry(_method, _url, _service, _config, _headers, _req_body, {:error, reason}), do: {:error, reason}

  defp request_and_retry(method, url, service, config, headers, req_body, {:attempt, attempt}) do
    url = URI.encode(url)
    opts = Map.get(config, :http_opts, [])
    debug_requests(config, url, headers, req_body)

    case config[:http_client].request(method, url, req_body, headers, opts) do
      {:ok, response = %{status_code: status}} when status in 200..299 ->
        {:ok, response}

      {:ok, %{status_code: status, headers: resp_headers} = resp} when status == 401 ->
        reason = client_error(resp)
        with {:attempt, attempt} <- attempt_again?(attempt, reason, config),
             {:ok, full_headers} <- Monero.Auth.headers(method, url, config, resp_headers, headers),
             do: request_and_retry(method, url, service, config, full_headers, req_body, {:attempt, attempt})

      {:ok, %{status_code: status} = resp} when status in 400..499 and status != 401 ->
        reason = client_error(resp)
        request_and_retry(method, url, service, config, headers, req_body, attempt_again?(attempt, reason, config))

      {:ok, %{status_code: status, body: body}} when status >= 500 ->
        reason = {:http_error, status, body}
        request_and_retry(method, url, service, config, headers, req_body, attempt_again?(attempt, reason, config))

      {:error, %{reason: reason}} ->
        Logger.warn("Monero: HTTP ERROR: #{inspect reason}")
        request_and_retry(method, url, service, config, headers, req_body, attempt_again?(attempt, reason, config))
    end
  end

  defp client_error(%{status_code: status} = error) do
    {:http_error, status, error}
  end

  defp attempt_again?(attempt, reason, config) do
    if attempt >= config[:retries][:max_attempts] do
      {:error, reason}
    else
      backoff(attempt, config)
      {:attempt, attempt + 1}
    end
  end

  defp backoff(attempt, config) do
    (config[:retries][:base_backoff_in_ms] * :math.pow(2, attempt))
    |> min(config[:retries][:max_backoff_in_ms])
    |> trunc
    |> :rand.uniform
    |> :timer.sleep
  end

  defp debug_requests(config, url, headers, body) do
    if config[:debug_requests] do
      Logger.debug fn ->
        """
        Request URL: #{inspect url}"
        Request HEADERS: #{inspect headers}
        Request BODY: #{inspect body}"
        """
      end
    end
  end
end
