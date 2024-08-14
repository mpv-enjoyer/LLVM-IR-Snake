@.str = private unnamed_addr constant [34 x i8] c"LLVM IR Snake (powered by Raylib)\00"
@.str.1 = private unnamed_addr constant [28 x i8] c"Current stack size: %zu %zu\00"
@.str.2 = private unnamed_addr constant [29 x i8] c"Stack upper bound: X %i Y %i\00"
@.str.3 = private unnamed_addr constant [22 x i8] c"\0AStack dump %i %i: | \00"
@.str.4 = private unnamed_addr constant [22 x i8] c"X %i Y %i State %c | \00"
@.str.5 = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str.6 = private unnamed_addr constant [42 x i8] c"Drawing rect for x1 %i y1 %i x2 %i y2 %i\0A\00"

%struct.turn = type <{ i32, i32, i8 }> ; X Y State{Right Up Left Down}
%struct.stack = type { ptr, i32, i32 } ; turns size capacity

; tail_stack funcs:
; (yup, it's not a stack but a queue. I can't rename everything already)

define dso_local void @tail_stack_dump(ptr %stack) {
  %stack_size_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 1
  %stack_size_val = load i32, ptr %stack_size_ptr
  %stack_capacity_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 2
  %stack_capacity_val = load i32, ptr %stack_capacity_ptr

  call i32 @printf(ptr @.str.3, i32 %stack_size_val, i32 %stack_capacity_val)

  %index_ptr = alloca i32
  store i32 -1, ptr %index_ptr
  br label %loop_cond

loop_cond:
  %index_val = load i32, ptr %index_ptr
  %index_increased_val = add i32 %index_val, 1
  store i32 %index_increased_val, ptr %index_ptr
  %continue_loop = icmp slt i32 %index_increased_val, %stack_size_val
  br i1 %continue_loop, label %loop_body, label %end

loop_body:
  %turns_ptr_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 0
  %turns_ptr = load ptr, ptr %turns_ptr_ptr
  ; index_increased_val is the index we need
  %turn_x_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %index_increased_val, i32 0
  %x = load i32, ptr %turn_x_ptr
  %turn_y_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %index_increased_val, i32 1
  %y = load i32, ptr %turn_y_ptr
  %turn_state_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %index_increased_val, i32 2
  %state = load i8, ptr %turn_state_ptr
  %state_char = add i8 %state, 48 ; '0'
  call i32 @printf(ptr @.str.4, i32 %x, i32 %y, i8 %state_char)
  br label %loop_cond

end:
  call i32 @printf(ptr @.str.5)
  ret void
}

define dso_local void @tail_stack_init(ptr %stack) {
  %turns_ptr = call noalias ptr @malloc(i64 9) ; 4 + 4 + 1

  %turn_x_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 0, i32 0
  store i32 200, ptr %turn_x_ptr
  %turn_y_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 0, i32 1
  store i32 200, ptr %turn_y_ptr
  %turn_state_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 0, i32 2
  store i8 0, ptr %turn_state_ptr

  %output_turns_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 0
  store ptr %turns_ptr, ptr %output_turns_ptr
  %output_size_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 1
  store i32 1, ptr %output_size_ptr
  %output_capacity_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 2
  store i32 1, ptr %output_capacity_ptr

  call void @tail_stack_dump(ptr %stack)
  ret void
}

