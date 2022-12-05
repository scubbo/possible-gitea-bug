This repo demonstrates some unexpected behaviour in Gitea's Docker registry - when running `docker` commands (`docker login`, `docker pull`, etc.) against a registry, a call is made against the server's `ROOT_URL`. If there is no server available at the `ROOT_URL`, this will result in an error.

## Why does this matter? How would it be possible for the server to be up but the `ROOT_URL` be unavailable?

It's a considerable edge case, but - see [this SO question](https://stackoverflow.com/questions/74681071/docker-login-to-gitea-registry-fails-even-though-curl-succeeds/74681764). A situation where this could arise is:
* a particular image is a prerequisite for making the Gitea registry publicly available (say, as part of a [Cloudflared Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps) deployment)
* the image is provided _by_ that registry, but referenced using an internally-available url rather than the public name which is used as `ROOT_URL`

("_This is a edge case that we will not address - if you have an image that's a prerequisite for making a registry publicly-available, provide it from a different registry_" would be a perfectly reasonable response to this "issue" - I just wanted to flag it up in case it genuinely is unexpected, and/or if there's a better way to address this situation)