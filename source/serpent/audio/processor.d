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

import bindbc.sdl.mixer;

/**
 * The AudioProcessor should be added to the main serpent.Context to
 * allow the manipulation and rendering of audio
 */
final class AudioProcessor : Processor!ReadOnly
{

public:

    /**
     * Register relevant physics components
     */
    final override void bootstrap(View!ReadOnly view)
    {
    }

    final override void finish(View!ReadOnly view)
    {
    }

    /**
     * Update for the current frame step
     */
    final override void run(View!ReadOnly view)
    {
    }
}
