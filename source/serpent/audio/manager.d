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

final enum PlayStatus
{
    Paused = 0,
    Playing,
    FadingToNext,
}

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
    int _crossFadeTime = 0;
    Track nextTrack = null;
    Track currentTrack = null;

    /**
     * Mini state machine
     */
    PlayStatus status = PlayStatus.Paused;

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
     * Return the cross fade time duration (ms)
     */
    pure final @property int crossFadeTime() @safe @nogc nothrow
    {
        return _crossFadeTime;
    }

    /**
     * Set the time (ms) used to crossfade tracks
     */
    pure final @property void crossFadeTime(int time) @safe @nogc nothrow
    {
        assert(time >= 0, "Cannot have negative crossFadeTime");
        _crossFadeTime = time;
    }

    /**
     * Play a track continuously. It will not actually be played until
     * update is called
     */
    final void play(Track track) @trusted @nogc
    {
        nextTrack = track;
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

    /**
     * Attempt to start playback of a track
     */
    final void beginPlay(Track tr) @trusted @nogc
    {
        currentTrack = tr;
        nextTrack = null;

        if (tr is null)
        {
            status = PlayStatus.Paused;
            return;
        }

        status = PlayStatus.Playing;
        if (crossFadeTime < 1)
        {
            Mix_PlayMusic(tr.music, -1);
            return;
        }
        Mix_FadeInMusic(tr.music, -1, crossFadeTime);
    }

    /**
     * Attempt to end playback of a track
     */
    final void beginStop(Track tr) @trusted @nogc
    {
        if (crossFadeTime < 1)
        {
            status = PlayStatus.Paused;
            Mix_HaltMusic();
            currentTrack = null;
            return;
        }
        status = PlayStatus.FadingToNext;
        Mix_FadeOutMusic(crossFadeTime);
    }

    /**
     * Called by the owner to ensure cross-fades happen
     */
    final void update() @trusted @nogc
    {
        final switch (status)
        {
        case PlayStatus.Paused:
            if (nextTrack !is null)
            {
                beginPlay(nextTrack);
            }
            break;
        case PlayStatus.Playing:
            if (nextTrack !is null)
            {
                beginStop(currentTrack);
                status = PlayStatus.FadingToNext;
            }
            break;
        case PlayStatus.FadingToNext:
            if (Mix_PlayingMusic() == 1)
            {
                return;
            }
            currentTrack = null;
            beginPlay(nextTrack);
            break;
        }
    }
}
