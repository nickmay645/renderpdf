import requests
import json
import base64

# Change these to test
url = 'https://www.chinabidding.cn/zbgs/nA8WzG.html'


response = requests.get(f'https://ahfdr4aj3e.execute-api.us-east-1.amazonaws.com/default/test?url={url}')

result = json.loads(response.text)
result['pdf_base64_data']
with open('test.pdf', 'wb') as file:
    file.write(base64.b64decode(result['pdf_base64_data']))

print('Done.')