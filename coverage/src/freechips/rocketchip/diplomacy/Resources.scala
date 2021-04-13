package freechips.rocketchip.diplomacy

/** Permission of an address space.
 * @param r            readable.
 * @param w            writable.
 * @param x            executable.
 * @param c            cacheable.
 * @param a            supports all atomic operations.
 */
case class ResourcePermissions(r: Boolean, w: Boolean, x: Boolean, c: Boolean, a: Boolean) // Not part of DTS