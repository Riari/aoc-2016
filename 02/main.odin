package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"

import "../utils/file"

Vector2 :: struct {
    x: int,
    y: int,
}

KEYPAD :: [3][3]int{
    { 1, 2, 3 },
    { 4, 5, 6 },
    { 7, 8, 9 },
}

lookup := map[rune]Vector2{
    'U' = Vector2{ 0, -1 },
    'R' = Vector2{ 1, 0 },
    'D' = Vector2{ 0, 1 },
    'L' = Vector2{ -1, 0 },
}

main :: proc() {
    input := file.read_input()
    instructions, _ := strings.split_lines(input)
    fmt.printfln("Part 1: %i", part_1(instructions))
    fmt.printfln("Part 2: %i", part_2(instructions))
}

apply_direction :: proc(position: ^Vector2, direction: ^Vector2) {
    position.x = clamp(position.x + direction.x, 0, 2)
    position.y = clamp(position.y + direction.y, 0, 2)
}

part_1 :: proc(instructions: []string) -> int {
    keypad := KEYPAD
    keypad_pos := Vector2{ 1, 1 }

    code := 0

    for instruction in instructions {
        for letter in instruction {
            direction, ok := &lookup[letter]
            assert(ok)
            apply_direction(&keypad_pos, direction)
        }

        digit := &keypad[keypad_pos.y][keypad_pos.x]
        code *= 10
        code += digit^
    }

    return code
}

part_2 :: proc(instructions: []string) -> int {
    return 0
}

@(test)
test_part_1 :: proc(t: ^testing.T) {
    instructions := []string{
        "ULL",
        "RRDDD",
        "LURDL",
        "UUUUD"
    }
    assert(part_1(instructions) == 1985)
}

@(test)
test_part_2 :: proc(t: ^testing.T) {
}