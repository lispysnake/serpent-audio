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

module serpent.audio.processor;

import serpent;

import bindbc.sdl;
import bindbc.sdl.mixer;

import std.exception : enforce;
import std.format;

/**
 * The AudioProcessor should be added to the main serpent.Context to
 * allow the manipulation and rendering of audio
 */
final class AudioProcessor : Processor!ReadOnly
{

public:

    /**
     * Get the Mixer module initialised, primarily with OGG support until
     * any other formats are needed.
     */
    final override void bootstrap(View!ReadOnly view)
    {
        auto status = Mix_Init(MIX_INIT_OGG);
        enforce(status == MIX_INIT_OGG, "Failed to initialise SDL_Mixer: %s".format(SDL_GetError()));

    }

    final override void finish(View!ReadOnly view)
    {
        Mix_Quit();
    }

    /**
     * Update for the current frame step
     */
    final override void run(View!ReadOnly view)
    {
    }
}
