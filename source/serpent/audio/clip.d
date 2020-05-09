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

module serpent.audio.clip;

import bindbc.sdl.mixer;

/**
 * A Clip is a small sound effect that can be played continuously or
 * a set number of times (i.e. once)
 *
 * Full background music should be handled by the Track instance.
 */
final class Clip
{

private:

    Mix_Chunk* _chunk = null;
    string _filename = null;

public:

    @disable this();

    /**
     * Construct a new Chunk from the given filename
     */
    this(string filename)
    {
        _filename = filename;
        _chunk = Mix_LoadWAV(_filename.ptr);
    }

    ~this()
    {
        Mix_FreeChunk(_chunk);
    }

package:

    /**
     * Expose chunk object to the Manager
     */
    pure final @property Mix_Chunk* chunk() @safe @nogc nothrow
    {
        return _chunk;
    }
}
