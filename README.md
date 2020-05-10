# Serpent Audio Support

[![License](https://img.shields.io/badge/License-ZLib-blue.svg)](https://opensource.org/licenses/ZLib)

This package contains basic audio support for the [Serpent Game Framework](https://lispysnake.com/)

Currently this is implemented using sdl-mixer - until such point as more work happens in this
project to move to OpenAL.

The current scope is simply to help further the milestones and add audio support to serpent-demo-paddle.


## THIS IS A HACK

Right now, we're only interesting in the MOST BASIC implementation to support the initial demos.
As such, we'll use a simple OOPy wrapper around sdl-mixer.

Eventually we're planning something like a full openal integration with SoundComponent per entity,
Listeners attached to cameras, etc. For now, let's go hacky.

### The Working TODO List

- [x] Remove SoundProcessor completely, it's not friendly to our needs **yet**
- [x] Add basic SoundManager object
- [x] Add basic SoundEffect object (audio.Clip)
- [x] Add basic SoundMusic object (audio.Track)
- [x] Allow playing ONE Track, multiple Clips
- [ ] Add crossfades
- [ ] Add impact sounds & menu sound
- [x] Add volume settings to manager (0.0 to 1.0)
