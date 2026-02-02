# Nginx Log Analyser

A simple shell script that analyzes an Nginx access log and prints:
- Top 5 IPs by request count
- Top 5 requested paths
- Top 5 response status codes
- Top 5 user agents

## Usage

```bash
chmod +x nginx-log-analyser.sh
./nginx-log-analyser.sh access.log


https://roadmap.sh/projects/nginx-log-analyser