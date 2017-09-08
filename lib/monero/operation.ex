defprotocol Monero.Operation do
  def perform(operation, config)

  def stream!(operation, config)
end
