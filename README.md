# UnityFishAnimation
A vertex shader for fish animation

Right now, the light model is a simple toon shading and mesh color(you can replace it with main texture of course). 
In my project, I use toon shading and mesh color to dynamic batching as many mesh as possible. since I usually got a lot of fish on the scene.

<img width="350" alt="result" src="https://user-images.githubusercontent.com/13420668/95992411-7e16ba00-0e60-11eb-8f42-41f471775173.gif"> <img width="350" alt="result" src="https://user-images.githubusercontent.com/13420668/95992394-79ea9c80-0e60-11eb-9181-66ad176b458d.gif">

How To Use
-------------------

<img width="450" alt="result" src="https://user-images.githubusercontent.com/13420668/95993221-70adff80-0e61-11eb-9dd9-6ee71c29ef5c.png"><img width="450" alt="result" src="https://user-images.githubusercontent.com/13420668/95992404-7c4cf680-0e60-11eb-88ac-b78886519ee5.gif">

- Create new material with -> Custom/ToonMovingFish shader.

- Toggle on the `DEBUG_COLOR_MASK` option in the material inspector.

- Adjust `_InvertScale` for each model (usually a small model will require larger invertScale)

- Adjust `_MaskZ` to mask out the vertex animation strength. The animation strength will scale with the debug color on the mesh.(scale from black(0) to white(1)).

- Toogle on different animation option like SpinRoll, Side to side movement...etc

- Make sure the frequence are all the same for more nature movement.

Credits
======

This project was inspired by [Abzu Creator's GDC Video]

Resources
-------------------
[Sardine asset] & [Whale asset]


[Abzu Creator's GDC Video]: https://youtu.be/l9NX06mvp2E
[Sardine asset]: https://assetstore.unity.com/packages/3d/characters/animals/fish/sardine-37963
[Whale asset]: https://assetstore.unity.com/packages/3d/characters/animals/fish/humpback-whale-3547