define dso_local void @tail_stack_add(ptr %stack, i32 %x, i32 %y, i8 %state) {
  %stack_size_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 1
  %stack_size_val = load i32, ptr %stack_size_ptr
  %stack_capacity_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 2
  %stack_capacity_val = load i32, ptr %stack_capacity_ptr

  %should_increase_capacity = icmp eq i32 %stack_capacity_val, %stack_size_val
  br i1 %should_increase_capacity, label %increase_capacity, label %increase_capacity_end

increase_capacity:
  %stack_capacity_increased = mul i32 %stack_capacity_val, 2
  store i32 %stack_capacity_increased, ptr %stack_capacity_ptr
  %new_stack_byte_size = mul i32 %stack_capacity_increased, 9 ; 4 + 4 + 1
  %new_stack_byte_size_64 = zext i32 %new_stack_byte_size to i64
  %turns_ptr_ptr_to_update = getelementptr %struct.stack, ptr %stack, i32 0, i32 0
  %old_turns_ptr = load ptr, ptr %turns_ptr_ptr_to_update
  %updated_turns_ptr = call ptr @realloc(ptr %old_turns_ptr, i64 %new_stack_byte_size_64)
  store ptr %updated_turns_ptr, ptr %turns_ptr_ptr_to_update
  br label %increase_capacity_end

increase_capacity_end:
  %stack_size_increased = add i32 %stack_size_val, 1
  store i32 %stack_size_increased, ptr %stack_size_ptr
  
  %turns_ptr_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 0
  %turns_ptr = load ptr, ptr %turns_ptr_ptr
  ; old stack_size_val is the index we need
  %turn_x_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %stack_size_val, i32 0
  store i32 %x, ptr %turn_x_ptr
  %turn_y_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %stack_size_val, i32 1
  store i32 %y, ptr %turn_y_ptr
  %turn_state_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %stack_size_val, i32 2
  store i8 %state, ptr %turn_state_ptr

  call void @tail_stack_dump(ptr %stack)
  ret void
}

define dso_local void @tail_stack_pop(ptr %stack) {
  %stack_size_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 1
  %stack_size_val = load i32, ptr %stack_size_ptr
  %stack_size_val_updated = sub i32 %stack_size_val, 1
  store i32 %stack_size_val_updated, ptr %stack_size_ptr
  
  %bottom_index_ptr = alloca i32
  store i32 -1, ptr %bottom_index_ptr
  br label %loop_cond

loop_cond:
  %bottom_index_val = load i32, ptr %bottom_index_ptr
  %bottom_index_val_increased = add i32 %bottom_index_val, 1
  store i32 %bottom_index_val_increased, ptr %bottom_index_ptr
  ; old 0 1 2 3 4 5 ... N - 1, size N
  ; new 0 1 2 3 4 5 ... N - 2, size N - 1
  ; bottom checks:
  ;     0 1 2 3 4 5 ... N - 2, break on N - 1
  %continue_loop = icmp ne i32 %bottom_index_val_increased, %stack_size_val_updated
  br i1 %continue_loop, label %loop_body, label %end

loop_body:
  ; use _val_increased here
  %top_index_val_increased = add i32 %bottom_index_val_increased, 1
  
  %turns_ptr_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 0
  %turns_ptr = load ptr, ptr %turns_ptr_ptr
  %top_index_turn_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %top_index_val_increased, i32 0
  %bottom_index_turn_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %bottom_index_val_increased, i32 0
  
  %top_index_turn_val = load %struct.turn, ptr %top_index_turn_ptr
  store %struct.turn %top_index_turn_val, ptr %bottom_index_turn_ptr
  br label %loop_cond

end:
  call void @tail_stack_dump(ptr %stack)
  ret void
}

; snake processing funcs:

define dso_local void @update_snake_pos(ptr %x, ptr %y, ptr %state) {
%x_val = load i32, ptr %x
%y_val = load i32, ptr %y
%state_val = load i8, ptr %state
switch i8 %state_val, label %down [i8 0, label %right
                                   i8 1, label %up
                                   i8 2, label %left]
right:
  %x_r = add i32 1, %x_val
  store i32 %x_r, ptr %x
  ret void
up:
  %y_u = add i32 -1, %y_val
  store i32 %y_u, ptr %y
  ret void
left:
  %x_l = add i32 -1, %x_val
  store i32 %x_l, ptr %x
  ret void
down:
  %y_d = add i32 1, %y_val
  store i32 %y_d, ptr %y
  ret void
}

