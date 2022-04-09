FROM ubuntu:22.04

ENV TERRAFORM_VERSION 1.1.6
ENV ANSIBLE_VERSION 4.8.0-r0
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install curl python3 ansible git git-lfs less

# Download and Install Terragitform
RUN cd /usr/local/bin && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Downloading and Install gcloud cli
RUN curl https://dl.google.com/dl/cloudsdk/release/google-cloud-sdk.tar.gz > /tmp/google-cloud-sdk.tar.gz

RUN mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xvf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh

ENV PATH $PATH:/usr/local/gcloud/google-cloud-sdk/bin

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \ 
  && unzip awscliv2.zip \
  && ./aws/install

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
RUN kubectl version --client
CMD ["/bin/sh"]
