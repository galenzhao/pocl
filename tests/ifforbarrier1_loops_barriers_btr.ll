; ModuleID = '../../../src/pocl.loopbarriers/tests/ifforbarrier1_loops_barriers.ll'

declare void @barrier(i32)

define void @ifforbarrier1() {
a:
  br i1 true, label %b, label %barrier.preheader.loopbarrier.prebarrier

barrier.preheader.loopbarrier.prebarrier:         ; preds = %a
  br label %barrier.preheader.loopbarrier

barrier.preheader.loopbarrier:                    ; preds = %barrier.preheader.loopbarrier.prebarrier
  call void @barrier(i32 0)
  br label %barrier.prebarrier

b:                                                ; preds = %a
  br label %d

barrier.prebarrier:                               ; preds = %c.latchbarrier.postbarrier, %barrier.preheader.loopbarrier
  br label %barrier

barrier:                                          ; preds = %barrier.prebarrier
  call void @barrier(i32 0)
  br label %barrier.postbarrier

barrier.postbarrier:                              ; preds = %barrier
  br label %c.latchbarrier.prebarrier

c.latchbarrier.prebarrier:                        ; preds = %barrier.postbarrier
  br label %c.latchbarrier

c.latchbarrier:                                   ; preds = %c.latchbarrier.prebarrier
  call void @barrier(i32 0)
  br label %c.latchbarrier.postbarrier

c.latchbarrier.postbarrier:                       ; preds = %c.latchbarrier
  br i1 true, label %barrier.prebarrier, label %d.loopexit

d.loopexit:                                       ; preds = %c.latchbarrier.postbarrier
  br label %d.btr

d:                                                ; preds = %b
  ret void

d.btr:                                            ; preds = %d.loopexit
  ret void
}