define dso_local i1 @is_head_inbounds(i32 %x_val, i32 %y_val, i32 %max_x_val, i32 %max_y_val) {
  %cond1 = icmp sge i32 %x_val, 0
  br i1 %cond1, label %continue1, label %false

continue1:
  %cond2 = icmp sge i32 %y_val, 0
  br i1 %cond2, label %continue2, label %false

continue2:
  %cond3 = icmp sle i32 %x_val, %max_x_val
  br i1 %cond3, label %continue3, label %false

continue3:
  %cond4 = icmp sle i32 %y_val, %max_y_val
  ret i1 %cond4

false:
  ret i1 0
}

; the function below is ripped off from raylib's CheckCollisionRecs(Rectangle rec1, Rectangle rec2)
define dso_local i1 @collision_snake_recs(i32 %x_val, i32 %y_val, i32 %last_x_val, i32 %last_y_val) {
 ; x_val y_val is rec1, last_x_val last_y_val is rec2
  
  ; rec1.x < (rec2.x + rec2.width)
  %right2 = add i32 %last_x_val, 20
  %cond1 = icmp slt i32 %x_val, %right2
  br i1 %cond1, label %continue_1, label %false 

continue_1:
  ; (rec1.x + rec1.width) > rec2.x
  %right1 = add i32 %x_val, 20
  %cond2 = icmp sgt i32 %right1, %last_x_val
  br i1 %cond2, label %continue_2, label %false

continue_2:
  ; rec1.y < (rec2.y + rec2.height)
  %bottom2 = add i32 %last_y_val, 20
  %cond3 = icmp slt i32 %y_val, %bottom2
  br i1 %cond3, label %continue_3, label %false

continue_3:
  ; (rec1.y + rec1.height) > rec2.y
  %bottom1 = add i32 %y_val, 20
  %cond4 = icmp sgt i32 %bottom1, %last_y_val
  ret i1 %cond4

false:
  ret i1 0
}

define dso_local i1 @snake_pre_rotate_collision(i32 %x_val, i32 %y_val, i8 %new_state_val, ptr %stack) {
  %stack_size_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 1
  %stack_size_val = load i32, ptr %stack_size_ptr
  %fetch_element_exists = icmp sgt i32 %stack_size_val, 1
  br i1 %fetch_element_exists, label %continue, label %false

continue:
  %turns_ptr_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 0
  %turns_ptr = load ptr, ptr %turns_ptr_ptr
  %prepre_last_element_index = sub i32 %stack_size_val, 2
  %prepre_state_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %prepre_last_element_index, i32 2
  %prepre_state_val = load i8, ptr %prepre_state_ptr
  %can_collide = icmp ne i8 %new_state_val, %prepre_state_val
  br i1 %can_collide, label %continue_2, label %false

continue_2:
  %last_element_index = sub i32 %stack_size_val, 1
  %last_x_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %last_element_index, i32 0
  %last_y_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %last_element_index, i32 1
  %last_x_val = load i32, ptr %last_x_ptr
  %last_y_val = load i32, ptr %last_y_ptr
  %result = call i1 @collision_snake_recs(i32 %x_val, i32 %y_val, i32 %last_x_val, i32 %last_y_val)
  ret i1 %result

false:
  ret i1 0
}

