package main

import "core:fmt"
import "core:math"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../utils/file"

Vector2 :: struct {
    x: int,
    y: int,
}

LEFT :: 'L'
RIGHT :: 'R'

N :: Vector2{0, 1}
E :: Vector2{1, 0}
S :: Vector2{0, -1}
W :: Vector2{-1, 0}

main :: proc() {
    input := file.read_input()
    steps, _ := strings.split(input, " ")
    fmt.printfln("Part 1: %i", part_1(steps))
    part_2()
}

add :: proc(v1, v2: Vector2) -> Vector2 {
    return Vector2{v1.x + v2.x, v1.y + v2.y}
}

part_1 :: proc(steps: []string) -> int {
    position := Vector2{0, 0}
    compass := [4]Vector2{N, E, S, W}
    heading := 0 // north
    for step in steps {
        direction := step[0]
        count, ok := strconv.parse_int(step[1:])
        if direction == LEFT {
            heading = (heading - 1) %% 4
        } else {
            heading = (heading + 1) %% 4
        }

        for _ in 0..<count {
            position = add(position, compass[heading])
        }
    }

    return abs(position.x) + abs(position.y)
}

part_2 :: proc() {
}

@(test)
test_part_1 :: proc(t: ^testing.T) {
    assert(part_1({"R2", "L3"}) == 5)
}

@(test)
test_part_2 :: proc(t: ^testing.T) {
}