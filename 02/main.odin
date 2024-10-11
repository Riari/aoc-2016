package main

import "core:fmt"
import "core:os"
import "core:strconv"
import "core:strings"
import "core:testing"
import "core:unicode/utf8"

import "../utils"

Vector2 :: struct {
    x: int,
    y: int,
}

Keypad :: [][]rune

lookup := map[rune]Vector2{
    'U' = Vector2{ 0, -1 },
    'R' = Vector2{ 1, 0 },
    'D' = Vector2{ 0, 1 },
    'L' = Vector2{ -1, 0 },
}

main :: proc() {
    input := utils.read_input()
    instructions, _ := strings.split_lines(input)

    part_1_result := part_1(instructions)
    part_2_result := part_2(instructions)

    fmt.printfln("Part 1: %s", part_1_result)
    fmt.printfln("Part 2: %s", part_2_result)

    delete(part_1_result)
    delete(part_2_result)
}

apply_direction :: proc(position: ^Vector2, direction: ^Vector2, keypad: ^Keypad) {
    position.x = clamp(position.x + direction.x, 0, len(keypad[0]) - 1)
    position.y = clamp(position.y + direction.y, 0, len(keypad) - 1)

    // Undo if not a valid key
    if keypad[position.y][position.x] == '_' {
        position.x -= direction.x
        position.y -= direction.y
    }
}

solve :: proc(keypad: ^Keypad, starting_pos: ^Vector2, instructions: []string) -> string {
    keypad_pos := starting_pos
    code := [dynamic]rune{}
    for instruction in instructions {
        for letter in instruction {
            direction, ok := &lookup[letter]
            assert(ok)
            apply_direction(keypad_pos, direction, keypad)
        }

        value := keypad[keypad_pos.y][keypad_pos.x]
        append(&code, value)
    }

    result := utf8.runes_to_string(code[:])
    delete(code)

    return result
}

part_1 :: proc(instructions: []string) -> string {
    keypad := Keypad{
        { '1', '2', '3' },
        { '4', '5', '6' },
        { '7', '8', '9' },
    }

    return solve(&keypad, &Vector2{ 1, 1 }, instructions)
}

part_2 :: proc(instructions: []string) -> string {
    keypad := Keypad{
        { '_', '_', '1', '_', '_' },
        { '_', '2', '3', '4', '_' },
        { '5', '6', '7', '8', '9' },
        { '_', 'A', 'B', 'C', '_' },
        { '_', '_', 'D', '_', '_' },
    }

    return solve(&keypad, &Vector2{ 0, 2 }, instructions)
}

@(test)
test_part_1 :: proc(t: ^testing.T) {
    instructions := []string{
        "ULL",
        "RRDDD",
        "LURDL",
        "UUUUD"
    }
    result := part_1(instructions)
    assert(result == "1985")
    delete(result)
}

@(test)
test_part_2 :: proc(t: ^testing.T) {
    instructions := []string{
        "ULL",
        "RRDDD",
        "LURDL",
        "UUUUD"
    }
    result := part_2(instructions)
    assert(result == "5DB3")
    delete(result)
}