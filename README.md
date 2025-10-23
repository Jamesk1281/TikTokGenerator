Note: This project was built as a local Swift app and is not intended for public deployment.
Some parts of the code — such as file paths, API keys, and local URLs — are specific to my setup and will not function outside my environment.

A simple TikTok slideshow generator that, when given a prompt (e.g. “4 scariest places on Earth”), automatically generates text and images in a 9:16 format suitable for posting on TikTok.

The workflow is as follows:

1. A local LLM, Ollama, processes the prompt to find relevant topics and generate titles and descriptions for each.

2. Each title is used as a query on a non-AI image database to retrieve real images.

3. The user reviews the results — if the images don’t fit, they can re-generate using Stable Diffusion, another local model.

4. Stable Diffusion uses the topic and its description to create an appropriate AI-generated image, which is used for the background of the slide. Text from Ollama is overlayed, producing the slideshow result. 