define dso_local i1 @update_snake_state(i32 %x_val, i32 %y_val, ptr %state, ptr %stack) {
  %output = alloca i1
  store i1 0, ptr %output
  %state_val = load i8, ptr %state
  %state_val_rem_2 = srem i8 %state_val, 2
  %ignore_horizontal = icmp eq i8 %state_val_rem_2, 0
  %ignore_vertical = icmp eq i8 %state_val_rem_2, 1

  br label %loop
loop:
  %key = call i32 @GetKeyPressed()
switch i32 %key, label %loop [i32 262, label %right
                              i32 265, label %up
                              i32 263, label %left
                              i32 264, label %down
                              i32 0,   label %exit]
right:
  %collision_right = call i1 @snake_pre_rotate_collision(i32 %x_val, i32 %y_val, i8 0, ptr %stack)
  %ignore_right = or i1 %ignore_horizontal, %collision_right
  br i1 %ignore_right, label %loop, label %right_continue

right_continue:
  store i8 0, ptr %state
  store i1 1, ptr %output
  br label %loop

up:
  %collision_up = call i1 @snake_pre_rotate_collision(i32 %x_val, i32 %y_val, i8 1, ptr %stack)
  %ignore_up = or i1 %ignore_vertical, %collision_up
  br i1 %ignore_up, label %loop, label %up_continue

up_continue:
  store i8 1, ptr %state
  store i1 1, ptr %output
  br label %loop

left:
  %collision_left = call i1 @snake_pre_rotate_collision(i32 %x_val, i32 %y_val, i8 2, ptr %stack)
  %ignore_left = or i1 %ignore_horizontal, %collision_left
  br i1 %ignore_left, label %loop, label %left_continue

left_continue:
  store i8 2, ptr %state
  store i1 1, ptr %output
  br label %loop

down:
  %collision_down = call i1 @snake_pre_rotate_collision(i32 %x_val, i32 %y_val, i8 3, ptr %stack)
  %ignore_down = or i1 %ignore_vertical, %collision_down
  br i1 %ignore_down, label %loop, label %down_continue

down_continue:
  store i8 3, ptr %state
  store i1 1, ptr %output
  br label %loop

exit:
  %output_val = load i1, ptr %output
  ret i1 %output_val
}

define dso_local void @snake_check_tail_tail_collision(ptr %stack) {
  %stack_size_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 1
  %stack_size_val = load i32, ptr %stack_size_ptr
  %should_check = icmp sgt i32 %stack_size_val, 1
  br i1 %should_check, label %check, label %end

check:
  %turns_ptr_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 0
  %turns_ptr = load ptr, ptr %turns_ptr_ptr

  %first_x_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 0, i32 0
  %first_y_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 0, i32 1
  %first_x_val = load i32, ptr %first_x_ptr
  %first_y_val = load i32, ptr %first_y_ptr

  %second_x_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 1, i32 0
  %second_y_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 1, i32 1
  %second_x_val = load i32, ptr %second_x_ptr
  %second_y_val = load i32, ptr %second_y_ptr

  %x_same = icmp eq i32 %first_x_val, %second_x_val
  %y_same = icmp eq i32 %first_y_val, %second_y_val
  %coords_same = and i1 %x_same, %y_same
  br i1 %coords_same, label %pop, label %end

pop:
  call void @tail_stack_pop(ptr %stack)
  ret void

end:
  ret void
}

define dso_local void @snake_logic(ptr %stack, ptr %x, ptr %y, ptr %state, i1 %shrink) {
  %x_val = load i32, ptr %x
  %y_val = load i32, ptr %y
  %state_changed = call i1 @update_snake_state(i32 %x_val, i32 %y_val, ptr %state, ptr %stack)
  %state_val = load i8, ptr %state ; state must be updated here
  br i1 %state_changed, label %add_turn, label %add_turn_end

add_turn:
  call void @tail_stack_add(ptr %stack, i32 %x_val, i32 %y_val, i8 %state_val)
  br label %add_turn_end

add_turn_end:
  call void @update_snake_pos(ptr %x, ptr %y, ptr %state)

  %turns_ptr_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 0
  %turns_ptr = load ptr, ptr %turns_ptr_ptr
  ; 0 is the index we need
  %turn_x_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 0, i32 0
  %turn_y_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 0, i32 1
  %turn_state_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 0, i32 2
  br i1 %shrink, label %shrink_trail, label %shrink_trail_end

shrink_trail:
  call void @update_snake_pos(ptr %turn_x_ptr, ptr %turn_y_ptr, ptr %turn_state_ptr)
  call void @snake_check_tail_tail_collision(ptr %stack)
  br label %shrink_trail_end

shrink_trail_end:
  %turn_x_val = load i32, ptr %turn_x_ptr
  %turn_y_val = load i32, ptr %turn_y_ptr
  %turn_state_val = load i8, ptr %turn_state_ptr

  call i32 @printf(ptr @.str.3, i32 %x_val, i32 %y_val)
  ret void
}

