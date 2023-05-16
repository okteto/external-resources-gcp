# Create a Development Environment with Okteto, Kubernetes, and GCP Services

This is an example of how to configure and deploy a development environment that includes polyglot microservices, an GCP pub/sub topic and subscription, and an GCP storage bucket.

## Architecture

![Architecture diagram](https://raw.githubusercontent.com/okteto/external-resources-gcp/main/docs/architecture.png)

## Run the demo application in Okteto

### Prequisites:
1. Okteto CLI 2.14 or newer
1. A GCP account
1. An Okteto account ([Sign-up](https://www.okteto.com/try-free/) for 30 day, self-hosted free trial)
1. [Create a service account key](https://cloud.google.com/iam/docs/keys-create-delete) with create/read/write/delete permissions to pub/sub and storage of IAM keys for your GCP accoun.
1. Create the following Okteto secrets:

        GCP_SERVICE_KEY: The `base64` encoded service account key with permission to create, write, read, and delete the resources. 
        GCP_PROJECT_ID: The project id you would like to use for the external resources


> If you are using Okteto Self-Hosted, you can directly use a [Workload Identity](https://www.okteto.com/docs/self-hosted/administration/configuration/#workload-identity)

Once this is configured, anyone with access to your Okteto instance will be able to deploy an development environment automatically, including the required cloud infrastructure.


```
$ git clone https://github.com/okteto/external-resources-gcp
$ cd external-resources-gcp
$ okteto context use $OKTETO_URL
$ okteto deploy
```

## Develop on the Menu microservice

```
$ okteto up menu
```

## Develop on the Kitchen microservice

```
$ okteto up kitchen
```

## Develop on the Result microservice

```
$ okteto up check
```

## Notes

This isn't an example of a properly architected perfectly designed distributed app... it's a simple
example of the various types of pieces and languages you might see (queues, persistent data, etc), and how to
deal with them in Okteto.
