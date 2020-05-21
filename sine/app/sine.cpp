#include <libsine/libsine.h>

#include <cstdlib>
#include <iostream>
#include <string>

int main(int argc, char * argv[]) {
    if (argc != 3) {
        std::cerr << "USAGE: " << argv[0] << " <frequency (Hz)> <filename>" << std::endl;
        return 1;
    }

    // Parse arguments
    float frequency = atof(argv[1]);
    std::string filename(argv[2]);

    // Generate WAV file
    auto result = sine::generate_sine(frequency, filename);

    return result ? 0 : 1;
}