define dso_local void @draw_snake_trail_part(i32 %x_1_val, i32 %y_1_val, i8 %state_1_val, i32 %x_2_val, i32 %y_2_val) {
  call i32 @printf(ptr @.str.6, i32 %x_1_val, i32 %y_1_val, i32 %x_2_val, i32 %y_2_val)
  switch i8 %state_1_val, label %down [i8 0, label %right
                                       i8 1, label %up
                                       i8 2, label %left]
right:
  %right_w_pre = sub i32 %x_2_val, %x_1_val
  %right_w = add i32 %right_w_pre, 20
  call void @DrawRectangle(i32 %x_1_val, i32 %y_1_val, i32 %right_w, i32 20, i32 u0xff000000)
  ret void

up:
  %up_h_pre = sub i32 %y_1_val, %y_2_val
  %up_h = add i32 %up_h_pre, 20
  call void @DrawRectangle(i32 %x_2_val, i32 %y_2_val, i32 20, i32 %up_h, i32 u0xff000000)
  ret void

left:
  %left_w_pre = sub i32 %x_1_val, %x_2_val
  %left_w = add i32 %left_w_pre, 20
  call void @DrawRectangle(i32 %x_2_val, i32 %y_2_val, i32 %left_w, i32 20, i32 u0xff000000)
  ret void

down:
  %down_h_pre = sub i32 %y_2_val, %y_1_val
  %down_h = add i32 %down_h_pre, 20
  call void @DrawRectangle(i32 %x_1_val, i32 %y_1_val, i32 20, i32 %down_h, i32 u0xff000000)
  ret void
}

define dso_local void @draw_snake(ptr %stack, ptr %x_ptr, ptr %y_ptr) {
  %turns_ptr_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 0
  %turns_ptr = load ptr, ptr %turns_ptr_ptr

  %stack_size_ptr = getelementptr %struct.stack, ptr %stack, i32 0, i32 1
  %stack_size_val = load i32, ptr %stack_size_ptr
  %last_element_id = sub i32 %stack_size_val, 1
  
  %bottom_index_ptr = alloca i32
  store i32 -1, ptr %bottom_index_ptr
  br label %loop_cond

loop_cond:
  ; use last_element_id as the stopping point for bottom id value
  %bottom_index_val = load i32, ptr %bottom_index_ptr
  %bottom_index_val_increased = add i32 %bottom_index_val, 1
  store i32 %bottom_index_val_increased, ptr %bottom_index_ptr
  %continue_loop = icmp slt i32 %bottom_index_val_increased, %last_element_id
  br i1 %continue_loop, label %loop_body, label %loop_end

loop_body:
  ; use _val_increased here
  %top_index_val_increased = add i32 %bottom_index_val_increased, 1

  %bottom_turn_x_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %bottom_index_val_increased, i32 0
  %bottom_turn_y_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %bottom_index_val_increased, i32 1
  %bottom_turn_state_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %bottom_index_val_increased, i32 2

  %top_turn_x_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %top_index_val_increased, i32 0
  %top_turn_y_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %top_index_val_increased, i32 1

  %bottom_turn_x_val = load i32, ptr %bottom_turn_x_ptr
  %bottom_turn_y_val = load i32, ptr %bottom_turn_y_ptr
  %bottom_turn_state_val = load i8, ptr %bottom_turn_state_ptr
  %top_turn_x_val = load i32, ptr %top_turn_x_ptr
  %top_turn_y_val = load i32, ptr %top_turn_y_ptr
  call void @draw_snake_trail_part(i32 %bottom_turn_x_val, i32 %bottom_turn_y_val, i8 %bottom_turn_state_val, i32 %top_turn_x_val, i32 %top_turn_y_val)
  br label %loop_cond

loop_end:
  %last_turn_x_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %last_element_id, i32 0
  %last_turn_y_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %last_element_id, i32 1
  %last_turn_state_ptr = getelementptr %struct.turn, ptr %turns_ptr, i32 %last_element_id, i32 2

  %last_turn_x_val = load i32, ptr %last_turn_x_ptr
  %last_turn_y_val = load i32, ptr %last_turn_y_ptr
  %last_turn_state_val = load i8, ptr %last_turn_state_ptr

  %x_val = load i32, ptr %x_ptr
  %y_val = load i32, ptr %y_ptr
  
  call void @draw_snake_trail_part(i32 %last_turn_x_val, i32 %last_turn_y_val, i8 %last_turn_state_val, i32 %x_val, i32 %y_val)
  ret void
}

