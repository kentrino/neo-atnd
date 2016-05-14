FROM kentrino/nginx-base

COPY docker.nginx.conf /etc/nginx/nginx.conf
COPY docker.vh.conf /etc/nginx/vh.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
