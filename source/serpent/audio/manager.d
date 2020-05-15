/*
 * This file is part of serpent.
 *
 * Copyright © 2019-2020 Lispy Snake, Ltd.
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 * 1. The origin of this software must not be misrepresented; you must not
 *    claim that you wrote the original software. If you use this software
 *    in a product, an acknowledgment in the product documentation would be
 *    appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 *    misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

module serpent.audio.manager;

import serpent;

import bindbc.sdl;
import bindbc.sdl.mixer;

import std.exception : enforce;
import std.format;

import serpent.audio.clip : Clip;
import serpent.audio.track : Track;

static const int SdlBufferSize = 1024;

/**
 * The Manager is a super simple management mechanism for sdl-mixer
 * backed audio in basic demo games. It doesn't offer any advanced
 * features and will eventually be replaced with an ECS-integrated
 * OpenAL solution
 */
final class AudioManager
{

private:

    float volumeFraction = 1.0f;
    float effectFraction = 1.0f;

public:

    this()
    {
        auto status = Mix_Init(MIX_INIT_OGG);
        enforce(status == MIX_INIT_OGG, "Failed to initialise SDL_Mixer: %s".format(SDL_GetError()));

        status = Mix_OpenAudio(MIX_DEFAULT_FREQUENCY, MIX_DEFAULT_FORMAT,
                MIX_DEFAULT_CHANNELS, SdlBufferSize);
        enforce(status == 0, "Failed to open mixer audio: %s".format(SDL_GetError()));

        /* Set the initial volume to full */
        trackVolume = 1.0f;
    }

    ~this()
    {
        Mix_CloseAudio();
        Mix_Quit();
    }

    /**
     * Set the track volume to a fraction between 0.0 and 1.0
     */
    final @property void trackVolume(float v) @trusted @nogc
    {
        assert(v >= 0.0f && v <= 1.0f, "trackVolume should be between 0.0 and 1.0");
        import std.math : round;

        Mix_VolumeMusic(cast(int) round(MIX_MAX_VOLUME * v));
        volumeFraction = v;
    }

    /**
     * Return the track volume as a fraction between 0.0 and 1.0
     */
    pure final @property float trackVolume() @safe @nogc nothrow
    {
        return volumeFraction;
    }

    /**
     * Set the effect volume as a fraction between 0.0 and 1.0
     */
    pure final @property void effectVolume(float v) @safe @nogc
    {
        assert(v >= 0.0f && v <= 1.0f, "effectVolume should be between 0.0 and 1.0");
        effectFraction = v;
    }

    /**
     * Return the current effect volume as a fraction between 0.0 and 1.0
     */
    pure final @property float effectVolume() @safe @nogc nothrow
    {
        return effectFraction;
    }

    /**
     * Play a track continuously
     */
    final void play(Track track) @trusted @nogc
    {
        Mix_PlayMusic(track.music, -1);
    }

    /**
     * Play a clip once on any free channel
     */
    final void play(Clip clip) @trusted @nogc
    {
        import std.math : round;

        Mix_VolumeChunk(clip.chunk, cast(int) round(MIX_MAX_VOLUME * effectFraction));
        Mix_PlayChannel(-1, clip.chunk, 0);
    }
}
