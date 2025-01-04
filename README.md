# OCR service

It is subscribed to `textimage_created` kafka topic.

Uses [tesseract](https://github.com/tesseract-ocr/tesseract) as OCR engine 

After processing image it publishes message to `ocr` topic.


### Configuration

ENV

```
LTM_STORAGE_PATH = '/ltm'
KAFKA_CLIENT_ID=ocr_service
KAFKA_SOCKET = kafka-broker:9093
```

### Testing

```
rspec spec/
```

### Running

```
bundle exec karafka server
```

### Docker compose

```
ocr:
    build:
      context: ./../ocr
      dockerfile: Dockerfile
    env_file: .env
    command: bundle exec karafka server
    volumes:
      - files-shared:/ltm:rw
    depends_on:
      - kafka-broker
    environment: 
      - KAFKA_CLIENT_ID=ocr_service
```

example can be found [here](https://github.com/ThoughtsKeeperOrg/ops/blob/main/docker-compose.yml)
