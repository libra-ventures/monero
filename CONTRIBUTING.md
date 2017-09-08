Contributing
============

## Updates for 1.0

The organizational structure of Monero is inherited from the ExAws 1.0 and is relatively simple. Please read this document carefully as it has changed.

Contributions to Monero are absolutely appreciated. For general bug fixes or other tweaks to existing code, a regular pull request is fine. For those who wish to add to the set of APIs supported by Monero, please consult the rest of this document, as any PRs adding a service are expected to follow the structure defined herein.

## Organization

Monero inherits a data driven approach to querying APIs. The various functions that exist inside a service like `Wallet.getbalance()` or `Daemon.getheight()` all return a struct which holds the information necessary to make that particular operation. Adding an API call then is very easy, as you just need to create faced functions which will pass necessary arguments to the  `request()` function inside a service to create request struct, and you're done.

The `Monero.Operation` protocol is implemented for each operation struct, giving us `perform` function. It take the operation struct and any configuration overrides, do any service specific steps that require configuration, and then call the `Monero.request` module.
