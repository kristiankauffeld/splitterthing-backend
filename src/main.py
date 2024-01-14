# Standard library imports
from enum import Enum
import pathlib
from pathlib import Path
from tempfile import NamedTemporaryFile

# Third-party imports
from fastapi import FastAPI, UploadFile, BackgroundTasks
from fastapi.responses import StreamingResponse
from demucs.api import Separator, save_audio

app = FastAPI()

SeparationType = Enum('SeparationType', {'DRUMS': 'drums', 'BASS': 'bass', 'VOCALS': 'vocals', 'OTHER': 'other'})

@app.get("/")
async def root():
    return {"message": "Hello World"}

@app.post("/uploadfile")
async def create_upload_file(file: UploadFile, separation_type: SeparationType, background_tasks: BackgroundTasks):
    #print(separation_type)
    file_content = await file.read()
    result, result_output_path = infer(file_content, separation_type)

    def itercontent():
        yield result
    
    background_tasks.add_task(delete_file, result_output_path)

    return StreamingResponse(itercontent(), media_type="audio/mpeg")

def infer(file_content, separation_type: SeparationType):
    separator = Separator()

    with NamedTemporaryFile(delete=False) as tmp:
        tmp.write(file_content)
        tmp.flush()
        input_path = pathlib.Path(tmp.name)

    # Perform the separation
    origin, separated = separator.separate_audio_file(input_path)

    # Define the output directory for Demucs
    root_dir = Path(__file__).parent.parent.resolve()
    track_folder = root_dir / "demucs_output"
    track_folder.mkdir(parents=True, exist_ok=True)

    # Save the selected track based on separation_type
    stem_name = separation_type.value  
    output_path = track_folder / f"{stem_name}_{input_path.stem}.mp3"
    save_audio(separated[stem_name], output_path, samplerate=separator.samplerate)
    
    # Read the 'drums' track into memory
    with open(output_path, "rb") as f:
        track_content = f.read()
    
    input_path.unlink(missing_ok=True)

    # Return the result and the path to the file
    return track_content, output_path

def delete_file(path: Path):
    if path.is_file():
        path.unlink()  # Delete the file
