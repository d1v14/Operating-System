SET(INPUT ${CMAKE_CURRENT_SOURCE_DIR}/hello_world.asm)
SET(OUTPUT ${FLAT_BINARY_DIR}/boot_hello_world.bin)

message(${INPUT})
message(${OUTPUT})

add_custom_command(
        OUTPUT ${OUTPUT}
        COMMAND nasm -f bin ${INPUT} -o ${OUTPUT}
        DEPENDS ${INPUT}
        COMMENT "Generating flat binary file for boot hello world!"
        VERBATIM
)
add_custom_target(target_bin ALL DEPENDS ${OUTPUT})