define dso_local i32 @main() {
  %stack = alloca %struct.stack
  call void @tail_stack_init(ptr %stack)
  %x = alloca i32
  store i32 220, ptr %x
  %y = alloca i32
  store i32 200, ptr %y
  %state = alloca i8
  store i8 0, ptr %state

  call void @InitWindow(i32 600, i32 400, ptr @.str)
  call void @SetTargetFPS(i32 120)

  %frame_counter = alloca i32
  store i32 0, ptr %frame_counter
  br label %main_loop_cond

main_loop_cond:
  %should_close = call i1 @WindowShouldClose()
  br i1 %should_close, label %main_loop_end, label %main_loop_body

main_loop_body:
  %frame_counter_val = load i32, ptr %frame_counter
  %frame_counter_val_incremented = add i32 %frame_counter_val, 1
  store i32 %frame_counter_val_incremented, ptr %frame_counter

  %rem = srem i32 %frame_counter_val_incremented, 5
  %should_shrink = icmp ne i32 %rem, 0
  call void @snake_logic(ptr %stack, ptr %x, ptr %y, ptr %state, i1 %should_shrink)
  call void @tail_stack_dump(ptr %stack)
  call void @BeginDrawing()
  call void @ClearBackground(i32 u0xffaa99bb)
  call void @draw_snake(ptr %stack, ptr %x, ptr %y)
  call void @EndDrawing()
  
  %current_head_x = load i32, ptr %x
  %current_head_y = load i32, ptr %y
  %inbounds = call i1 @is_head_inbounds(i32 %current_head_x, i32 %current_head_y, i32 580, i32 380)
  ; TODO: snake-snake collision
  br i1 %inbounds, label %main_loop_cond, label %player_dead

player_dead:
  %background_a_ptr = alloca i32
  store i32 u0x00000000, ptr %background_a_ptr
  br label %player_dead_loop_cond

player_dead_loop_cond:
  %background_a_val = load i32, ptr %background_a_ptr
  %background_a_val_increased = add i32 %background_a_val, u0x01000000
  store i32 %background_a_val_increased, ptr %background_a_ptr
  %continue_dead_loop = icmp ult i32 %background_a_val_increased, u0xff000000
  br i1 %continue_dead_loop, label %player_dead_loop, label %main_loop_end

player_dead_loop:
  call void @BeginDrawing()
  call void @ClearBackground(i32 u0xffaa99bb)
  call void @draw_snake(ptr %stack, ptr %x, ptr %y)
  call void @DrawRectangle(i32 0, i32 0, i32 600, i32 400, i32 %background_a_val_increased)
  call void @EndDrawing()
  br label %player_dead_loop_cond

main_loop_end:
  call void @CloseWindow()
  ret i32 0
}

declare noalias ptr @malloc(i64) ; TODO: maybe get rid of heap allocations? :)
declare ptr @realloc(ptr, i64)
declare i32 @printf(ptr, ...)
declare ptr @TextFormat(ptr, ...)
declare void @InitWindow(i32, i32, ptr)
declare i1 @WindowShouldClose()
declare void @ClearBackground(i32)
declare void @BeginDrawing()
declare void @EndDrawing()
declare void @CloseWindow()
declare void @DrawRectangle(i32, i32, i32, i32, i32) ; X Y W H Color
declare void @DrawText(ptr, i32, i32, i32, i32) ; text X Y font_size Color
declare void @SetTargetFPS(i32)
declare i32 @GetKeyPressed()
declare void @WaitTime(double)