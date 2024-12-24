# OCR service

It is subscribed to `textimage_created` kafka topic.

Uses [tesseract](https://github.com/tesseract-ocr/tesseract) as OCR engine 

After processing it publishes to `ocr` topic.
