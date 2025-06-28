# #!/bin/bash
# dnf update -y
# dnf install docker -y
# systemctl enable docker
# systemctl start docker
# usermod -aG docker ec2-user
# sleep 10

# # יצירת המפתח studykey.pem מ־Base64
# cat <<EOF | base64 -d > /home/Bar/.ssh/studykey.pem
# LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBd3YxeFI1eDBY
# cHZtSXJWK2ZmbjhLOUhTQXhSTENsUHR4V3hyRzJxbDVYczR5eXRrCkNUZTUyUXYxanhIenZTekpq
# THAzMWl0T01LZndkUDdFRkN3UEtjVzljT05PQzdEN1N2MFhqZGdRYy9hVFFrWHQKVjFyQ3NvK0dN
# dGdtR3RYeU5IUUE5bFlheC83RW40NzRXaTZYUm1NUUkvSVZ0UHJRUG9PYktNQVEzY1VHUFEvbApS
# WnBrc25wZ2lTYTZURG9FZnloK1d6aG92VUI1ZldBR3prNG5EZzkxZVYyU05FZm13R0ZSSG9LV0l0
# c1BDNFM0CkxoT0toZElQSHA0SGlzL3Z2QnJvd2dnaVlGemhyOVpsU3BnNDc5TE5kemJockpaOVdH
# c05XMU9SSVZaK053WEUKTmt4YVhPaVVxNDNlUVJsSDRCdFZtR2FCUWVjV3NHOVlUazJrTFFJREFR
# QUJBb0lCQUQycVZVYm1iYzcxMHNRcgpUY09kYVdpYVJLYUFwbkt2dEVSNVV5NHFmaWlpM1lVelJj
# RzhnK1BtYWxSQ3d5aVNuM01JRFpvSHZBU2JOK3BvCkg2NlplSG9uZFEvY2N2UXpsbVZTd1Q0MGxJ
# OTM3WDVLQ3hOVE9ydXB0REVrTm5qS0xIejJLcys4ejE5c2JOWmgKS3AycW1tRENOM3FHdHVLeloy
# UTl6cllHZDg4S1VHeXhXc0V5eHZlRStkaUxYbG83WVViSjEzMU4rYzhZQVlXWApDMitIcUZJbTNM
# SERNSHArNkRIYnpqVnBtSldYRW9WQndPT2owNThCeTBpTEMxNytWbmtTNjJKRm9wRHdlT2FBCmV3
# OExWMnhpMm1EQnlpb0IxWW1FVWVsQUtwNEVOb3NoWFdlNThlcGpqTG45WTJWVFZwTFlBUU1qMHVn
# MFNZV2MKZ25HeHVta0NnWUVBOHZTRE5XTTlDQkhEQkI0UzVxb1Z0WTUzUHI4dFFLMDJJbWhUUXBT
# bnZQTURiUEhGUlg4RwpTUlVNL2J6WFdvRENpaklyVE13WlQwbjc0akxvQUp0UjV0dWtIMDN4VFhm
# MzJZYTkrSmlFTlA4ODU2OXNhUlBWCnpTZm95S3JLY3ExeWRwL3BOWWlMOEFMdk5qZnVqOEt6UXlO
# Z24zVW93WFNoN1A2Q21hVG1RSk1DZ1lFQXpYV2kKd1A4c3EyMTFLZ0U3ejJuK25nTm5WVFh6bWJ2
# ZzdneUZMcW9jVE9KUVRYNVZKelpjK29UM0dFQmxYMFB1WDdEMAp3SGZoWTVhdGdxTU4veHFuREhk
# UFI5Nit6YlpJbWJNK1ppRmkzTW5ZN3MxTU00ZGk1VUtYNmxyamI0MGdrZ2tYCjlMYm1YVFNIMGFZ
# UW9NdlZqaFhOWFQyOHpDMkdLUnAzK01MbFFEOENnWUJPWEpNZFd4N0tSWUJUQ2FnckFkenkKckRy
# RjREK21ScmZaTFREOW5wampscllhSTNqdlMyTXBtMEtQYktOQks1cVRuRTdlL0UyRmgyVll0ZmFp
# aTNaRgpNYjZqNGkzY1FMK09SNmxxVHpjRktQWHAvR2pKRTM2NEp4RXI5L3BJTnExZW1ZRk1wUGdO
# dDhTVUJrSkoyQkNkCnJRRnpMUVN5TVA0eFJIMjNOTHFYUlFLQmdRQ2dXeVhSMTljM1hORExIZmRl
# Wk8zU3lmbEdhanRjUzJTOHBvenoKNU5UOXRNelVEcnZMUlFUQWlqS0lmUW9obGxWZjNpN0lZVWhL
# Zi9tZ01qN2tVaHI3QWN1ZzNscXhGNG9HVy8xaApuTUVhYlhlZ3VoNjFRUCtReTY3aHZGb3lZRVdC
# ZFJON2JaelNOZ09qUHlkUE9JZk93M2xyUXBvdUNZSGlac1FvCkpZVGo1UUtCZ0VQd0I0bG5tMW4z
# cEdVN3VwajY5b1RkdTNLR2tsSk1aM3pNVksveVZRWTFlZXkyZXNqYW5pNWoKdmxGNitldzBVTDMv
# OHdPOHZVTVJpUy9OWVZFVmx1L3E5OCtVYlV5dElZblE4WlVCNm9YMGZIc0YxTVVLTDFFLwphTHJP
# YkUxbWFURk9nSFVXQW9ydTRzZTAyeUttak5wRVZTV3NrVkdJd3RXSGwvenhKLzNLCi0tLS0tRU5E
# IFJTQSBQUklWQVRFIEtFWS0tLS0t
# EOF

# chmod 400 /home/Bar/.ssh/studykey.pem
# chown ec2-user:ec2-user /home/Bar/.ssh/studykey.pem

# # התחברות ל-ECR והרצת קונטיינר
# echo "[INFO] Trying to login to ECR..." >> /var/log/user_data.log
# aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 267414915135.dkr.ecr.us-east-1.amazonaws.com >> /var/log/user_data.log 2>&1

# echo "[INFO] Trying to run the container..." >> /var/log/user_data.log
# docker run -d -p 80:80 267414915135.dkr.ecr.us-east-1.amazonaws.com/nginx-moveo:latest >> /var/log/user_data.log 2>&1

# echo "[DONE] Finished user data script." >> /var/log/user_data.log





# # #!/bin/bash
# # dnf update -y
# # dnf install docker -y
# # systemctl enable docker
# # systemctl start docker
# # usermod -aG docker ec2-user
# # sleep 10

# # echo "[INFO] Trying to login to ECR..." >> /var/log/user_data.log
# # aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 267414915135.dkr.ecr.us-east-1.amazonaws.com >> /var/log/user_data.log 2>&1

# # echo "[INFO] Trying to run the container..." >> /var/log/user_data.log
# # docker run -d -p 80:80 267414915135.dkr.ecr.us-east-1.amazonaws.com/nginx-moveo:latest >> /var/log/user_data.log 2>&1

# # echo "[DONE] Finished user data script." >> /var/log/user_data.log
