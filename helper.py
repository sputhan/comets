import requests
import json
from robot.libraries.BuiltIn import BuiltIn
from jsonschema import validate
from jsonschema.exceptions import ValidationError

schema = {
    "type": "object",
    "properties": {
        "signature": {"type": "object"},
        "count": {"type": "string"},
        "fields": {"type": "array"},
        "data": {"type": "array"},
    },
}

def verify_output_format(resp_text):
    try:
        resp_json = json.loads(resp_text)
        validate(instance=resp_json, schema=schema)
        if resp_json["signature"]["version"] != "1.1":
            BuiltIn().fail(msg="Unreliable Version")
    except ValueError:
        BuiltIn().fail(msg="output format not json")
    except ValidationError:
        BuiltIn().fail(msg="json schema error")
