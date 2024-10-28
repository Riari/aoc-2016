package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../utils"

Vector2 :: struct {
    x: int,
    y: int,
}

LEFT :: 'L'

N :: Vector2{0, 1}
E :: Vector2{1, 0}
S :: Vector2{0, -1}
W :: Vector2{-1, 0}

main :: proc() {
    input := utils.read_input()
    steps, _ := strings.split(input, ", ")
    fmt.printfln("Part 1: %i", part_1(steps))
    fmt.printfln("Part 2: %i", part_2(steps))
}

add :: proc(v1, v2: Vector2) -> Vector2 {
    return Vector2{v1.x + v2.x, v1.y + v2.y}
}

simulate :: proc(steps: []string, stop_on_seen_twice: bool = false) -> int {
    position := Vector2{0, 0}
    compass := [4]Vector2{N, E, S, W}
    heading := 0 // north
    seen := map[Vector2]bool{}

    outer: for step in steps {
        direction := step[0] == LEFT ? -1 : 1
        count, ok := strconv.parse_int(step[1:])
        assert(ok)
        heading = (heading + direction) %% 4

        for _ in 0..<count {
            position = add(position, compass[heading])

            if stop_on_seen_twice {
                if position in seen do break outer
                seen[position] = true
            }
        }
    }

    delete(seen)

    return abs(position.x) + abs(position.y)
}

part_1 :: proc(steps: []string) -> int {
    return simulate(steps)
}

part_2 :: proc(steps: []string) -> int {
    return simulate(steps, true)
}

@(test)
test_part_1 :: proc(t: ^testing.T) {
    assert(part_1({"R8", "R4", "R4", "R8"}) == 8)
}

@(test)
test_part_2 :: proc(t: ^testing.T) {
    assert(part_2({"R8", "R4", "R4", "R8"}) == 4)
}
