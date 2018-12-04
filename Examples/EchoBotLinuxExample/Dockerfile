FROM swift:latest
RUN mkdir /app
ADD . /app/
WORKDIR /app
RUN swift build
CMD ["swift run"]

