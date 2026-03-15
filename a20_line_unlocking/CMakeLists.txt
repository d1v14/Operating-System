SET(INPUT ${CMAKE_CURRENT_SOURCE_DIR}/a20_line_unlocking.asm)
SET(OUTPUT ${FLAT_BINARY_DIR}/a20_line_unlocking.bin)

message(${INPUT})
message(${OUTPUT})

add_custom_command(
        OUTPUT ${OUTPUT}
        COMMAND nasm -f bin ${INPUT} -o ${OUTPUT}
        DEPENDS ${INPUT}
        COMMENT "Generating flat binary file for ${CMAKE_CURRENT_SOURCE_DIR}!"
        VERBATIM
)
add_custom_target(a20_bin ALL DEPENDS ${OUTPUT})