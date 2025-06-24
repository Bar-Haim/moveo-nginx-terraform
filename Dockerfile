FROM nginx:latest

COPY index.html /mnt/c/Users/haim4/Desktop/DevOps/moveo/index.html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]