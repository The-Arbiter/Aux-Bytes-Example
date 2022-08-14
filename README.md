# BytesAux / Aux Bytes Example

### This example shows you how to store uint as bytes in aux and retrieve the value you've stored.

It does use assembly so shoutout to @vectorized for helping me figure out exactly what to do. I'm not trying to be optimised here I just realised that this would be very painful in Solidity.

### What is in here?

1) An example of storing a uint128 in a bytes24 object as well as a way to retrieve this value


2) An example of storing a uint128 and a uint64 inside a bytes24 object as well as a way to retrieve both values at once and a way to retrieve only the latter value


*This should teach you how we can use bytes to store information in `aux` and retrieve it later.*

Arby