FROM python:3.7-buster
LABEL maintainer="ysde108@gmail.com"
WORKDIR /opt/grafana-backup-tool
ADD . /opt/grafana-backup-tool
RUN pip install -r requirements.txt &&\
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" &&\
unzip awscliv2.zip &&\
./aws/install &&\
chmod +x backup_grafana.sh
