SET(INPUT ${CMAKE_CURRENT_SOURCE_DIR}/fast_a20_line_unlocking.asm)
SET(OUTPUT ${FLAT_BINARY_DIR}/fast_a20_line_unlocking.bin)

message(${INPUT})
message(${OUTPUT})

add_custom_command(
        OUTPUT ${OUTPUT}
        COMMAND nasm -f bin ${INPUT} -o ${OUTPUT}
        DEPENDS ${INPUT}
        COMMENT "Generating flat binary file for ${CMAKE_CURRENT_SOURCE_DIR}!"
        VERBATIM
)
add_custom_target(fast_a20_bin ALL DEPENDS ${OUTPUT})