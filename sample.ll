; ModuleID = 'sample.c'
source_filename = "sample.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.S = type { i32, i32, i8 }
%struct.Rectangle = type { float, float, float, float }
%struct.Color = type { i8, i8, i8, i8 }
%struct.Vector2 = type { float, float }
%struct.Music = type { %struct.AudioStream, i32, i8, i32, ptr }
%struct.AudioStream = type { ptr, ptr, i32, i32, i32 }

@.str = private unnamed_addr constant [8 x i8] c"H is %i\00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"%i\00", align 1
@.str.2 = private unnamed_addr constant [22 x i8] c"color is %i %i %i %i\0A\00", align 1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @for_S(i64 %0, i8 %1) #0 {
  %3 = alloca %struct.S, align 4
  %4 = alloca { i64, i8 }, align 4
  %5 = getelementptr inbounds { i64, i8 }, ptr %4, i32 0, i32 0
  store i64 %0, ptr %5, align 4
  %6 = getelementptr inbounds { i64, i8 }, ptr %4, i32 0, i32 1
  store i8 %1, ptr %6, align 4
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %3, ptr align 4 %4, i64 12, i1 false)
  ret void
}

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias nocapture writeonly, ptr noalias nocapture readonly, i64, i1 immarg) #1

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local void @gaming(ptr noundef %0) #0 {
  %2 = alloca ptr, align 8
  store ptr %0, ptr %2, align 8
  ret void
}

; Function Attrs: noinline nounwind optnone sspstrong uwtable
define dso_local i32 @main() #2 {
  %1 = alloca i32, align 4
  %2 = alloca %struct.Rectangle, align 4
  %3 = alloca i32, align 4
  %4 = alloca ptr, align 8
  %5 = alloca [3 x i32], align 4
  %6 = alloca i32, align 4
  %7 = alloca %struct.Color, align 1
  %8 = alloca %struct.S, align 4
  %9 = alloca { i64, i8 }, align 4
  %10 = alloca %struct.Vector2, align 4
  %11 = alloca %struct.Vector2, align 4
  %12 = alloca %struct.Music, align 8
  store i32 0, ptr %1, align 4
  call void @WaitTime(double noundef 4.000000e+00)
  store i32 48, ptr %3, align 4
  %13 = call noalias ptr @malloc(i64 noundef 12) #7
  store ptr %13, ptr %4, align 8
  %14 = load ptr, ptr %4, align 8
  %15 = call ptr @realloc(ptr noundef %14, i64 noundef 24) #8
  call void @llvm.memset.p0.i64(ptr align 4 %5, i8 0, i64 12, i1 false)
  %16 = getelementptr inbounds [3 x i32], ptr %5, i64 0, i64 1
  %17 = load i32, ptr %16, align 4
  %18 = getelementptr inbounds [3 x i32], ptr %5, i64 0, i64 0
  store i32 %17, ptr %18, align 4
  store i32 5, ptr %6, align 4
  %19 = load i32, ptr %6, align 4
  %20 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %19)
  %21 = getelementptr inbounds %struct.Color, ptr %7, i32 0, i32 0
  store i8 -1, ptr %21, align 1
  %22 = getelementptr inbounds %struct.Color, ptr %7, i32 0, i32 1
  store i8 60, ptr %22, align 1
  br label %23

23:                                               ; preds = %26, %0
  %24 = load i32, ptr %6, align 4
  %25 = icmp eq i32 %24, 5
  br i1 %25, label %26, label %28

26:                                               ; preds = %23
  %27 = call i32 (ptr, ...) @__isoc99_scanf(ptr noundef @.str.1, ptr noundef %6)
  br label %23, !llvm.loop !6

28:                                               ; preds = %23
  call void @gaming(ptr noundef %6)
  %29 = getelementptr inbounds %struct.Color, ptr %7, i32 0, i32 0
  %30 = load i8, ptr %29, align 1
  %31 = zext i8 %30 to i32
  switch i32 %31, label %34 [
    i32 1, label %32
  ]

32:                                               ; preds = %28
  %33 = getelementptr inbounds %struct.Color, ptr %7, i32 0, i32 0
  store i8 1, ptr %33, align 1
  br label %36

34:                                               ; preds = %28
  %35 = getelementptr inbounds %struct.Color, ptr %7, i32 0, i32 0
  store i8 2, ptr %35, align 1
  br label %36

36:                                               ; preds = %34, %32
  %37 = getelementptr inbounds %struct.Color, ptr %7, i32 0, i32 0
  %38 = load i8, ptr %37, align 1
  %39 = zext i8 %38 to i32
  %40 = getelementptr inbounds %struct.Color, ptr %7, i32 0, i32 1
  %41 = load i8, ptr %40, align 1
  %42 = zext i8 %41 to i32
  %43 = getelementptr inbounds %struct.Color, ptr %7, i32 0, i32 2
  %44 = load i8, ptr %43, align 1
  %45 = zext i8 %44 to i32
  %46 = getelementptr inbounds %struct.Color, ptr %7, i32 0, i32 3
  %47 = load i8, ptr %46, align 1
  %48 = zext i8 %47 to i32
  %49 = call i32 (ptr, ...) @printf(ptr noundef @.str.2, i32 noundef %39, i32 noundef %42, i32 noundef %45, i32 noundef %48)
  call void @llvm.memcpy.p0.p0.i64(ptr align 4 %9, ptr align 4 %8, i64 12, i1 false)
  %50 = getelementptr inbounds { i64, i8 }, ptr %9, i32 0, i32 0
  %51 = load i64, ptr %50, align 4
  %52 = getelementptr inbounds { i64, i8 }, ptr %9, i32 0, i32 1
  %53 = load i8, ptr %52, align 4
  call void @for_S(i64 %51, i8 %53)
  %54 = load <2 x float>, ptr %10, align 4
  %55 = load <2 x float>, ptr %11, align 4
  %56 = load i32, ptr %7, align 1
  call void @DrawRectangleV(<2 x float> %54, <2 x float> %55, i32 %56)
  call void @PlayMusicStream(ptr noundef byval(%struct.Music) align 8 %12)
  %57 = load i32, ptr %7, align 1
  call void @ClearBackground(i32 %57)
  %58 = load i32, ptr %1, align 4
  ret i32 %58
}

declare void @WaitTime(double noundef) #3

; Function Attrs: nounwind allocsize(0)
declare noalias ptr @malloc(i64 noundef) #4

; Function Attrs: nounwind allocsize(1)
declare ptr @realloc(ptr noundef, i64 noundef) #5

; Function Attrs: nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #6

declare i32 @printf(ptr noundef, ...) #3

declare i32 @__isoc99_scanf(ptr noundef, ...) #3

declare void @DrawRectangleV(<2 x float>, <2 x float>, i32) #3

declare void @PlayMusicStream(ptr noundef byval(%struct.Music) align 8) #3

declare void @ClearBackground(i32) #3

attributes #0 = { noinline nounwind optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nocallback nofree nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { noinline nounwind optnone sspstrong uwtable "frame-pointer"="all" "min-legal-vector-width"="64" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind allocsize(0) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind allocsize(1) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #6 = { nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #7 = { nounwind allocsize(0) }
attributes #8 = { nounwind allocsize(1) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 18.1.8"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
