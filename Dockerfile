FROM ph
WORKDIR /app
COPY . .
EXPOSE 80
CMD ["php", "-S", "0.0.0.0:80"]
