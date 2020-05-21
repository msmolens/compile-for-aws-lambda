#ifndef LIBSINE_H
#define LIBSINE_H

#include <string>

namespace sine
{

// Generate a mono WAV file of a sine function at the specified frequency.
// Returns true on success.
bool generate_sine(float frequency, const std::string & filename);

} // namespace sine

#endif // LIBSINE_H
