[![REUSE status](https://api.reuse.software/badge/github.com/openmcp-project/landscaper-service)](https://api.reuse.software/info/github.com/openmcp-project/landscaper-service)

# Landscaper Service

## About this project

A service managing multi-tenant landscaper installations.

## Requirements and Setup

The _Landscaper Service_ aims to implement a Kubernetes API extension, which provides and manages Landscaper installations as a service.
Its goal is to install the [Landscaper](https://github.com/openmcp-project/landscaper) on configurable target Kubernetes clusters. Landscaper installations are isolated for each tenant, as each installation is hosted in its own virtual cluster (node-less Kubernetes cluster with its own Kube API server and etcd).

The documentation can be found [here](docs/README.md).


## Support, Feedback, Contributing

This project is open to feature requests/suggestions, bug reports etc. via [GitHub issues](https://github.com/openmcp-project/landscaper-service/issues). Contribution and feedback are encouraged and always welcome. For more information about how to contribute, the project structure, as well as additional contribution information, see our [Contribution Guidelines](CONTRIBUTING.md).

## Security / Disclosure
If you find any bug that may be a security problem, please follow our instructions at [in our security policy](https://github.com/openmcp-project/landscaper-service/security/policy) on how to report it. Please do not create GitHub issues for security-related doubts or problems.

## Code of Conduct

We as members, contributors, and leaders pledge to make participation in our community a harassment-free experience for everyone. By participating in this project, you agree to abide by its [Code of Conduct](https://github.com/SAP/.github/blob/main/CODE_OF_CONDUCT.md) at all times.

## Licensing

Copyright 2025 SAP SE or an SAP affiliate company and landscaper-service contributors. Please see our [LICENSE](LICENSE) for copyright and license information. Detailed information including third-party components and their licensing/copyright information is available [via the REUSE tool](https://api.reuse.software/info/github.com/openmcp-project/landscaper-service).

### Information about this fork

This repository is a fork of https://github.com/gardener/landscaper-service. The support for the Landscaper project is sunsetting in the _Gardener_ organization.
Maintainenance and development of the Landscaper project will continue in the https://github.com/openmcp-project/landscaper-service repository.
This doesn't affect any feature or functionality of the Landscaper project.
OCI images and OCM components can be consumed directly from within this repository GitHub Container Registry.
