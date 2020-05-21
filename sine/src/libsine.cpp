#include <libsine/libsine.h>

#include <cmath>
#include <cstring>
#include <vector>

#include <sndfile.h>

namespace sine
{

static constexpr int SampleRate = 44100;
static constexpr int SampleCount = (SampleRate * 2); // 2 seconds
static constexpr float Amplitude = (1.0 * 0x7F000000);

// Based on libsndfile example:
// https://github.com/erikd/libsndfile/blob/06ebde5/examples/make_sine.c
bool generate_sine(float frequency, const std::string & filename)
{
    if (frequency < 0.0f) {
        return false;
    }

    frequency /= SampleRate;

    SF_INFO sfinfo;
    memset(&sfinfo, 0, sizeof(sfinfo));
    sfinfo.samplerate = 44100;
    sfinfo.frames = SampleCount;
    sfinfo.channels = 1;
    sfinfo.format = (SF_FORMAT_WAV | SF_FORMAT_PCM_24);

    SNDFILE * file = sf_open(filename.c_str(), SFM_WRITE, &sfinfo);
    if (!file) {
        return false;
    }

    std::vector<int> buffer(SampleCount);

    for (int i = 0 ; i < SampleCount ; i++) {
        buffer[i] = Amplitude * sin(frequency * 2 * i * M_PI);
    }

    if (sf_write_int(file, &buffer[0], sfinfo.channels * SampleCount) != sfinfo.channels * SampleCount) {
        return false;
    }

    sf_close(file);

    return true;
}

} // namespace sine
