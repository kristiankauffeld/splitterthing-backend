to start the app you can choose to cd into "src" and run:

```bash
uvicorn main:app --reload
```

or run the following command from the root of the project:

```bash
uvicorn src.main:app --reload
```

endpoint test example:

```bash
http://127.0.0.1:8000/uploadfile/?separation_type=drums
```
