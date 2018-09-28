# run with QtSpim -file main.s question_4.s

# int find_minimum_index(int *array, int length) {
#     int min = array[0];
#     int min_index = 0;
#
#     for (int i = 1; i < length; i++) {
#         if (array[i] < min) {
#             min = array[i];
#             min_index = i;
#         }
#     }
#
#     return min_index;
# }
.globl find_minimum_index
find_minimum_index:
