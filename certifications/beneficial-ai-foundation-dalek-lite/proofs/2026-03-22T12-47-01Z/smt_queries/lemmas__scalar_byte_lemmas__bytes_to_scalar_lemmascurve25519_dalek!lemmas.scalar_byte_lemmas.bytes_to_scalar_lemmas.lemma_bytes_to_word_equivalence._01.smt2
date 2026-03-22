(set-option :auto_config false)
(set-option :smt.mbqi false)
(set-option :smt.case_split 3)
(set-option :smt.qi.eager_threshold 100.0)
(set-option :smt.delay_units true)
(set-option :smt.arith.solver 2)
(set-option :smt.arith.nl false)
(set-option :pi.enabled false)
(set-option :rewriter.sort_disjunctions false)

;; Prelude

;; AIR prelude
(declare-sort %%Function%% 0)

(declare-sort FuelId 0)
(declare-sort Fuel 0)
(declare-const zero Fuel)
(declare-fun succ (Fuel) Fuel)
(declare-fun fuel_bool (FuelId) Bool)
(declare-fun fuel_bool_default (FuelId) Bool)
(declare-const fuel_defaults Bool)
(assert
 (=>
  fuel_defaults
  (forall ((id FuelId)) (!
    (= (fuel_bool id) (fuel_bool_default id))
    :pattern ((fuel_bool id))
    :qid prelude_fuel_defaults
    :skolemid skolem_prelude_fuel_defaults
))))
(declare-datatypes ((fndef 0)) (((fndef_singleton))))
(declare-sort Poly 0)
(declare-sort Height 0)
(declare-fun I (Int) Poly)
(declare-fun B (Bool) Poly)
(declare-fun R (Real) Poly)
(declare-fun F (fndef) Poly)
(declare-fun %I (Poly) Int)
(declare-fun %B (Poly) Bool)
(declare-fun %R (Poly) Real)
(declare-fun %F (Poly) fndef)
(declare-sort Type 0)
(declare-const BOOL Type)
(declare-const INT Type)
(declare-const NAT Type)
(declare-const REAL Type)
(declare-const CHAR Type)
(declare-const USIZE Type)
(declare-const ISIZE Type)
(declare-const TYPE%tuple%0. Type)
(declare-fun UINT (Int) Type)
(declare-fun SINT (Int) Type)
(declare-fun FLOAT (Int) Type)
(declare-fun CONST_INT (Int) Type)
(declare-fun CONST_BOOL (Bool) Type)
(declare-sort Dcr 0)
(declare-const $ Dcr)
(declare-const $slice Dcr)
(declare-const $dyn Dcr)
(declare-fun DST (Dcr) Dcr)
(declare-fun REF (Dcr) Dcr)
(declare-fun MUT_REF (Dcr) Dcr)
(declare-fun BOX (Dcr Type Dcr) Dcr)
(declare-fun RC (Dcr Type Dcr) Dcr)
(declare-fun ARC (Dcr Type Dcr) Dcr)
(declare-fun GHOST (Dcr) Dcr)
(declare-fun TRACKED (Dcr) Dcr)
(declare-fun NEVER (Dcr) Dcr)
(declare-fun CONST_PTR (Dcr) Dcr)
(declare-fun ARRAY (Dcr Type Dcr Type) Type)
(declare-fun MUTREF (Dcr Type) Type)
(declare-fun SLICE (Dcr Type) Type)
(declare-const STRSLICE Type)
(declare-const ALLOCATOR_GLOBAL Type)
(declare-fun PTR (Dcr Type) Type)
(declare-fun has_type (Poly Type) Bool)
(declare-fun sized (Dcr) Bool)
(declare-fun as_type (Poly Type) Poly)
(declare-fun mk_fun (%%Function%%) %%Function%%)
(declare-fun const_int (Type) Int)
(declare-fun const_bool (Type) Bool)
(declare-fun mut_ref_current% (Poly) Poly)
(declare-fun mut_ref_future% (Poly) Poly)
(declare-fun mut_ref_update_current% (Poly Poly) Poly)
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_current% (mut_ref_update_current% m arg)) arg)
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_current
   :skolemid skolem_prelude_mut_ref_update_current_current
)))
(assert
 (forall ((m Poly) (arg Poly)) (!
   (= (mut_ref_future% (mut_ref_update_current% m arg)) (mut_ref_future% m))
   :pattern ((mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_current_future
   :skolemid skolem_prelude_mut_ref_update_current_future
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_current% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_current% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type)) (!
   (=>
    (has_type m (MUTREF d t))
    (has_type (mut_ref_future% m) t)
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_future% m))
   :qid prelude_mut_ref_current_has_type
   :skolemid skolem_prelude_mut_ref_current_has_type
)))
(assert
 (forall ((m Poly) (d Dcr) (t Type) (arg Poly)) (!
   (=>
    (and
     (has_type m (MUTREF d t))
     (has_type arg t)
    )
    (has_type (mut_ref_update_current% m arg) (MUTREF d t))
   )
   :pattern ((has_type m (MUTREF d t)) (mut_ref_update_current% m arg))
   :qid prelude_mut_ref_update_has_type
   :skolemid skolem_prelude_mut_ref_update_has_type
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (sized (DST d))
   )
   :pattern ((sized (DST d)))
   :qid prelude_sized_decorate_struct_inherit
   :skolemid skolem_prelude_sized_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (sized (REF d))
   :pattern ((sized (REF d)))
   :qid prelude_sized_decorate_ref
   :skolemid skolem_prelude_sized_decorate_ref
)))
(assert
 (forall ((d Dcr)) (!
   (sized (MUT_REF d))
   :pattern ((sized (MUT_REF d)))
   :qid prelude_sized_decorate_mut_ref
   :skolemid skolem_prelude_sized_decorate_mut_ref
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (BOX d t d2))
   :pattern ((sized (BOX d t d2)))
   :qid prelude_sized_decorate_box
   :skolemid skolem_prelude_sized_decorate_box
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (RC d t d2))
   :pattern ((sized (RC d t d2)))
   :qid prelude_sized_decorate_rc
   :skolemid skolem_prelude_sized_decorate_rc
)))
(assert
 (forall ((d Dcr) (t Type) (d2 Dcr)) (!
   (sized (ARC d t d2))
   :pattern ((sized (ARC d t d2)))
   :qid prelude_sized_decorate_arc
   :skolemid skolem_prelude_sized_decorate_arc
)))
(assert
 (forall ((d Dcr)) (!
   (sized (GHOST d))
   :pattern ((sized (GHOST d)))
   :qid prelude_sized_decorate_ghost
   :skolemid skolem_prelude_sized_decorate_ghost
)))
(assert
 (forall ((d Dcr)) (!
   (sized (TRACKED d))
   :pattern ((sized (TRACKED d)))
   :qid prelude_sized_decorate_tracked
   :skolemid skolem_prelude_sized_decorate_tracked
)))
(assert
 (forall ((d Dcr)) (!
   (sized (NEVER d))
   :pattern ((sized (NEVER d)))
   :qid prelude_sized_decorate_never
   :skolemid skolem_prelude_sized_decorate_never
)))
(assert
 (forall ((d Dcr)) (!
   (sized (CONST_PTR d))
   :pattern ((sized (CONST_PTR d)))
   :qid prelude_sized_decorate_const_ptr
   :skolemid skolem_prelude_sized_decorate_const_ptr
)))
(assert
 (sized $)
)
(assert
 (forall ((i Int)) (!
   (= i (const_int (CONST_INT i)))
   :pattern ((CONST_INT i))
   :qid prelude_type_id_const_int
   :skolemid skolem_prelude_type_id_const_int
)))
(assert
 (forall ((b Bool)) (!
   (= b (const_bool (CONST_BOOL b)))
   :pattern ((CONST_BOOL b))
   :qid prelude_type_id_const_bool
   :skolemid skolem_prelude_type_id_const_bool
)))
(assert
 (forall ((b Bool)) (!
   (has_type (B b) BOOL)
   :pattern ((has_type (B b) BOOL))
   :qid prelude_has_type_bool
   :skolemid skolem_prelude_has_type_bool
)))
(assert
 (forall ((r Real)) (!
   (has_type (R r) REAL)
   :pattern ((has_type (R r) REAL))
   :qid prelude_has_type_real
   :skolemid skolem_prelude_has_type_real
)))
(assert
 (forall ((x Poly) (t Type)) (!
   (and
    (has_type (as_type x t) t)
    (=>
     (has_type x t)
     (= x (as_type x t))
   ))
   :pattern ((as_type x t))
   :qid prelude_as_type
   :skolemid skolem_prelude_as_type
)))
(assert
 (forall ((x %%Function%%)) (!
   (= (mk_fun x) x)
   :pattern ((mk_fun x))
   :qid prelude_mk_fun
   :skolemid skolem_prelude_mk_fun
)))
(assert
 (forall ((x Bool)) (!
   (= x (%B (B x)))
   :pattern ((B x))
   :qid prelude_unbox_box_bool
   :skolemid skolem_prelude_unbox_box_bool
)))
(assert
 (forall ((x Int)) (!
   (= x (%I (I x)))
   :pattern ((I x))
   :qid prelude_unbox_box_int
   :skolemid skolem_prelude_unbox_box_int
)))
(assert
 (forall ((x Real)) (!
   (= x (%R (R x)))
   :pattern ((R x))
   :qid prelude_unbox_box_real
   :skolemid skolem_prelude_unbox_box_real
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x BOOL)
    (= x (B (%B x)))
   )
   :pattern ((has_type x BOOL))
   :qid prelude_box_unbox_bool
   :skolemid skolem_prelude_box_unbox_bool
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x INT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x INT))
   :qid prelude_box_unbox_int
   :skolemid skolem_prelude_box_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (= x (I (%I x)))
   )
   :pattern ((has_type x NAT))
   :qid prelude_box_unbox_nat
   :skolemid skolem_prelude_box_unbox_nat
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_box_unbox_usize
   :skolemid skolem_prelude_box_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (= x (I (%I x)))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_box_unbox_isize
   :skolemid skolem_prelude_box_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_box_unbox_uint
   :skolemid skolem_prelude_box_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (= x (I (%I x)))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_box_unbox_sint
   :skolemid skolem_prelude_box_unbox_sint
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x CHAR)
    (= x (I (%I x)))
   )
   :pattern ((has_type x CHAR))
   :qid prelude_box_unbox_char
   :skolemid skolem_prelude_box_unbox_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x REAL)
    (= x (R (%R x)))
   )
   :pattern ((has_type x REAL))
   :qid prelude_box_unbox_real
   :skolemid skolem_prelude_box_unbox_real
)))
(declare-fun ext_eq (Bool Type Poly Poly) Bool)
(assert
 (forall ((deep Bool) (t Type) (x Poly) (y Poly)) (!
   (= (= x y) (ext_eq deep t x y))
   :pattern ((ext_eq deep t x y))
   :qid prelude_ext_eq
   :skolemid skolem_prelude_ext_eq
)))
(declare-const SZ Int)
(assert
 (or
  (= SZ 32)
  (= SZ 64)
))
(declare-fun uHi (Int) Int)
(declare-fun iLo (Int) Int)
(declare-fun iHi (Int) Int)
(assert
 (= (uHi 8) 256)
)
(assert
 (= (uHi 16) 65536)
)
(assert
 (= (uHi 32) 4294967296)
)
(assert
 (= (uHi 64) 18446744073709551616)
)
(assert
 (= (uHi 128) (+ 1 340282366920938463463374607431768211455))
)
(assert
 (= (iLo 8) (- 128))
)
(assert
 (= (iLo 16) (- 32768))
)
(assert
 (= (iLo 32) (- 2147483648))
)
(assert
 (= (iLo 64) (- 9223372036854775808))
)
(assert
 (= (iLo 128) (- 170141183460469231731687303715884105728))
)
(assert
 (= (iHi 8) 128)
)
(assert
 (= (iHi 16) 32768)
)
(assert
 (= (iHi 32) 2147483648)
)
(assert
 (= (iHi 64) 9223372036854775808)
)
(assert
 (= (iHi 128) 170141183460469231731687303715884105728)
)
(declare-fun nClip (Int) Int)
(declare-fun uClip (Int Int) Int)
(declare-fun iClip (Int Int) Int)
(declare-fun charClip (Int) Int)
(assert
 (forall ((i Int)) (!
   (and
    (<= 0 (nClip i))
    (=>
     (<= 0 i)
     (= i (nClip i))
   ))
   :pattern ((nClip i))
   :qid prelude_nat_clip
   :skolemid skolem_prelude_nat_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= 0 (uClip bits i))
    (< (uClip bits i) (uHi bits))
    (=>
     (and
      (<= 0 i)
      (< i (uHi bits))
     )
     (= i (uClip bits i))
   ))
   :pattern ((uClip bits i))
   :qid prelude_u_clip
   :skolemid skolem_prelude_u_clip
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (and
    (<= (iLo bits) (iClip bits i))
    (< (iClip bits i) (iHi bits))
    (=>
     (and
      (<= (iLo bits) i)
      (< i (iHi bits))
     )
     (= i (iClip bits i))
   ))
   :pattern ((iClip bits i))
   :qid prelude_i_clip
   :skolemid skolem_prelude_i_clip
)))
(assert
 (forall ((i Int)) (!
   (and
    (or
     (and
      (<= 0 (charClip i))
      (<= (charClip i) 55295)
     )
     (and
      (<= 57344 (charClip i))
      (<= (charClip i) 1114111)
    ))
    (=>
     (or
      (and
       (<= 0 i)
       (<= i 55295)
      )
      (and
       (<= 57344 i)
       (<= i 1114111)
     ))
     (= i (charClip i))
   ))
   :pattern ((charClip i))
   :qid prelude_char_clip
   :skolemid skolem_prelude_char_clip
)))
(declare-fun uInv (Int Int) Bool)
(declare-fun iInv (Int Int) Bool)
(declare-fun charInv (Int) Bool)
(assert
 (forall ((bits Int) (i Int)) (!
   (= (uInv bits i) (and
     (<= 0 i)
     (< i (uHi bits))
   ))
   :pattern ((uInv bits i))
   :qid prelude_u_inv
   :skolemid skolem_prelude_u_inv
)))
(assert
 (forall ((bits Int) (i Int)) (!
   (= (iInv bits i) (and
     (<= (iLo bits) i)
     (< i (iHi bits))
   ))
   :pattern ((iInv bits i))
   :qid prelude_i_inv
   :skolemid skolem_prelude_i_inv
)))
(assert
 (forall ((i Int)) (!
   (= (charInv i) (or
     (and
      (<= 0 i)
      (<= i 55295)
     )
     (and
      (<= 57344 i)
      (<= i 1114111)
   )))
   :pattern ((charInv i))
   :qid prelude_char_inv
   :skolemid skolem_prelude_char_inv
)))
(assert
 (forall ((x Int)) (!
   (has_type (I x) INT)
   :pattern ((has_type (I x) INT))
   :qid prelude_has_type_int
   :skolemid skolem_prelude_has_type_int
)))
(assert
 (forall ((x Int)) (!
   (=>
    (<= 0 x)
    (has_type (I x) NAT)
   )
   :pattern ((has_type (I x) NAT))
   :qid prelude_has_type_nat
   :skolemid skolem_prelude_has_type_nat
)))
(assert
 (forall ((x Int)) (!
   (=>
    (uInv SZ x)
    (has_type (I x) USIZE)
   )
   :pattern ((has_type (I x) USIZE))
   :qid prelude_has_type_usize
   :skolemid skolem_prelude_has_type_usize
)))
(assert
 (forall ((x Int)) (!
   (=>
    (iInv SZ x)
    (has_type (I x) ISIZE)
   )
   :pattern ((has_type (I x) ISIZE))
   :qid prelude_has_type_isize
   :skolemid skolem_prelude_has_type_isize
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (UINT bits))
   )
   :pattern ((has_type (I x) (UINT bits)))
   :qid prelude_has_type_uint
   :skolemid skolem_prelude_has_type_uint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (iInv bits x)
    (has_type (I x) (SINT bits))
   )
   :pattern ((has_type (I x) (SINT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((bits Int) (x Int)) (!
   (=>
    (uInv bits x)
    (has_type (I x) (FLOAT bits))
   )
   :pattern ((has_type (I x) (FLOAT bits)))
   :qid prelude_has_type_sint
   :skolemid skolem_prelude_has_type_sint
)))
(assert
 (forall ((x Int)) (!
   (=>
    (charInv x)
    (has_type (I x) CHAR)
   )
   :pattern ((has_type (I x) CHAR))
   :qid prelude_has_type_char
   :skolemid skolem_prelude_has_type_char
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x NAT)
    (<= 0 (%I x))
   )
   :pattern ((has_type x NAT))
   :qid prelude_unbox_int
   :skolemid skolem_prelude_unbox_int
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x USIZE)
    (uInv SZ (%I x))
   )
   :pattern ((has_type x USIZE))
   :qid prelude_unbox_usize
   :skolemid skolem_prelude_unbox_usize
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ISIZE)
    (iInv SZ (%I x))
   )
   :pattern ((has_type x ISIZE))
   :qid prelude_unbox_isize
   :skolemid skolem_prelude_unbox_isize
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (UINT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (UINT bits)))
   :qid prelude_unbox_uint
   :skolemid skolem_prelude_unbox_uint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (SINT bits))
    (iInv bits (%I x))
   )
   :pattern ((has_type x (SINT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(assert
 (forall ((bits Int) (x Poly)) (!
   (=>
    (has_type x (FLOAT bits))
    (uInv bits (%I x))
   )
   :pattern ((has_type x (FLOAT bits)))
   :qid prelude_unbox_sint
   :skolemid skolem_prelude_unbox_sint
)))
(declare-fun Add (Int Int) Int)
(declare-fun Sub (Int Int) Int)
(declare-fun Mul (Int Int) Int)
(declare-fun EucDiv (Int Int) Int)
(declare-fun EucMod (Int Int) Int)
(declare-fun RAdd (Real Real) Real)
(declare-fun RSub (Real Real) Real)
(declare-fun RMul (Real Real) Real)
(declare-fun RDiv (Real Real) Real)
(assert
 (forall ((x Int) (y Int)) (!
   (= (Add x y) (+ x y))
   :pattern ((Add x y))
   :qid prelude_add
   :skolemid skolem_prelude_add
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Sub x y) (- x y))
   :pattern ((Sub x y))
   :qid prelude_sub
   :skolemid skolem_prelude_sub
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (Mul x y) (* x y))
   :pattern ((Mul x y))
   :qid prelude_mul
   :skolemid skolem_prelude_mul
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucDiv x y) (div x y))
   :pattern ((EucDiv x y))
   :qid prelude_eucdiv
   :skolemid skolem_prelude_eucdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (= (EucMod x y) (mod x y))
   :pattern ((EucMod x y))
   :qid prelude_eucmod
   :skolemid skolem_prelude_eucmod
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RAdd x y) (+ x y))
   :pattern ((RAdd x y))
   :qid prelude_radd
   :skolemid skolem_prelude_radd
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RSub x y) (- x y))
   :pattern ((RSub x y))
   :qid prelude_rsub
   :skolemid skolem_prelude_rsub
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RMul x y) (* x y))
   :pattern ((RMul x y))
   :qid prelude_rmul
   :skolemid skolem_prelude_rmul
)))
(assert
 (forall ((x Real) (y Real)) (!
   (= (RDiv x y) (/ x y))
   :pattern ((RDiv x y))
   :qid prelude_rdiv
   :skolemid skolem_prelude_rdiv
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (<= 0 y)
    )
    (<= 0 (Mul x y))
   )
   :pattern ((Mul x y))
   :qid prelude_mul_nats
   :skolemid skolem_prelude_mul_nats
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucDiv x y))
     (<= (EucDiv x y) x)
   ))
   :pattern ((EucDiv x y))
   :qid prelude_div_unsigned_in_bounds
   :skolemid skolem_prelude_div_unsigned_in_bounds
)))
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (and
     (<= 0 x)
     (< 0 y)
    )
    (and
     (<= 0 (EucMod x y))
     (< (EucMod x y) y)
   ))
   :pattern ((EucMod x y))
   :qid prelude_mod_unsigned_in_bounds
   :skolemid skolem_prelude_mod_unsigned_in_bounds
)))
(declare-fun bitxor (Poly Poly) Int)
(declare-fun bitand (Poly Poly) Int)
(declare-fun bitor (Poly Poly) Int)
(declare-fun bitshr (Poly Poly) Int)
(declare-fun bitshl (Poly Poly) Int)
(declare-fun bitnot (Poly) Int)
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitxor x y))
   )
   :pattern ((uClip bits (bitxor x y)))
   :qid prelude_bit_xor_u_inv
   :skolemid skolem_prelude_bit_xor_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitxor x y))
   )
   :pattern ((iClip bits (bitxor x y)))
   :qid prelude_bit_xor_i_inv
   :skolemid skolem_prelude_bit_xor_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitor x y))
   )
   :pattern ((uClip bits (bitor x y)))
   :qid prelude_bit_or_u_inv
   :skolemid skolem_prelude_bit_or_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitor x y))
   )
   :pattern ((iClip bits (bitor x y)))
   :qid prelude_bit_or_i_inv
   :skolemid skolem_prelude_bit_or_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (uInv bits (%I y))
    )
    (uInv bits (bitand x y))
   )
   :pattern ((uClip bits (bitand x y)))
   :qid prelude_bit_and_u_inv
   :skolemid skolem_prelude_bit_and_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (iInv bits (%I y))
    )
    (iInv bits (bitand x y))
   )
   :pattern ((iClip bits (bitand x y)))
   :qid prelude_bit_and_i_inv
   :skolemid skolem_prelude_bit_and_i_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (uInv bits (%I x))
     (<= 0 (%I y))
    )
    (uInv bits (bitshr x y))
   )
   :pattern ((uClip bits (bitshr x y)))
   :qid prelude_bit_shr_u_inv
   :skolemid skolem_prelude_bit_shr_u_inv
)))
(assert
 (forall ((x Poly) (y Poly) (bits Int)) (!
   (=>
    (and
     (iInv bits (%I x))
     (<= 0 (%I y))
    )
    (iInv bits (bitshr x y))
   )
   :pattern ((iClip bits (bitshr x y)))
   :qid prelude_bit_shr_i_inv
   :skolemid skolem_prelude_bit_shr_i_inv
)))
(declare-fun singular_mod (Int Int) Int)
(assert
 (forall ((x Int) (y Int)) (!
   (=>
    (not (= y 0))
    (= (EucMod x y) (singular_mod x y))
   )
   :pattern ((singular_mod x y))
   :qid prelude_singularmod
   :skolemid skolem_prelude_singularmod
)))
(declare-fun has_resolved (Dcr Type Poly) Bool)
(declare-fun closure_req (Type Dcr Type Poly Poly) Bool)
(declare-fun closure_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun default_ens (Type Dcr Type Poly Poly Poly) Bool)
(declare-fun height (Poly) Height)
(declare-fun height_lt (Height Height) Bool)
(declare-fun fun_from_recursive_field (Poly) Poly)
(declare-fun check_decrease_int (Int Int Bool) Bool)
(assert
 (forall ((cur Int) (prev Int) (otherwise Bool)) (!
   (= (check_decrease_int cur prev otherwise) (or
     (and
      (<= 0 cur)
      (< cur prev)
     )
     (and
      (= cur prev)
      otherwise
   )))
   :pattern ((check_decrease_int cur prev otherwise))
   :qid prelude_check_decrease_int
   :skolemid skolem_prelude_check_decrease_int
)))
(declare-fun check_decrease_height (Poly Poly Bool) Bool)
(assert
 (forall ((cur Poly) (prev Poly) (otherwise Bool)) (!
   (= (check_decrease_height cur prev otherwise) (or
     (height_lt (height cur) (height prev))
     (and
      (= (height cur) (height prev))
      otherwise
   )))
   :pattern ((check_decrease_height cur prev otherwise))
   :qid prelude_check_decrease_height
   :skolemid skolem_prelude_check_decrease_height
)))
(assert
 (forall ((x Height) (y Height)) (!
   (= (height_lt x y) (and
     ((_ partial-order 0) x y)
     (not (= x y))
   ))
   :pattern ((height_lt x y))
   :qid prelude_height_lt
   :skolemid skolem_prelude_height_lt
)))

;; MODULE 'module lemmas::scalar_byte_lemmas::bytes_to_scalar_lemmas'
;; curve25519-dalek/src/lemmas/scalar_byte_lemmas/bytes_to_scalar_lemmas.rs:224:1: 224:80 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor.
 FuelId
)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_associative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_inequality. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_strict_inequality. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. FuelId)
(declare-const fuel%vstd!arithmetic.power.pow. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_increases. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_adds. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases. FuelId)
(declare-const fuel%vstd!array.array_view. FuelId)
(declare-const fuel%vstd!array.impl&%0.view. FuelId)
(declare-const fuel%vstd!array.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!array.lemma_array_index. FuelId)
(declare-const fuel%vstd!array.array_len_matches_n. FuelId)
(declare-const fuel%vstd!array.axiom_spec_array_as_slice. FuelId)
(declare-const fuel%vstd!array.axiom_array_ext_equal. FuelId)
(declare-const fuel%vstd!array.axiom_array_has_resolved. FuelId)
(declare-const fuel%vstd!bits.lemma_u64_shr_is_div. FuelId)
(declare-const fuel%vstd!bits.lemma_u64_pow2_no_overflow. FuelId)
(declare-const fuel%vstd!bits.lemma_u64_shl_is_mul. FuelId)
(declare-const fuel%vstd!bits.low_bits_mask. FuelId)
(declare-const fuel%vstd!bits.lemma_u64_low_bits_mask_is_mod. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_empty. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_index_same. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_index_different. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_index. FuelId)
(declare-const fuel%vstd!seq.lemma_seq_two_subranges_index. FuelId)
(declare-const fuel%vstd!seq_lib.impl&%0.map. FuelId)
(declare-const fuel%vstd!slice.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!slice.axiom_spec_len. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_ext_equal. FuelId)
(declare-const fuel%vstd!slice.axiom_slice_has_resolved. FuelId)
(declare-const fuel%vstd!view.impl&%0.view. FuelId)
(declare-const fuel%vstd!view.impl&%2.view. FuelId)
(declare-const fuel%vstd!view.impl&%4.view. FuelId)
(declare-const fuel%vstd!view.impl&%6.view. FuelId)
(declare-const fuel%vstd!view.impl&%12.view. FuelId)
(declare-const fuel%vstd!view.impl&%14.view. FuelId)
(declare-const fuel%vstd!view.impl&%16.view. FuelId)
(declare-const fuel%vstd!view.impl&%20.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.words_as_nat_u64. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limbs52_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded. FuelId)
(declare-const fuel%vstd!array.group_array_axioms. FuelId)
(declare-const fuel%vstd!function.group_function_axioms. FuelId)
(declare-const fuel%vstd!laws_cmp.group_laws_cmp. FuelId)
(declare-const fuel%vstd!laws_eq.bool_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i8_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i16_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i32_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i64_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.u128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.i128_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.usize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.isize_laws.group_laws_eq. FuelId)
(declare-const fuel%vstd!laws_eq.group_laws_eq. FuelId)
(declare-const fuel%vstd!layout.group_layout_axioms. FuelId)
(declare-const fuel%vstd!map.group_map_axioms. FuelId)
(declare-const fuel%vstd!multiset.group_multiset_axioms. FuelId)
(declare-const fuel%vstd!raw_ptr.group_raw_ptr_axioms. FuelId)
(declare-const fuel%vstd!seq.group_seq_axioms. FuelId)
(declare-const fuel%vstd!seq_lib.group_filter_ensures. FuelId)
(declare-const fuel%vstd!seq_lib.group_seq_lib_default. FuelId)
(declare-const fuel%vstd!set.group_set_axioms. FuelId)
(declare-const fuel%vstd!set_lib.group_set_lib_default. FuelId)
(declare-const fuel%vstd!slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!string.group_string_axioms. FuelId)
(declare-const fuel%vstd!std_specs.bits.group_bits_axioms. FuelId)
(declare-const fuel%vstd!std_specs.control_flow.group_control_flow_axioms. FuelId)
(declare-const fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms. FuelId)
(declare-const fuel%vstd!std_specs.hash.group_hash_axioms. FuelId)
(declare-const fuel%vstd!std_specs.range.group_range_axioms. FuelId)
(declare-const fuel%vstd!std_specs.slice.group_slice_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vec.group_vec_axioms. FuelId)
(declare-const fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. FuelId)
(declare-const fuel%vstd!group_vstd_default. FuelId)
(assert
 (distinct fuel%vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator. fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod.
  fuel%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. fuel%vstd!arithmetic.mul.lemma_mul_is_associative.
  fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. fuel%vstd!arithmetic.mul.lemma_mul_inequality.
  fuel%vstd!arithmetic.mul.lemma_mul_strict_inequality. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way.
  fuel%vstd!arithmetic.power.pow. fuel%vstd!arithmetic.power.lemma_pow_increases. fuel%vstd!arithmetic.power2.lemma_pow2_pos.
  fuel%vstd!arithmetic.power2.lemma_pow2. fuel%vstd!arithmetic.power2.lemma_pow2_adds.
  fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases. fuel%vstd!array.array_view.
  fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index. fuel%vstd!array.lemma_array_index.
  fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_spec_array_as_slice. fuel%vstd!array.axiom_array_ext_equal.
  fuel%vstd!array.axiom_array_has_resolved. fuel%vstd!bits.lemma_u64_shr_is_div. fuel%vstd!bits.lemma_u64_pow2_no_overflow.
  fuel%vstd!bits.lemma_u64_shl_is_mul. fuel%vstd!bits.low_bits_mask. fuel%vstd!bits.lemma_u64_low_bits_mask_is_mod.
  fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized.
  fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.axiom_seq_index_decreases. fuel%vstd!seq.axiom_seq_subrange_decreases.
  fuel%vstd!seq.axiom_seq_empty. fuel%vstd!seq.axiom_seq_new_len. fuel%vstd!seq.axiom_seq_new_index.
  fuel%vstd!seq.axiom_seq_push_len. fuel%vstd!seq.axiom_seq_push_index_same. fuel%vstd!seq.axiom_seq_push_index_different.
  fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!seq.axiom_seq_subrange_len.
  fuel%vstd!seq.axiom_seq_subrange_index. fuel%vstd!seq.lemma_seq_two_subranges_index.
  fuel%vstd!seq_lib.impl&%0.map. fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len.
  fuel%vstd!slice.axiom_slice_ext_equal. fuel%vstd!slice.axiom_slice_has_resolved.
  fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view. fuel%vstd!view.impl&%4.view.
  fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view. fuel%vstd!view.impl&%14.view.
  fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%20.view. fuel%vstd!view.impl&%22.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%32.view. fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat.
  fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen.
  fuel%curve25519_dalek!specs.core_specs.words_as_nat_u64. fuel%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.
  fuel%curve25519_dalek!specs.scalar52_specs.limbs52_as_nat. fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.
  fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded. fuel%vstd!array.group_array_axioms.
  fuel%vstd!function.group_function_axioms. fuel%vstd!laws_cmp.group_laws_cmp. fuel%vstd!laws_eq.bool_laws.group_laws_eq.
  fuel%vstd!laws_eq.u8_laws.group_laws_eq. fuel%vstd!laws_eq.i8_laws.group_laws_eq.
  fuel%vstd!laws_eq.u16_laws.group_laws_eq. fuel%vstd!laws_eq.i16_laws.group_laws_eq.
  fuel%vstd!laws_eq.u32_laws.group_laws_eq. fuel%vstd!laws_eq.i32_laws.group_laws_eq.
  fuel%vstd!laws_eq.u64_laws.group_laws_eq. fuel%vstd!laws_eq.i64_laws.group_laws_eq.
  fuel%vstd!laws_eq.u128_laws.group_laws_eq. fuel%vstd!laws_eq.i128_laws.group_laws_eq.
  fuel%vstd!laws_eq.usize_laws.group_laws_eq. fuel%vstd!laws_eq.isize_laws.group_laws_eq.
  fuel%vstd!laws_eq.group_laws_eq. fuel%vstd!layout.group_layout_axioms. fuel%vstd!map.group_map_axioms.
  fuel%vstd!multiset.group_multiset_axioms. fuel%vstd!raw_ptr.group_raw_ptr_axioms.
  fuel%vstd!seq.group_seq_axioms. fuel%vstd!seq_lib.group_filter_ensures. fuel%vstd!seq_lib.group_seq_lib_default.
  fuel%vstd!set.group_set_axioms. fuel%vstd!set_lib.group_set_lib_default. fuel%vstd!slice.group_slice_axioms.
  fuel%vstd!string.group_string_axioms. fuel%vstd!std_specs.bits.group_bits_axioms.
  fuel%vstd!std_specs.control_flow.group_control_flow_axioms. fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.
  fuel%vstd!std_specs.hash.group_hash_axioms. fuel%vstd!std_specs.range.group_range_axioms.
  fuel%vstd!std_specs.slice.group_slice_axioms. fuel%vstd!std_specs.vec.group_vec_axioms.
  fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms. fuel%vstd!group_vstd_default.
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!array.group_array_axioms.)
  (and
   (fuel_bool_default fuel%vstd!array.array_len_matches_n.)
   (fuel_bool_default fuel%vstd!array.lemma_array_index.)
   (fuel_bool_default fuel%vstd!array.axiom_spec_array_as_slice.)
   (fuel_bool_default fuel%vstd!array.axiom_array_ext_equal.)
   (fuel_bool_default fuel%vstd!array.axiom_array_has_resolved.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
  (and
   (fuel_bool_default fuel%vstd!laws_eq.bool_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i8_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i16_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i32_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i64_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.u128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.i128_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.usize_laws.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_eq.isize_laws.group_laws_eq.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
  (and
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq.)
   (fuel_bool_default fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
  (and
   (fuel_bool_default fuel%vstd!seq.axiom_seq_index_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_decreases.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_empty.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_index_same.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_index_different.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal_deep.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_subrange_index.)
   (fuel_bool_default fuel%vstd!seq.lemma_seq_two_subranges_index.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
  (fuel_bool_default fuel%vstd!seq_lib.group_filter_ensures.)
))
(assert
 (=>
  (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
  (and
   (fuel_bool_default fuel%vstd!slice.axiom_spec_len.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_ext_equal.)
   (fuel_bool_default fuel%vstd!slice.axiom_slice_has_resolved.)
)))
(assert
 (fuel_bool_default fuel%vstd!group_vstd_default.)
)
(assert
 (=>
  (fuel_bool_default fuel%vstd!group_vstd_default.)
  (and
   (fuel_bool_default fuel%vstd!seq.group_seq_axioms.)
   (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
   (fuel_bool_default fuel%vstd!map.group_map_axioms.)
   (fuel_bool_default fuel%vstd!set.group_set_axioms.)
   (fuel_bool_default fuel%vstd!set_lib.group_set_lib_default.)
   (fuel_bool_default fuel%vstd!multiset.group_multiset_axioms.)
   (fuel_bool_default fuel%vstd!function.group_function_axioms.)
   (fuel_bool_default fuel%vstd!laws_eq.group_laws_eq.)
   (fuel_bool_default fuel%vstd!laws_cmp.group_laws_cmp.)
   (fuel_bool_default fuel%vstd!slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!array.group_array_axioms.)
   (fuel_bool_default fuel%vstd!string.group_string_axioms.)
   (fuel_bool_default fuel%vstd!raw_ptr.group_raw_ptr_axioms.)
   (fuel_bool_default fuel%vstd!layout.group_layout_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.range.group_range_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.bits.group_bits_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.control_flow.group_control_flow_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.slice.group_slice_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.manually_drop.group_manually_drop_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vec.group_vec_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.vecdeque.group_vec_dequeue_axioms.)
   (fuel_bool_default fuel%vstd!std_specs.hash.group_hash_axioms.)
)))

;; Trait-Decls
(declare-fun tr_bound%vstd!array.ArrayAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!slice.SliceAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!view.View. (Dcr Type) Bool)

;; Associated-Type-Decls
(declare-fun proj%%vstd!view.View./V (Dcr Type) Dcr)
(declare-fun proj%vstd!view.View./V (Dcr Type) Type)

;; Datatypes
(declare-fun pointee_metadata% (Dcr) Type)
(declare-fun pointee_metadata%% (Dcr) Dcr)
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata% d) TYPE%tuple%0.)
   )
   :pattern ((pointee_metadata% d))
   :qid prelude_project_pointee_metadata_sized
   :skolemid skolem_prelude_project_pointee_metadata_sized
)))
(assert
 (forall ((d Dcr)) (!
   (=>
    (sized d)
    (= (pointee_metadata%% d) $)
   )
   :pattern ((pointee_metadata%% d))
   :qid prelude_project_pointee_metadata_decoration_sized
   :skolemid skolem_prelude_project_pointee_metadata_decoration_sized
)))
(assert
 (= (pointee_metadata% $slice) USIZE)
)
(assert
 (= (pointee_metadata%% $slice) $)
)
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata% (DST d)) (pointee_metadata% d))
   :pattern ((pointee_metadata% (DST d)))
   :qid prelude_project_pointee_metadata_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decorate_struct_inherit
)))
(assert
 (forall ((d Dcr)) (!
   (= (pointee_metadata%% (DST d)) (pointee_metadata%% d))
   :pattern ((pointee_metadata%% (DST d)))
   :qid prelude_project_pointee_metadata_decoration_decorate_struct_inherit
   :skolemid skolem_prelude_project_pointee_metadata_decoration_decorate_struct_inherit
)))
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort vstd!seq.Seq<nat.>. 0)
(declare-sort vstd!seq.Seq<u8.>. 0)
(declare-sort vstd!seq.Seq<u64.>. 0)
(declare-sort slice%<u64.>. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((vstd!raw_ptr.PtrData. 0) (curve25519_dalek!backend.serial.u64.scalar.Scalar52.
   0
  ) (tuple%0. 0)
 ) (((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52 (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/?limbs
     %%Function%%
   ))
  ) ((tuple%0./tuple%0))
))
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (
  curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) %%Function%%
)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%fun%2. (Dcr Type Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52. Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%fun%2. (%%Function%%) Poly)
(declare-fun %Poly%fun%2. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<nat.>. (vstd!seq.Seq<nat.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<nat.>. (Poly) vstd!seq.Seq<nat.>.)
(declare-fun Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq<u8.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u8.>. (Poly) vstd!seq.Seq<u8.>.)
(declare-fun Poly%vstd!seq.Seq<u64.>. (vstd!seq.Seq<u64.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u64.>. (Poly) vstd!seq.Seq<u64.>.)
(declare-fun Poly%slice%<u64.>. (slice%<u64.>.) Poly)
(declare-fun %Poly%slice%<u64.>. (Poly) slice%<u64.>.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly) curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%fun%1. (Poly%fun%1. x)))
   :pattern ((Poly%fun%1. x))
   :qid internal_crate__fun__1_box_axiom_definition
   :skolemid skolem_internal_crate__fun__1_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%fun%1. (%Poly%fun%1. x)))
   )
   :pattern ((has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_unbox_axiom_definition
   :skolemid skolem_internal_crate__fun__1_unbox_axiom_definition
)))
(declare-fun %%apply%%0 (%%Function%% Poly) Poly)
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x %%Function%%)) (!
   (=>
    (forall ((T%0 Poly)) (!
      (=>
       (has_type T%0 T%0&)
       (has_type (%%apply%%0 x T%0) T%1&)
      )
      :pattern ((has_type (%%apply%%0 x T%0) T%1&))
      :qid internal_crate__fun__1_constructor_inner_definition
      :skolemid skolem_internal_crate__fun__1_constructor_inner_definition
    ))
    (has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
   )
   :pattern ((has_type (Poly%fun%1. (mk_fun x)) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__fun__1_constructor_definition
   :skolemid skolem_internal_crate__fun__1_constructor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (has_type (%%apply%%0 x T%0) T%1&)
   )
   :pattern ((%%apply%%0 x T%0) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&.
      T%1&
   )))
   :qid internal_crate__fun__1_apply_definition
   :skolemid skolem_internal_crate__fun__1_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%0 Poly) (x %%Function%%))
  (!
   (=>
    (and
     (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type T%0 T%0&)
    )
    (height_lt (height (%%apply%%0 x T%0)) (height (fun_from_recursive_field (Poly%fun%1.
        (mk_fun x)
   )))))
   :pattern ((height (%%apply%%0 x T%0)) (has_type (Poly%fun%1. x) (TYPE%fun%1. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_crate__fun__1_height_apply_definition
   :skolemid skolem_internal_crate__fun__1_height_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%fun%1. T%0&. T%0& T%1&. T%1&))
     (forall ((T%0 Poly)) (!
       (=>
        (has_type T%0 T%0&)
        (ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1. y) T%0))
       )
       :pattern ((ext_eq deep T%1& (%%apply%%0 (%Poly%fun%1. x) T%0) (%%apply%%0 (%Poly%fun%1.
           y
          ) T%0
       )))
       :qid internal_crate__fun__1_inner_ext_equal_definition
       :skolemid skolem_internal_crate__fun__1_inner_ext_equal_definition
    )))
    (ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%fun%1. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_crate__fun__1_ext_equal_definition
   :skolemid skolem_internal_crate__fun__1_ext_equal_definition
)))
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%fun%2. (Poly%fun%2. x)))
   :pattern ((Poly%fun%2. x))
   :qid internal_crate__fun__2_box_axiom_definition
   :skolemid skolem_internal_crate__fun__2_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (= x (Poly%fun%2. (%Poly%fun%2. x)))
   )
   :pattern ((has_type x (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&)))
   :qid internal_crate__fun__2_unbox_axiom_definition
   :skolemid skolem_internal_crate__fun__2_unbox_axiom_definition
)))
(declare-fun %%apply%%1 (%%Function%% Poly Poly) Poly)
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    %%Function%%
   )
  ) (!
   (=>
    (forall ((T%0 Poly) (T%1 Poly)) (!
      (=>
       (and
        (has_type T%0 T%0&)
        (has_type T%1 T%1&)
       )
       (has_type (%%apply%%1 x T%0 T%1) T%2&)
      )
      :pattern ((has_type (%%apply%%1 x T%0 T%1) T%2&))
      :qid internal_crate__fun__2_constructor_inner_definition
      :skolemid skolem_internal_crate__fun__2_constructor_inner_definition
    ))
    (has_type (Poly%fun%2. (mk_fun x)) (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
   )
   :pattern ((has_type (Poly%fun%2. (mk_fun x)) (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&.
      T%2&
   )))
   :qid internal_crate__fun__2_constructor_definition
   :skolemid skolem_internal_crate__fun__2_constructor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%0
    Poly
   ) (T%1 Poly) (x %%Function%%)
  ) (!
   (=>
    (and
     (has_type (Poly%fun%2. x) (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (has_type T%0 T%0&)
     (has_type T%1 T%1&)
    )
    (has_type (%%apply%%1 x T%0 T%1) T%2&)
   )
   :pattern ((%%apply%%1 x T%0 T%1) (has_type (Poly%fun%2. x) (TYPE%fun%2. T%0&. T%0& T%1&.
      T%1& T%2&. T%2&
   )))
   :qid internal_crate__fun__2_apply_definition
   :skolemid skolem_internal_crate__fun__2_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%0
    Poly
   ) (T%1 Poly) (x %%Function%%)
  ) (!
   (=>
    (and
     (has_type (Poly%fun%2. x) (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (has_type T%0 T%0&)
     (has_type T%1 T%1&)
    )
    (height_lt (height (%%apply%%1 x T%0 T%1)) (height (fun_from_recursive_field (Poly%fun%2.
        (mk_fun x)
   )))))
   :pattern ((height (%%apply%%1 x T%0 T%1)) (has_type (Poly%fun%2. x) (TYPE%fun%2. T%0&.
      T%0& T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_crate__fun__2_height_apply_definition
   :skolemid skolem_internal_crate__fun__2_height_apply_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (deep
    Bool
   ) (x Poly) (y Poly)
  ) (!
   (=>
    (and
     (has_type x (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (has_type y (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (forall ((T%0 Poly) (T%1 Poly)) (!
       (=>
        (and
         (has_type T%0 T%0&)
         (has_type T%1 T%1&)
        )
        (ext_eq deep T%2& (%%apply%%1 (%Poly%fun%2. x) T%0 T%1) (%%apply%%1 (%Poly%fun%2. y)
          T%0 T%1
       )))
       :pattern ((ext_eq deep T%2& (%%apply%%1 (%Poly%fun%2. x) T%0 T%1) (%%apply%%1 (%Poly%fun%2.
           y
          ) T%0 T%1
       )))
       :qid internal_crate__fun__2_inner_ext_equal_definition
       :skolemid skolem_internal_crate__fun__2_inner_ext_equal_definition
    )))
    (ext_eq deep (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y)
   )
   :pattern ((ext_eq deep (TYPE%fun%2. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y))
   :qid internal_crate__fun__2_ext_equal_definition
   :skolemid skolem_internal_crate__fun__2_ext_equal_definition
)))
(assert
 (forall ((x %%Function%%)) (!
   (= x (%Poly%array%. (Poly%array%. x)))
   :pattern ((Poly%array%. x))
   :qid internal_crate__array___box_axiom_definition
   :skolemid skolem_internal_crate__array___box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (x Poly)) (!
   (=>
    (has_type x (ARRAY T&. T& N&. N&))
    (= x (Poly%array%. (%Poly%array%. x)))
   )
   :pattern ((has_type x (ARRAY T&. T& N&. N&)))
   :qid internal_crate__array___unbox_axiom_definition
   :skolemid skolem_internal_crate__array___unbox_axiom_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (= x (%Poly%vstd!raw_ptr.Provenance. (Poly%vstd!raw_ptr.Provenance. x)))
   :pattern ((Poly%vstd!raw_ptr.Provenance. x))
   :qid internal_vstd__raw_ptr__Provenance_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%vstd!raw_ptr.Provenance.)
    (= x (Poly%vstd!raw_ptr.Provenance. (%Poly%vstd!raw_ptr.Provenance. x)))
   )
   :pattern ((has_type x TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!raw_ptr.Provenance.)) (!
   (has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.)
   :pattern ((has_type (Poly%vstd!raw_ptr.Provenance. x) TYPE%vstd!raw_ptr.Provenance.))
   :qid internal_vstd__raw_ptr__Provenance_has_type_always_definition
   :skolemid skolem_internal_vstd__raw_ptr__Provenance_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<nat.>.)) (!
   (= x (%Poly%vstd!seq.Seq<nat.>. (Poly%vstd!seq.Seq<nat.>. x)))
   :pattern ((Poly%vstd!seq.Seq<nat.>. x))
   :qid internal_vstd__seq__Seq<nat.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<nat.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ NAT))
    (= x (Poly%vstd!seq.Seq<nat.>. (%Poly%vstd!seq.Seq<nat.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ NAT)))
   :qid internal_vstd__seq__Seq<nat.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<nat.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<nat.>.)) (!
   (has_type (Poly%vstd!seq.Seq<nat.>. x) (TYPE%vstd!seq.Seq. $ NAT))
   :pattern ((has_type (Poly%vstd!seq.Seq<nat.>. x) (TYPE%vstd!seq.Seq. $ NAT)))
   :qid internal_vstd__seq__Seq<nat.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<nat.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<u8.>.)) (!
   (= x (%Poly%vstd!seq.Seq<u8.>. (Poly%vstd!seq.Seq<u8.>. x)))
   :pattern ((Poly%vstd!seq.Seq<u8.>. x))
   :qid internal_vstd__seq__Seq<u8.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (= x (Poly%vstd!seq.Seq<u8.>. (%Poly%vstd!seq.Seq<u8.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (UINT 8))))
   :qid internal_vstd__seq__Seq<u8.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<u8.>.)) (!
   (has_type (Poly%vstd!seq.Seq<u8.>. x) (TYPE%vstd!seq.Seq. $ (UINT 8)))
   :pattern ((has_type (Poly%vstd!seq.Seq<u8.>. x) (TYPE%vstd!seq.Seq. $ (UINT 8))))
   :qid internal_vstd__seq__Seq<u8.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<u8.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<u64.>.)) (!
   (= x (%Poly%vstd!seq.Seq<u64.>. (Poly%vstd!seq.Seq<u64.>. x)))
   :pattern ((Poly%vstd!seq.Seq<u64.>. x))
   :qid internal_vstd__seq__Seq<u64.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u64.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (UINT 64)))
    (= x (Poly%vstd!seq.Seq<u64.>. (%Poly%vstd!seq.Seq<u64.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (UINT 64))))
   :qid internal_vstd__seq__Seq<u64.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u64.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<u64.>.)) (!
   (has_type (Poly%vstd!seq.Seq<u64.>. x) (TYPE%vstd!seq.Seq. $ (UINT 64)))
   :pattern ((has_type (Poly%vstd!seq.Seq<u64.>. x) (TYPE%vstd!seq.Seq. $ (UINT 64))))
   :qid internal_vstd__seq__Seq<u64.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<u64.>_has_type_always_definition
)))
(assert
 (forall ((x slice%<u64.>.)) (!
   (= x (%Poly%slice%<u64.>. (Poly%slice%<u64.>. x)))
   :pattern ((Poly%slice%<u64.>. x))
   :qid internal_crate__slice__<u64.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<u64.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ (UINT 64)))
    (= x (Poly%slice%<u64.>. (%Poly%slice%<u64.>. x)))
   )
   :pattern ((has_type x (SLICE $ (UINT 64))))
   :qid internal_crate__slice__<u64.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<u64.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<u64.>.)) (!
   (has_type (Poly%slice%<u64.>. x) (SLICE $ (UINT 64)))
   :pattern ((has_type (Poly%slice%<u64.>. x) (SLICE $ (UINT 64))))
   :qid internal_crate__slice__<u64.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<u64.>_has_type_always_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (= x (%Poly%allocator_global%. (Poly%allocator_global%. x)))
   :pattern ((Poly%allocator_global%. x))
   :qid internal_crate__allocator_global___box_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x ALLOCATOR_GLOBAL)
    (= x (Poly%allocator_global%. (%Poly%allocator_global%. x)))
   )
   :pattern ((has_type x ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___unbox_axiom_definition
   :skolemid skolem_internal_crate__allocator_global___unbox_axiom_definition
)))
(assert
 (forall ((x allocator_global%.)) (!
   (has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL)
   :pattern ((has_type (Poly%allocator_global%. x) ALLOCATOR_GLOBAL))
   :qid internal_crate__allocator_global___has_type_always_definition
   :skolemid skolem_internal_crate__allocator_global___has_type_always_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= x (%Poly%vstd!raw_ptr.PtrData. (Poly%vstd!raw_ptr.PtrData. x)))
   :pattern ((Poly%vstd!raw_ptr.PtrData. x))
   :qid internal_vstd__raw_ptr__PtrData_box_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (= x (Poly%vstd!raw_ptr.PtrData. (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&)))
   :qid internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
   :skolemid skolem_internal_vstd__raw_ptr__PtrData_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_addr! Int) (_provenance! vstd!raw_ptr.Provenance.) (
    _metadata! Poly
   )
  ) (!
   (=>
    (and
     (uInv SZ _addr!)
     (has_type _metadata! (pointee_metadata% T&.))
    )
    (has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr! _provenance!
       _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :pattern ((has_type (Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData./PtrData _addr!
       _provenance! _metadata!
      )
     ) (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData_constructor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/addr x) (vstd!raw_ptr.PtrData./PtrData/?addr x))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (uInv SZ (vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)))
   )
   :pattern ((vstd!raw_ptr.PtrData./PtrData/addr (%Poly%vstd!raw_ptr.PtrData. x)) (has_type
     x (TYPE%vstd!raw_ptr.PtrData. T&. T&)
   ))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/addr_invariant_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/provenance x) (vstd!raw_ptr.PtrData./PtrData/?provenance
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/provenance x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/provenance_accessor_definition
)))
(assert
 (forall ((x vstd!raw_ptr.PtrData.)) (!
   (= (vstd!raw_ptr.PtrData./PtrData/metadata x) (vstd!raw_ptr.PtrData./PtrData/?metadata
     x
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata x))
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
     (pointee_metadata% T&.)
   ))
   :pattern ((vstd!raw_ptr.PtrData./PtrData/metadata (%Poly%vstd!raw_ptr.PtrData. x))
    (has_type x (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   )
   :qid internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
   :skolemid skolem_internal_vstd!raw_ptr.PtrData./PtrData/metadata_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. x))
   :qid internal_curve25519_dalek__backend__serial__u64__scalar__Scalar52_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__scalar__Scalar52_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
    (= x (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
   :qid internal_curve25519_dalek__backend__serial__u64__scalar__Scalar52_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__scalar__Scalar52_unbox_axiom_definition
)))
(assert
 (forall ((_limbs! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52
       _limbs!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52
       _limbs!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
   ))
   :qid internal_curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs x) (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/?limbs
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs x))
   :qid internal_curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
    (has_type (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
       (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. x)
      )
     ) (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   )
   :qid internal_curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs_invariant_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (= x (%Poly%tuple%0. (Poly%tuple%0. x)))
   :pattern ((Poly%tuple%0. x))
   :qid internal_crate__tuple__0_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%tuple%0.)
    (= x (Poly%tuple%0. (%Poly%tuple%0. x)))
   )
   :pattern ((has_type x TYPE%tuple%0.))
   :qid internal_crate__tuple__0_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__0_unbox_axiom_definition
)))
(assert
 (forall ((x tuple%0.)) (!
   (has_type (Poly%tuple%0. x) TYPE%tuple%0.)
   :pattern ((has_type (Poly%tuple%0. x) TYPE%tuple%0.))
   :qid internal_crate__tuple__0_has_type_always_definition
   :skolemid skolem_internal_crate__tuple__0_has_type_always_definition
)))
(declare-fun array_new (Dcr Type Int %%Function%%) Poly)
(declare-fun array_index (Dcr Type Dcr Type %%Function%% Poly) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (= (array_new Tdcr T N Fn) (Poly%array%. Fn))
   :pattern ((array_new Tdcr T N Fn))
   :qid prelude_array_new
   :skolemid skolem_prelude_array_new
)))
(declare-fun %%apply%%2 (%%Function%% Int) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (=>
    (forall ((i Int)) (!
      (=>
       (and
        (<= 0 i)
        (< i N)
       )
       (has_type (%%apply%%2 Fn i) T)
      )
      :pattern ((has_type (%%apply%%2 Fn i) T))
      :qid prelude_has_type_array_elts
      :skolemid skolem_prelude_has_type_array_elts
    ))
    (has_type (array_new Tdcr T N Fn) (ARRAY Tdcr T $ (CONST_INT N)))
   )
   :pattern ((array_new Tdcr T N Fn))
   :qid prelude_has_type_array_new
   :skolemid skolem_prelude_has_type_array_new
)))
(assert
 (forall ((Tdcr Dcr) (T Type) (Ndcr Dcr) (N Type) (Fn %%Function%%) (i Poly)) (!
   (=>
    (and
     (has_type (Poly%array%. Fn) (ARRAY Tdcr T Ndcr N))
     (has_type i INT)
    )
    (has_type (array_index Tdcr T $ N Fn i) T)
   )
   :pattern ((array_index Tdcr T $ N Fn i) (has_type (Poly%array%. Fn) (ARRAY Tdcr T Ndcr
      N
   )))
   :qid prelude_has_type_array_index
   :skolemid skolem_prelude_has_type_array_index
)))
(assert
 (!
  (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%) (i Int)) (!
    (= (array_index Tdcr T $ (CONST_INT N) Fn (I i)) (%%apply%%2 Fn i))
    :pattern ((array_new Tdcr T N Fn) (%%apply%%2 Fn i))
    :qid prelude_array_index_trigger
    :skolemid skolem_prelude_array_index_trigger
  ))
  :named
  prelude_axiom_array_index
))

;; Trait-Bounds
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!array.ArrayAdditionalSpecFns. Self%&. Self%& T&. T&)
    (and
     (tr_bound%vstd!view.View. Self%&. Self%&)
     (and
      (= $ (proj%%vstd!view.View./V Self%&. Self%&))
      (= (TYPE%vstd!seq.Seq. T&. T&) (proj%vstd!view.View./V Self%&. Self%&))
     )
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!array.ArrayAdditionalSpecFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__array__ArrayAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__array__ArrayAdditionalSpecFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&)
    (and
     (tr_bound%vstd!view.View. Self%&. Self%&)
     (and
      (= $ (proj%%vstd!view.View./V Self%&. Self%&))
      (= (TYPE%vstd!seq.Seq. T&. T&) (proj%vstd!view.View./V Self%&. Self%&))
     )
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__slice__SliceAdditionalSpecFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!view.View. Self%&. Self%&)
    (sized (proj%%vstd!view.View./V Self%&. Self%&))
   )
   :pattern ((tr_bound%vstd!view.View. Self%&. Self%&))
   :qid internal_vstd__view__View_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__view__View_trait_type_bounds_definition
)))

;; Associated-Type-Impls
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%%vstd!view.View./V $ (ARRAY T&. T& N&. N&)) $)
   :pattern ((proj%%vstd!view.View./V $ (ARRAY T&. T& N&. N&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%vstd!view.View./V $ (ARRAY T&. T& N&. N&)) (TYPE%vstd!seq.Seq. T&. T&))
   :pattern ((proj%vstd!view.View./V $ (ARRAY T&. T& N&. N&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $ (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $ (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData. T&. T&))
   :pattern ((proj%vstd!view.View./V $ (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)) (TYPE%vstd!raw_ptr.PtrData.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V (CONST_PTR $) (PTR T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $slice (SLICE T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $slice (SLICE T&. T&)) (TYPE%vstd!seq.Seq. T&. T&))
   :pattern ((proj%vstd!view.View./V $slice (SLICE T&. T&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (REF A&.) A&) (proj%%vstd!view.View./V A&. A&))
   :pattern ((proj%%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (REF A&.) A&) (proj%vstd!view.View./V A&. A&))
   :pattern ((proj%vstd!view.View./V (REF A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&) (proj%vstd!view.View./V
     A&. A&
   ))
   :pattern ((proj%vstd!view.View./V (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%vstd!view.View./V $ TYPE%tuple%0.) $)
)
(assert
 (= (proj%vstd!view.View./V $ TYPE%tuple%0.) TYPE%tuple%0.)
)
(assert
 (= (proj%%vstd!view.View./V $ BOOL) $)
)
(assert
 (= (proj%vstd!view.View./V $ BOOL) BOOL)
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 8)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%vstd!view.View./V $ (UINT 64)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%vstd!view.View./V $ USIZE) $)
)
(assert
 (= (proj%vstd!view.View./V $ USIZE) USIZE)
)
(assert
 (= (proj%%vstd!view.View./V $ (SINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 32)) (SINT 32))
)

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::subrange
(declare-fun vstd!seq.Seq.subrange.? (Dcr Type Poly Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::empty
(declare-fun vstd!seq.Seq.empty.? (Dcr Type) Poly)

;; Function-Decl vstd::seq::Seq::new
(declare-fun vstd!seq.Seq.new.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::push
(declare-fun vstd!seq.Seq.push.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::slice::spec_slice_len
(declare-fun vstd!slice.spec_slice_len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::view::View::view
(declare-fun vstd!view.View.view.? (Dcr Type Poly) Poly)
(declare-fun vstd!view.View.view%default%.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!slice.SliceAdditionalSpecFns.spec_index%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::array::array_view
(declare-fun vstd!array.array_view.? (Dcr Type Dcr Type Poly) Poly)

;; Function-Decl vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun vstd!array.ArrayAdditionalSpecFns.spec_index.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!array.ArrayAdditionalSpecFns.spec_index%default%.? (Dcr Type Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::array::spec_array_as_slice
(declare-fun vstd!array.spec_array_as_slice.? (Dcr Type Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::arithmetic::power::pow
(declare-fun vstd!arithmetic.power.pow.? (Poly Poly) Int)
(declare-fun vstd!arithmetic.power.rec%pow.? (Poly Poly Fuel) Int)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::bits::low_bits_mask
(declare-fun vstd!bits.low_bits_mask.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::core_specs::u8_32_as_nat
(declare-fun curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(declare-fun curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly Poly) Int)
(declare-fun curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? (Poly Poly
  Fuel
 ) Int
)

;; Function-Decl vstd::seq_lib::impl&%0::map
(declare-fun vstd!seq_lib.impl&%0.map.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl curve25519_dalek::specs::core_specs::words_as_nat_gen
(declare-fun curve25519_dalek!specs.core_specs.words_as_nat_gen.? (Poly Poly Poly)
 Int
)
(declare-fun curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? (Poly Poly Poly
  Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::specs::core_specs::words_as_nat_u64
(declare-fun curve25519_dalek!specs.core_specs.words_as_nat_u64.? (Poly Poly Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::seq_as_nat_52
(declare-fun curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.? (Poly) Int)
(declare-fun curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.? (Poly Fuel)
 Int
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::limbs52_as_nat
(declare-fun curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::scalar52_as_nat
(declare-fun curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::limbs_bounded
(declare-fun curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly) Bool)

;; Function-Axioms vstd::seq::Seq::len
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
   (=>
    (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
    (<= 0 (vstd!seq.Seq.len.? A&. A& self!))
   )
   :pattern ((vstd!seq.Seq.len.? A&. A& self!))
   :qid internal_vstd!seq.Seq.len.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.len.?_pre_post_definition
)))

;; Function-Specs vstd::seq::Seq::index
(declare-fun req%vstd!seq.Seq.index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%0 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.Seq.index. A&. A& self! i!) (=>
     %%global_location_label%%0
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.Seq.index. A&. A& self! i!))
   :qid internal_req__vstd!seq.Seq.index._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.index._definition
)))

;; Function-Axioms vstd::seq::Seq::index
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.Seq.index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.Seq.index.? A&. A& self! i!))
   :qid internal_vstd!seq.Seq.index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.index.?_pre_post_definition
)))

;; Function-Specs vstd::seq::impl&%0::spec_index
(declare-fun req%vstd!seq.impl&%0.spec_index. (Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%1 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (= (req%vstd!seq.impl&%0.spec_index. A&. A& self! i!) (=>
     %%global_location_label%%1
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.impl&%0.spec_index. A&. A& self! i!))
   :qid internal_req__vstd!seq.impl&__0.spec_index._definition
   :skolemid skolem_internal_req__vstd!seq.impl&__0.spec_index._definition
)))

;; Function-Axioms vstd::seq::impl&%0::spec_index
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.spec_index.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
    (= (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) (vstd!seq.Seq.index.? A&. A& self!
      i!
    ))
    :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
    :qid internal_vstd!seq.impl&__0.spec_index.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
    )
    (has_type (vstd!seq.impl&%0.spec_index.? A&. A& self! i!) A&)
   )
   :pattern ((vstd!seq.impl&%0.spec_index.? A&. A& self! i!))
   :qid internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.spec_index.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_index_decreases
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_index_decreases.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
      )))
      (height_lt (height (vstd!seq.Seq.index.? A&. A& s! i!)) (height s!))
    ))
    :pattern ((height (vstd!seq.Seq.index.? A&. A& s! i!)))
    :qid user_vstd__seq__axiom_seq_index_decreases_0
    :skolemid skolem_user_vstd__seq__axiom_seq_index_decreases_0
))))

;; Function-Specs vstd::seq::Seq::subrange
(declare-fun req%vstd!seq.Seq.subrange. (Dcr Type Poly Poly Poly) Bool)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (start_inclusive! Poly) (end_exclusive! Poly))
  (!
   (= (req%vstd!seq.Seq.subrange. A&. A& self! start_inclusive! end_exclusive!) (=>
     %%global_location_label%%2
     (let
      ((tmp%%$ (%I start_inclusive!)))
      (let
       ((tmp%%$1 (%I end_exclusive!)))
       (and
        (and
         (<= 0 tmp%%$)
         (<= tmp%%$ tmp%%$1)
        )
        (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& self!))
   )))))
   :pattern ((req%vstd!seq.Seq.subrange. A&. A& self! start_inclusive! end_exclusive!))
   :qid internal_req__vstd!seq.Seq.subrange._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.subrange._definition
)))

;; Function-Axioms vstd::seq::Seq::subrange
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (start_inclusive! Poly) (end_exclusive! Poly))
  (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type start_inclusive! INT)
     (has_type end_exclusive! INT)
    )
    (has_type (vstd!seq.Seq.subrange.? A&. A& self! start_inclusive! end_exclusive!) (
      TYPE%vstd!seq.Seq. A&. A&
   )))
   :pattern ((vstd!seq.Seq.subrange.? A&. A& self! start_inclusive! end_exclusive!))
   :qid internal_vstd!seq.Seq.subrange.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.subrange.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_subrange_decreases
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_decreases.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly) (j! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
      (has_type j! INT)
     )
     (=>
      (and
       (and
        (sized A&.)
        (let
         ((tmp%%$ (%I i!)))
         (let
          ((tmp%%$1 (%I j!)))
          (and
           (and
            (<= 0 tmp%%$)
            (<= tmp%%$ tmp%%$1)
           )
           (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
       ))))
       (< (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! i! j!)) (vstd!seq.Seq.len.?
         A&. A& s!
      )))
      (height_lt (height (vstd!seq.Seq.subrange.? A&. A& s! i! j!)) (height s!))
    ))
    :pattern ((height (vstd!seq.Seq.subrange.? A&. A& s! i! j!)))
    :qid user_vstd__seq__axiom_seq_subrange_decreases_1
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_decreases_1
))))

;; Function-Axioms vstd::seq::Seq::empty
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (has_type (vstd!seq.Seq.empty.? A&. A&) (TYPE%vstd!seq.Seq. A&. A&))
   :pattern ((vstd!seq.Seq.empty.? A&. A&))
   :qid internal_vstd!seq.Seq.empty.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.empty.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_empty
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_empty.)
  (forall ((A&. Dcr) (A& Type)) (!
    (=>
     (sized A&.)
     (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.empty.? A&. A&)) 0)
    )
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.empty.? A&. A&)))
    :qid user_vstd__seq__axiom_seq_empty_2
    :skolemid skolem_user_vstd__seq__axiom_seq_empty_2
))))

;; Function-Axioms vstd::seq::Seq::new
(assert
 (forall ((A&. Dcr) (A& Type) (impl%1&. Dcr) (impl%1& Type) (len! Poly) (f! Poly))
  (!
   (=>
    (and
     (has_type len! NAT)
     (has_type f! impl%1&)
    )
    (has_type (vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!) (TYPE%vstd!seq.Seq.
      A&. A&
   )))
   :pattern ((vstd!seq.Seq.new.? A&. A& impl%1&. impl%1& len! f!))
   :qid internal_vstd!seq.Seq.new.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.new.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_new_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_len.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
     )
     (=>
      (sized A&.)
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        )
       ) (%I len!)
    )))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
    )))
    :qid user_vstd__seq__axiom_seq_new_len_3
    :skolemid skolem_user_vstd__seq__axiom_seq_new_len_3
))))

;; Broadcast vstd::seq::axiom_seq_new_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_new_index.)
  (forall ((A&. Dcr) (A& Type) (len! Poly) (f! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type len! NAT)
      (has_type f! (TYPE%fun%1. $ INT A&. A&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (%I len!))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&)
         len! f!
        ) i!
       ) (%%apply%%0 (%Poly%fun%1. f!) i!)
    )))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT
        A&. A&
       ) len! f!
      ) i!
    ))
    :qid user_vstd__seq__axiom_seq_new_index_4
    :skolemid skolem_user_vstd__seq__axiom_seq_new_index_4
))))

;; Function-Axioms vstd::seq::Seq::push
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (a! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type a! A&)
    )
    (has_type (vstd!seq.Seq.push.? A&. A& self! a!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.Seq.push.? A&. A& self! a!))
   :qid internal_vstd!seq.Seq.push.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.push.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_push_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_push_len.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (a! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type a! A&)
     )
     (=>
      (sized A&.)
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!)) (nClip (Add (vstd!seq.Seq.len.?
          A&. A& s!
         ) 1
    )))))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!)))
    :qid user_vstd__seq__axiom_seq_push_len_5
    :skolemid skolem_user_vstd__seq__axiom_seq_push_len_5
))))

;; Broadcast vstd::seq::axiom_seq_push_index_same
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_push_index_same.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (a! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type a! A&)
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (= (%I i!) (vstd!seq.Seq.len.? A&. A& s!))
      )
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!) i!) a!)
    ))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!) i!))
    :qid user_vstd__seq__axiom_seq_push_index_same_6
    :skolemid skolem_user_vstd__seq__axiom_seq_push_index_same_6
))))

;; Broadcast vstd::seq::axiom_seq_push_index_different
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_push_index_different.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (a! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type a! A&)
      (has_type i! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!) i!) (vstd!seq.Seq.index.?
        A&. A& s! i!
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.push.? A&. A& s! a!) i!))
    :qid user_vstd__seq__axiom_seq_push_index_different_7
    :skolemid skolem_user_vstd__seq__axiom_seq_push_index_different_7
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (= (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2! i$))
          ))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_8
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_8
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_9
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_9
))))

;; Broadcast vstd::seq::axiom_seq_ext_equal_deep
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_ext_equal_deep.)
  (forall ((A&. Dcr) (A& Type) (s1! Poly) (s2! Poly)) (!
    (=>
     (and
      (has_type s1! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type s2! (TYPE%vstd!seq.Seq. A&. A&))
     )
     (=>
      (sized A&.)
      (= (ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!) (and
        (= (vstd!seq.Seq.len.? A&. A& s1!) (vstd!seq.Seq.len.? A&. A& s2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s1!))
            ))
            (ext_eq true A& (vstd!seq.Seq.index.? A&. A& s1! i$) (vstd!seq.Seq.index.? A&. A& s2!
              i$
          ))))
          :pattern ((vstd!seq.Seq.index.? A&. A& s1! i$))
          :pattern ((vstd!seq.Seq.index.? A&. A& s2! i$))
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_10
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_10
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_11
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_11
))))

;; Broadcast vstd::seq::axiom_seq_subrange_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_len.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k! INT)
     )
     (=>
      (and
       (sized A&.)
       (let
        ((tmp%%$ (%I j!)))
        (let
         ((tmp%%$1 (%I k!)))
         (and
          (and
           (<= 0 tmp%%$)
           (<= tmp%%$ tmp%%$1)
          )
          (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
      ))))
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!)) (Sub (%I k!)
        (%I j!)
    ))))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!)))
    :qid user_vstd__seq__axiom_seq_subrange_len_12
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_len_12
))))

;; Broadcast vstd::seq::axiom_seq_subrange_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_subrange_index.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k! INT)
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (sized A&.)
        (let
         ((tmp%%$ (%I j!)))
         (let
          ((tmp%%$1 (%I k!)))
          (and
           (and
            (<= 0 tmp%%$)
            (<= tmp%%$ tmp%%$1)
           )
           (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
       ))))
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (Sub (%I k!) (%I j!)))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!) i!) (vstd!seq.Seq.index.?
        A&. A& s! (I (Add (%I i!) (%I j!)))
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k!) i!))
    :qid user_vstd__seq__axiom_seq_subrange_index_13
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_index_13
))))

;; Broadcast vstd::seq::lemma_seq_two_subranges_index
(assert
 (=>
  (fuel_bool fuel%vstd!seq.lemma_seq_two_subranges_index.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (j! Poly) (k1! Poly) (k2! Poly) (i! Poly))
   (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type j! INT)
      (has_type k1! INT)
      (has_type k2! INT)
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (and
         (and
          (sized A&.)
          (let
           ((tmp%%$ (%I j!)))
           (let
            ((tmp%%$1 (%I k1!)))
            (and
             (and
              (<= 0 tmp%%$)
              (<= tmp%%$ tmp%%$1)
             )
             (<= tmp%%$1 (vstd!seq.Seq.len.? A&. A& s!))
         ))))
         (let
          ((tmp%%$ (%I j!)))
          (let
           ((tmp%%$3 (%I k2!)))
           (and
            (and
             (<= 0 tmp%%$)
             (<= tmp%%$ tmp%%$3)
            )
            (<= tmp%%$3 (vstd!seq.Seq.len.? A&. A& s!))
        ))))
        (let
         ((tmp%%$ (%I i!)))
         (and
          (<= 0 tmp%%$)
          (< tmp%%$ (Sub (%I k1!) (%I j!)))
       )))
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (Sub (%I k2!) (%I j!)))
      )))
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k1!) i!) (vstd!seq.Seq.index.?
        A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k2!) i!
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.subrange.? A&. A& s! j! k1!) i!)
     (vstd!seq.Seq.subrange.? A&. A& s! j! k2!)
    )
    :qid user_vstd__seq__lemma_seq_two_subranges_index_14
    :skolemid skolem_user_vstd__seq__lemma_seq_two_subranges_index_14
))))

;; Function-Axioms vstd::slice::spec_slice_len
(assert
 (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
   (=>
    (has_type slice! (SLICE T&. T&))
    (uInv SZ (vstd!slice.spec_slice_len.? T&. T& slice!))
   )
   :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
   :qid internal_vstd!slice.spec_slice_len.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.spec_slice_len.?_pre_post_definition
)))

;; Function-Axioms vstd::view::View::view
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!view.View.view.? Self%&. Self%& self!) (proj%vstd!view.View./V Self%&.
      Self%&
   )))
   :pattern ((vstd!view.View.view.? Self%&. Self%& self!))
   :qid internal_vstd!view.View.view.?_pre_post_definition
   :skolemid skolem_internal_vstd!view.View.view.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!view.View. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%vstd!view.View. $slice (SLICE T&. T&)))
   :qid internal_vstd__slice__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__0_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_spec_len
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_spec_len.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly)) (!
    (=>
     (has_type slice! (SLICE T&. T&))
     (=>
      (sized T&.)
      (= (vstd!slice.spec_slice_len.? T&. T& slice!) (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.?
         $slice (SLICE T&. T&) slice!
    )))))
    :pattern ((vstd!slice.spec_slice_len.? T&. T& slice!))
    :qid user_vstd__slice__axiom_spec_len_15
    :skolemid skolem_user_vstd__slice__axiom_spec_len_15
))))

;; Function-Specs vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun req%vstd!slice.SliceAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%3
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? Self%&. Self%& self!)))
   ))))
   :pattern ((req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T&
     self! i!
   ))
   :qid internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
   :skolemid skolem_internal_req__vstd!slice.SliceAdditionalSpecFns.spec_index._definition
)))

;; Function-Axioms vstd::slice::SliceAdditionalSpecFns::spec_index
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (=>
    (and
     (has_type self! Self%&)
     (has_type i! INT)
    )
    (has_type (vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
      i!
     ) T&
   ))
   :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
     i!
   ))
   :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_pre_post_definition
)))

;; Function-Axioms vstd::slice::impl&%2::spec_index
(assert
 (fuel_bool_default fuel%vstd!slice.impl&%2.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!slice.impl&%2.spec_index.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&. T& self!
       i!
      ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!)
       i!
    )))
    :pattern ((vstd!slice.SliceAdditionalSpecFns.spec_index.? $slice (SLICE T&. T&) T&.
      T& self! i!
    ))
    :qid internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
    :skolemid skolem_internal_vstd!slice.SliceAdditionalSpecFns.spec_index.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&)
   )
   :pattern ((tr_bound%vstd!slice.SliceAdditionalSpecFns. $slice (SLICE T&. T&) T&. T&))
   :qid internal_vstd__slice__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__slice__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::slice::axiom_slice_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_ext_equal.)
  (forall ((T&. Dcr) (T& Type) (a1! Poly) (a2! Poly)) (!
    (=>
     (and
      (has_type a1! (SLICE T&. T&))
      (has_type a2! (SLICE T&. T&))
     )
     (=>
      (sized T&.)
      (= (ext_eq false (SLICE T&. T&) a1! a2!) (and
        (= (vstd!slice.spec_slice_len.? T&. T& a1!) (vstd!slice.spec_slice_len.? T&. T& a2!))
        (forall ((i$ Poly)) (!
          (=>
           (has_type i$ INT)
           (=>
            (let
             ((tmp%%$ (%I i$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& a1!))
            ))
            (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a1!) i$)
             (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) a2!) i$)
          )))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a1!
            ) i$
          ))
          :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&)
             a2!
            ) i$
          ))
          :qid user_vstd__slice__axiom_slice_ext_equal_16
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_16
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_17
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_17
))))

;; Broadcast vstd::slice::axiom_slice_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!slice.axiom_slice_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (slice! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type slice! (SLICE T&. T&))
      (has_type i! INT)
     )
     (=>
      (sized T&.)
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!slice.spec_slice_len.? T&. T& slice!))
       ))
       (=>
        (has_resolved $slice (SLICE T&. T&) slice!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $slice (SLICE
            T&. T&
           ) slice!
          ) i!
    ))))))
    :pattern ((has_resolved $slice (SLICE T&. T&) slice!) (vstd!seq.Seq.index.? T&. T&
      (vstd!view.View.view.? $slice (SLICE T&. T&) slice!) i!
    ))
    :qid user_vstd__slice__axiom_slice_has_resolved_18
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_18
))))

;; Function-Axioms vstd::array::array_view
(assert
 (fuel_bool_default fuel%vstd!array.array_view.)
)
(declare-fun %%lambda%%0 (Dcr Type Dcr Type %%Function%%) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Dcr) (%%hole%%3 Type) (%%hole%%4
    %%Function%%
   ) (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4) i$)
    (array_index %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 i$)
   )
   :pattern ((%%apply%%0 (%%lambda%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)
     i$
)))))
(assert
 (=>
  (fuel_bool fuel%vstd!array.array_view.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly)) (!
    (= (vstd!array.array_view.? T&. T& N&. N& a!) (vstd!seq.Seq.new.? T&. T& $ (TYPE%fun%1.
       $ INT T&. T&
      ) (I (const_int N&)) (Poly%fun%1. (mk_fun (%%lambda%%0 T&. T& N&. N& (%Poly%array%. a!))))
    ))
    :pattern ((vstd!array.array_view.? T&. T& N&. N& a!))
    :qid internal_vstd!array.array_view.?_definition
    :skolemid skolem_internal_vstd!array.array_view.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly)) (!
   (=>
    (has_type a! (ARRAY T&. T& N&. N&))
    (has_type (vstd!array.array_view.? T&. T& N&. N& a!) (TYPE%vstd!seq.Seq. T&. T&))
   )
   :pattern ((vstd!array.array_view.? T&. T& N&. N& a!))
   :qid internal_vstd!array.array_view.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.array_view.?_pre_post_definition
)))

;; Function-Axioms vstd::array::impl&%0::view
(assert
 (fuel_bool_default fuel%vstd!array.impl&%0.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!array.impl&%0.view.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!) (vstd!array.array_view.? T&.
       T& N&. N& self!
    )))
    :pattern ((vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!view.View. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (ARRAY T&. T& N&. N&)))
   :qid internal_vstd__array__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__array__impl&__0_trait_impl_definition
)))

;; Broadcast vstd::array::array_len_matches_n
(assert
 (=>
  (fuel_bool fuel%vstd!array.array_len_matches_n.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
    (=>
     (has_type ar! (ARRAY T&. T& N&. N&))
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) ar!))
       (const_int N&)
    )))
    :pattern ((vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
       ar!
    )))
    :qid user_vstd__array__array_len_matches_n_19
    :skolemid skolem_user_vstd__array__array_len_matches_n_19
))))

;; Function-Specs vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun req%vstd!array.ArrayAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%4
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? Self%&. Self%& self!)))
   ))))
   :pattern ((req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T&
     self! i!
   ))
   :qid internal_req__vstd!array.ArrayAdditionalSpecFns.spec_index._definition
   :skolemid skolem_internal_req__vstd!array.ArrayAdditionalSpecFns.spec_index._definition
)))

;; Function-Axioms vstd::array::ArrayAdditionalSpecFns::spec_index
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (=>
    (and
     (has_type self! Self%&)
     (has_type i! INT)
    )
    (has_type (vstd!array.ArrayAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
      i!
     ) T&
   ))
   :pattern ((vstd!array.ArrayAdditionalSpecFns.spec_index.? Self%&. Self%& T&. T& self!
     i!
   ))
   :qid internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_pre_post_definition
)))

;; Function-Axioms vstd::array::impl&%2::spec_index
(assert
 (fuel_bool_default fuel%vstd!array.impl&%2.spec_index.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!array.impl&%2.spec_index.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly) (i! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!array.ArrayAdditionalSpecFns.spec_index.? $ (ARRAY T&. T& N&. N&) T&. T& self!
       i!
      ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!)
       i!
    )))
    :pattern ((vstd!array.ArrayAdditionalSpecFns.spec_index.? $ (ARRAY T&. T& N&. N&) T&.
      T& self! i!
    ))
    :qid internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_definition
    :skolemid skolem_internal_vstd!array.ArrayAdditionalSpecFns.spec_index.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!array.ArrayAdditionalSpecFns. $ (ARRAY T&. T& N&. N&) T&. T&)
   )
   :pattern ((tr_bound%vstd!array.ArrayAdditionalSpecFns. $ (ARRAY T&. T& N&. N&) T&.
     T&
   ))
   :qid internal_vstd__array__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__array__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::array::lemma_array_index
(assert
 (=>
  (fuel_bool fuel%vstd!array.lemma_array_index.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type a! (ARRAY T&. T& N&. N&))
      (has_type i! INT)
     )
     (=>
      (and
       (and
        (sized T&.)
        (uInv SZ (const_int N&))
       )
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
      )))
      (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a!)
        i!
       ) (vstd!seq.Seq.index.? T&. T& (vstd!array.array_view.? T&. T& N&. N& a!) i!)
    )))
    :pattern ((array_index T&. T& N&. N& (%Poly%array%. a!) i!))
    :qid user_vstd__array__lemma_array_index_20
    :skolemid skolem_user_vstd__array__lemma_array_index_20
))))

;; Function-Axioms vstd::array::spec_array_as_slice
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
   (=>
    (has_type ar! (ARRAY T&. T& N&. N&))
    (has_type (vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!) (SLICE T&. T&))
   )
   :pattern ((vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!))
   :qid internal_vstd!array.spec_array_as_slice.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.spec_array_as_slice.?_pre_post_definition
)))

;; Broadcast vstd::array::axiom_spec_array_as_slice
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_spec_array_as_slice.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! Poly)) (!
    (=>
     (has_type ar! (ARRAY T&. T& N&. N&))
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (vstd!view.View.view.? $slice (SLICE T&. T&) (vstd!array.spec_array_as_slice.? T&.
         T& N&. N& ar!
        )
       ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) ar!)
    )))
    :pattern ((vstd!array.spec_array_as_slice.? T&. T& N&. N& ar!))
    :qid user_vstd__array__axiom_spec_array_as_slice_21
    :skolemid skolem_user_vstd__array__axiom_spec_array_as_slice_21
))))

;; Broadcast vstd::array::axiom_array_ext_equal
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_array_ext_equal.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a1! Poly) (a2! Poly)) (!
    (=>
     (and
      (has_type a1! (ARRAY T&. T& N&. N&))
      (has_type a2! (ARRAY T&. T& N&. N&))
     )
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (= (ext_eq false (ARRAY T&. T& N&. N&) a1! a2!) (forall ((i$ Poly)) (!
         (=>
          (has_type i$ INT)
          (=>
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ (const_int N&))
           ))
           (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a1!)
             i$
            ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a2!)
             i$
         ))))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            a1!
           ) i$
         ))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            a2!
           ) i$
         ))
         :qid user_vstd__array__axiom_array_ext_equal_22
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_22
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_23
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_23
))))

;; Broadcast vstd::array::axiom_array_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_array_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (array! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type array! (ARRAY T&. T& N&. N&))
      (has_type i! INT)
     )
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
       ))
       (=>
        (has_resolved $ (ARRAY T&. T& N&. N&) array!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&.
            T& N&. N&
           ) array!
          ) i!
    ))))))
    :pattern ((has_resolved $ (ARRAY T&. T& N&. N&) array!) (vstd!seq.Seq.index.? T&. T&
      (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) array!) i!
    ))
    :qid user_vstd__array__axiom_array_has_resolved_24
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_24
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq
(assert
 (forall ((T&. Dcr) (T& Type) (data! Poly)) (!
   (=>
    (has_type data! (TYPE%vstd!raw_ptr.PtrData. T&. T&))
    (has_type (vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!) (PTR T&. T&))
   )
   :pattern ((vstd!raw_ptr.view_reverse_for_eq.? T&. T& data!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. $ (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. $ (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__2_trait_impl_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (= (vstd!raw_ptr.view_reverse_for_eq.? T&. T& (vstd!view.View.view.? $ (PTR T&. T&)
        a!
       )
      ) a!
    ))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_25
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_25
))))

;; Function-Axioms vstd::raw_ptr::view_reverse_for_eq_sized
(assert
 (forall ((T&. Dcr) (T& Type) (addr! Poly) (provenance! Poly)) (!
   (=>
    (and
     (has_type addr! USIZE)
     (has_type provenance! TYPE%vstd!raw_ptr.Provenance.)
    )
    (has_type (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!) (PTR
      T&. T&
   )))
   :pattern ((vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& addr! provenance!))
   :qid internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
   :skolemid skolem_internal_vstd!raw_ptr.view_reverse_for_eq_sized.?_pre_post_definition
)))

;; Broadcast vstd::raw_ptr::ptrs_mut_eq_sized
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.ptrs_mut_eq_sized.)
  (forall ((T&. Dcr) (T& Type) (a! Poly)) (!
    (=>
     (has_type a! (PTR T&. T&))
     (=>
      (sized T&.)
      (= (vstd!raw_ptr.view_reverse_for_eq_sized.? T&. T& (I (vstd!raw_ptr.PtrData./PtrData/addr
          (%Poly%vstd!raw_ptr.PtrData. (vstd!view.View.view.? $ (PTR T&. T&) a!))
         )
        ) (Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.PtrData./PtrData/provenance (%Poly%vstd!raw_ptr.PtrData.
           (vstd!view.View.view.? $ (PTR T&. T&) a!)
        )))
       ) a!
    )))
    :pattern ((vstd!view.View.view.? $ (PTR T&. T&) a!))
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_26
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_26
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_is_ordered_by_denominator
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator. (Int
  Int Int
 ) Bool
)
(declare-const %%global_location_label%%5 Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator. x! y! z!) (and
     (=>
      %%global_location_label%%5
      (<= 0 x!)
     )
     (=>
      %%global_location_label%%6
      (let
       ((tmp%%$ y!))
       (and
        (<= 1 tmp%%$)
        (<= tmp%%$ z!)
   )))))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator. x! y! z!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator. (Int
  Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator. x! y! z!) (>=
     (EucDiv x! y!) (EucDiv x! z!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator. x! y! z!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_div_is_ordered_by_denominator
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_div_is_ordered_by_denominator.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (=>
     (and
      (<= 0 x!)
      (let
       ((tmp%%$ y!))
       (and
        (<= 1 tmp%%$)
        (<= tmp%%$ z!)
     )))
     (>= (EucDiv x! y!) (EucDiv x! z!))
    )
    :pattern ((EucDiv x! y!) (EucDiv x! z!))
    :qid user_vstd__arithmetic__div_mod__lemma_div_is_ordered_by_denominator_27
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_is_ordered_by_denominator_27
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_fundamental_div_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. (Int Int) Bool)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (=>
     %%global_location_label%%7
     (not (= d! 0))
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (= x! (Add (Mul d!
       (EucDiv x! d!)
      ) (EucMod x! d!)
   )))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_fundamental_div_mod
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod.)
  (forall ((x! Int) (d! Int)) (!
    (=>
     (not (= d! 0))
     (= x! (Add (Mul d! (EucDiv x! d!)) (EucMod x! d!)))
    )
    :pattern ((Add (Mul d! (EucDiv x! d!)) (EucMod x! d!)))
    :qid user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_28
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_28
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_division_less_than_divisor
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. (Int
  Int
 ) Bool
)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!) (=>
     %%global_location_label%%8
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. (Int
  Int
 ) Bool
)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!) (let
     ((tmp%%$ (EucMod x! m!)))
     (and
      (<= 0 tmp%%$)
      (< tmp%%$ m!)
   )))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_division_less_than_divisor
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_division_less_than_divisor.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (> m! 0)
     (let
      ((tmp%%$ (EucMod x! m!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ m!)
    )))
    :pattern ((EucMod x! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_division_less_than_divisor_29
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_division_less_than_divisor_29
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_associative
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_associative. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_associative. x! y! z!) (= (Mul x! (Mul y! z!))
     (Mul (Mul x! y!) z!)
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_associative. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_associative._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_associative._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_associative
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_associative.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul x! (Mul y! z!)) (Mul (Mul x! y!) z!))
    :pattern ((Mul x! (Mul y! z!)))
    :pattern ((Mul (Mul x! y!) z!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_associative_30
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_associative_30
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_commutative
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_commutative. (Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_commutative. x! y!) (= (Mul x! y!) (Mul y!
      x!
   )))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_commutative. x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_commutative._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_commutative._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_commutative
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.)
  (forall ((x! Int) (y! Int)) (!
    (= (Mul x! y!) (Mul y! x!))
    :pattern ((Mul x! y!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_31
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_31
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_inequality
(declare-fun req%vstd!arithmetic.mul.lemma_mul_inequality. (Int Int Int) Bool)
(declare-const %%global_location_label%%9 Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_inequality. x! y! z!) (and
     (=>
      %%global_location_label%%9
      (<= x! y!)
     )
     (=>
      %%global_location_label%%10
      (>= z! 0)
   )))
   :pattern ((req%vstd!arithmetic.mul.lemma_mul_inequality. x! y! z!))
   :qid internal_req__vstd!arithmetic.mul.lemma_mul_inequality._definition
   :skolemid skolem_internal_req__vstd!arithmetic.mul.lemma_mul_inequality._definition
)))
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_inequality. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_inequality. x! y! z!) (<= (Mul x! z!) (Mul y!
      z!
   )))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_inequality. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_inequality._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_inequality._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_inequality
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_inequality.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (=>
     (and
      (<= x! y!)
      (>= z! 0)
     )
     (<= (Mul x! z!) (Mul y! z!))
    )
    :pattern ((Mul x! z!) (Mul y! z!))
    :qid user_vstd__arithmetic__mul__lemma_mul_inequality_32
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_inequality_32
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_strict_inequality
(declare-fun req%vstd!arithmetic.mul.lemma_mul_strict_inequality. (Int Int Int) Bool)
(declare-const %%global_location_label%%11 Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_strict_inequality. x! y! z!) (and
     (=>
      %%global_location_label%%11
      (< x! y!)
     )
     (=>
      %%global_location_label%%12
      (> z! 0)
   )))
   :pattern ((req%vstd!arithmetic.mul.lemma_mul_strict_inequality. x! y! z!))
   :qid internal_req__vstd!arithmetic.mul.lemma_mul_strict_inequality._definition
   :skolemid skolem_internal_req__vstd!arithmetic.mul.lemma_mul_strict_inequality._definition
)))
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_strict_inequality. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_strict_inequality. x! y! z!) (< (Mul x! z!) (
      Mul y! z!
   )))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_strict_inequality. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_strict_inequality._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_strict_inequality._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_strict_inequality
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_strict_inequality.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (=>
     (and
      (< x! y!)
      (> z! 0)
     )
     (< (Mul x! z!) (Mul y! z!))
    )
    :pattern ((Mul x! z!) (Mul y! z!))
    :qid user_vstd__arithmetic__mul__lemma_mul_strict_inequality_33
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_strict_inequality_33
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_distributive_add_other_way
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. (Int
  Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. x! y! z!) (= (
      Mul (Add y! z!) x!
     ) (Add (Mul y! x!) (Mul z! x!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_distributive_add_other_way
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul (Add y! z!) x!) (Add (Mul y! x!) (Mul z! x!)))
    :pattern ((Mul (Add y! z!) x!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_other_way_34
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_other_way_34
))))

;; Function-Axioms vstd::arithmetic::power::pow
(declare-const fuel_nat%vstd!arithmetic.power.pow. Fuel)
(assert
 (forall ((b! Poly) (e! Poly) (fuel% Fuel)) (!
   (= (vstd!arithmetic.power.rec%pow.? b! e! fuel%) (vstd!arithmetic.power.rec%pow.? b!
     e! zero
   ))
   :pattern ((vstd!arithmetic.power.rec%pow.? b! e! fuel%))
   :qid internal_vstd!arithmetic.power.pow._fuel_to_zero_definition
   :skolemid skolem_internal_vstd!arithmetic.power.pow._fuel_to_zero_definition
)))
(assert
 (forall ((b! Poly) (e! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type b! INT)
     (has_type e! NAT)
    )
    (= (vstd!arithmetic.power.rec%pow.? b! e! (succ fuel%)) (ite
      (= (%I e!) 0)
      1
      (Mul (%I b!) (vstd!arithmetic.power.rec%pow.? b! (I (nClip (Sub (%I e!) 1))) fuel%))
   )))
   :pattern ((vstd!arithmetic.power.rec%pow.? b! e! (succ fuel%)))
   :qid internal_vstd!arithmetic.power.pow._fuel_to_body_definition
   :skolemid skolem_internal_vstd!arithmetic.power.pow._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.pow.)
  (forall ((b! Poly) (e! Poly)) (!
    (=>
     (and
      (has_type b! INT)
      (has_type e! NAT)
     )
     (= (vstd!arithmetic.power.pow.? b! e!) (vstd!arithmetic.power.rec%pow.? b! e! (succ
        fuel_nat%vstd!arithmetic.power.pow.
    ))))
    :pattern ((vstd!arithmetic.power.pow.? b! e!))
    :qid internal_vstd!arithmetic.power.pow.?_definition
    :skolemid skolem_internal_vstd!arithmetic.power.pow.?_definition
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow_increases
(declare-fun req%vstd!arithmetic.power.lemma_pow_increases. (Int Int Int) Bool)
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((b! Int) (e1! Int) (e2! Int)) (!
   (= (req%vstd!arithmetic.power.lemma_pow_increases. b! e1! e2!) (and
     (=>
      %%global_location_label%%13
      (> b! 0)
     )
     (=>
      %%global_location_label%%14
      (<= e1! e2!)
   )))
   :pattern ((req%vstd!arithmetic.power.lemma_pow_increases. b! e1! e2!))
   :qid internal_req__vstd!arithmetic.power.lemma_pow_increases._definition
   :skolemid skolem_internal_req__vstd!arithmetic.power.lemma_pow_increases._definition
)))
(declare-fun ens%vstd!arithmetic.power.lemma_pow_increases. (Int Int Int) Bool)
(assert
 (forall ((b! Int) (e1! Int) (e2! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma_pow_increases. b! e1! e2!) (<= (vstd!arithmetic.power.pow.?
      (I b!) (I e1!)
     ) (vstd!arithmetic.power.pow.? (I b!) (I e2!))
   ))
   :pattern ((ens%vstd!arithmetic.power.lemma_pow_increases. b! e1! e2!))
   :qid internal_ens__vstd!arithmetic.power.lemma_pow_increases._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma_pow_increases._definition
)))

;; Broadcast vstd::arithmetic::power::lemma_pow_increases
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma_pow_increases.)
  (forall ((b! Poly) (e1! Poly) (e2! Poly)) (!
    (=>
     (and
      (has_type b! NAT)
      (has_type e1! NAT)
      (has_type e2! NAT)
     )
     (=>
      (and
       (> (%I b!) 0)
       (<= (%I e1!) (%I e2!))
      )
      (<= (vstd!arithmetic.power.pow.? b! e1!) (vstd!arithmetic.power.pow.? b! e2!))
    ))
    :pattern ((vstd!arithmetic.power.pow.? b! e1!) (vstd!arithmetic.power.pow.? b! e2!))
    :qid user_vstd__arithmetic__power__lemma_pow_increases_35
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_increases_35
))))

;; Function-Axioms vstd::arithmetic::power2::pow2
(assert
 (forall ((e! Poly)) (!
   (=>
    (has_type e! NAT)
    (<= 0 (vstd!arithmetic.power2.pow2.? e!))
   )
   :pattern ((vstd!arithmetic.power2.pow2.? e!))
   :qid internal_vstd!arithmetic.power2.pow2.?_pre_post_definition
   :skolemid skolem_internal_vstd!arithmetic.power2.pow2.?_pre_post_definition
)))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_pos
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_pos. (Int) Bool)
(assert
 (forall ((e! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_pos. e!) (> (vstd!arithmetic.power2.pow2.?
      (I e!)
     ) 0
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_pos. e!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_pos._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_pos._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_pos
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_pos.)
  (forall ((e! Poly)) (!
    (=>
     (has_type e! NAT)
     (> (vstd!arithmetic.power2.pow2.? e!) 0)
    )
    :pattern ((vstd!arithmetic.power2.pow2.? e!))
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_36
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_36
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2. (Int) Bool)
(assert
 (forall ((e! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2. e!) (= (vstd!arithmetic.power2.pow2.? (I e!))
     (vstd!arithmetic.power.pow.? (I 2) (I e!))
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2. e!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2.)
  (forall ((e! Poly)) (!
    (=>
     (has_type e! NAT)
     (= (vstd!arithmetic.power2.pow2.? e!) (vstd!arithmetic.power.pow.? (I 2) e!))
    )
    :pattern ((vstd!arithmetic.power2.pow2.? e!))
    :qid user_vstd__arithmetic__power2__lemma_pow2_37
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_37
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_adds
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_adds. (Int Int) Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_adds. e1! e2!) (= (vstd!arithmetic.power2.pow2.?
      (I (nClip (Add e1! e2!)))
     ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I e1!)) (vstd!arithmetic.power2.pow2.?
        (I e2!)
   )))))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_adds. e1! e2!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_adds._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_adds._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_adds
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_adds.)
  (forall ((e1! Int) (e2! Int)) (!
    (=>
     (and
      (<= 0 e1!)
      (<= 0 e2!)
     )
     (= (vstd!arithmetic.power2.pow2.? (I (nClip (Add e1! e2!)))) (nClip (Mul (vstd!arithmetic.power2.pow2.?
         (I e1!)
        ) (vstd!arithmetic.power2.pow2.? (I e2!))
    ))))
    :pattern ((vstd!arithmetic.power2.pow2.? (I (nClip (Add e1! e2!)))))
    :qid user_vstd__arithmetic__power2__lemma_pow2_adds_38
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_adds_38
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_strictly_increases
(declare-fun req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. (Int Int) Bool)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!) (=>
     %%global_location_label%%15
     (< e1! e2!)
   ))
   :pattern ((req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!))
   :qid internal_req__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
   :skolemid skolem_internal_req__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
)))
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_strictly_increases. (Int Int) Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!) (< (vstd!arithmetic.power2.pow2.?
      (I e1!)
     ) (vstd!arithmetic.power2.pow2.? (I e2!))
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_strictly_increases._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_strictly_increases
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases.)
  (forall ((e1! Poly) (e2! Poly)) (!
    (=>
     (and
      (has_type e1! NAT)
      (has_type e2! NAT)
     )
     (=>
      (< (%I e1!) (%I e2!))
      (< (vstd!arithmetic.power2.pow2.? e1!) (vstd!arithmetic.power2.pow2.? e2!))
    ))
    :pattern ((vstd!arithmetic.power2.pow2.? e1!) (vstd!arithmetic.power2.pow2.? e2!))
    :qid user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_39
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_39
))))

;; Function-Specs vstd::bits::lemma_u64_shr_is_div
(declare-fun req%vstd!bits.lemma_u64_shr_is_div. (Int Int) Bool)
(declare-const %%global_location_label%%16 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u64_shr_is_div. x! shift!) (=>
     %%global_location_label%%16
     (let
      ((tmp%%$ shift!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ 64)
   ))))
   :pattern ((req%vstd!bits.lemma_u64_shr_is_div. x! shift!))
   :qid internal_req__vstd!bits.lemma_u64_shr_is_div._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u64_shr_is_div._definition
)))
(declare-fun ens%vstd!bits.lemma_u64_shr_is_div. (Int Int) Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (ens%vstd!bits.lemma_u64_shr_is_div. x! shift!) (= (uClip 64 (bitshr (I x!) (I shift!)))
     (EucDiv x! (vstd!arithmetic.power2.pow2.? (I shift!)))
   ))
   :pattern ((ens%vstd!bits.lemma_u64_shr_is_div. x! shift!))
   :qid internal_ens__vstd!bits.lemma_u64_shr_is_div._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u64_shr_is_div._definition
)))

;; Broadcast vstd::bits::lemma_u64_shr_is_div
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u64_shr_is_div.)
  (forall ((x! Poly) (shift! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 64))
      (has_type shift! (UINT 64))
     )
     (=>
      (let
       ((tmp%%$ (%I shift!)))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 64)
      ))
      (= (uClip 64 (bitshr (I (%I x!)) (I (%I shift!)))) (EucDiv (%I x!) (vstd!arithmetic.power2.pow2.?
         shift!
    )))))
    :pattern ((uClip 64 (bitshr (I (%I x!)) (I (%I shift!)))))
    :qid user_vstd__bits__lemma_u64_shr_is_div_40
    :skolemid skolem_user_vstd__bits__lemma_u64_shr_is_div_40
))))

;; Function-Specs vstd::bits::lemma_u64_pow2_no_overflow
(declare-fun req%vstd!bits.lemma_u64_pow2_no_overflow. (Int) Bool)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((n! Int)) (!
   (= (req%vstd!bits.lemma_u64_pow2_no_overflow. n!) (=>
     %%global_location_label%%17
     (let
      ((tmp%%$ n!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ 64)
   ))))
   :pattern ((req%vstd!bits.lemma_u64_pow2_no_overflow. n!))
   :qid internal_req__vstd!bits.lemma_u64_pow2_no_overflow._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u64_pow2_no_overflow._definition
)))
(declare-fun ens%vstd!bits.lemma_u64_pow2_no_overflow. (Int) Bool)
(assert
 (forall ((n! Int)) (!
   (= (ens%vstd!bits.lemma_u64_pow2_no_overflow. n!) (let
     ((tmp%%$ (vstd!arithmetic.power2.pow2.? (I n!))))
     (and
      (< 0 tmp%%$)
      (< tmp%%$ 18446744073709551615)
   )))
   :pattern ((ens%vstd!bits.lemma_u64_pow2_no_overflow. n!))
   :qid internal_ens__vstd!bits.lemma_u64_pow2_no_overflow._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u64_pow2_no_overflow._definition
)))

;; Broadcast vstd::bits::lemma_u64_pow2_no_overflow
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u64_pow2_no_overflow.)
  (forall ((n! Poly)) (!
    (=>
     (has_type n! NAT)
     (=>
      (let
       ((tmp%%$ (%I n!)))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 64)
      ))
      (let
       ((tmp%%$ (vstd!arithmetic.power2.pow2.? n!)))
       (and
        (< 0 tmp%%$)
        (< tmp%%$ 18446744073709551615)
    ))))
    :pattern ((vstd!arithmetic.power2.pow2.? n!))
    :qid user_vstd__bits__lemma_u64_pow2_no_overflow_41
    :skolemid skolem_user_vstd__bits__lemma_u64_pow2_no_overflow_41
))))

;; Function-Specs vstd::bits::lemma_u64_shl_is_mul
(declare-fun req%vstd!bits.lemma_u64_shl_is_mul. (Int Int) Bool)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u64_shl_is_mul. x! shift!) (and
     (=>
      %%global_location_label%%18
      (let
       ((tmp%%$ shift!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 64)
     )))
     (=>
      %%global_location_label%%19
      (<= (Mul x! (vstd!arithmetic.power2.pow2.? (I shift!))) 18446744073709551615)
   )))
   :pattern ((req%vstd!bits.lemma_u64_shl_is_mul. x! shift!))
   :qid internal_req__vstd!bits.lemma_u64_shl_is_mul._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u64_shl_is_mul._definition
)))
(declare-fun ens%vstd!bits.lemma_u64_shl_is_mul. (Int Int) Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (ens%vstd!bits.lemma_u64_shl_is_mul. x! shift!) (= (uClip 64 (bitshl (I x!) (I shift!)))
     (Mul x! (vstd!arithmetic.power2.pow2.? (I shift!)))
   ))
   :pattern ((ens%vstd!bits.lemma_u64_shl_is_mul. x! shift!))
   :qid internal_ens__vstd!bits.lemma_u64_shl_is_mul._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u64_shl_is_mul._definition
)))

;; Broadcast vstd::bits::lemma_u64_shl_is_mul
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u64_shl_is_mul.)
  (forall ((x! Poly) (shift! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 64))
      (has_type shift! (UINT 64))
     )
     (=>
      (and
       (let
        ((tmp%%$ (%I shift!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ 64)
       ))
       (<= (Mul (%I x!) (vstd!arithmetic.power2.pow2.? shift!)) 18446744073709551615)
      )
      (= (uClip 64 (bitshl (I (%I x!)) (I (%I shift!)))) (Mul (%I x!) (vstd!arithmetic.power2.pow2.?
         shift!
    )))))
    :pattern ((uClip 64 (bitshl (I (%I x!)) (I (%I shift!)))))
    :qid user_vstd__bits__lemma_u64_shl_is_mul_42
    :skolemid skolem_user_vstd__bits__lemma_u64_shl_is_mul_42
))))

;; Function-Axioms vstd::bits::low_bits_mask
(assert
 (fuel_bool_default fuel%vstd!bits.low_bits_mask.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!bits.low_bits_mask.)
  (forall ((n! Poly)) (!
    (= (vstd!bits.low_bits_mask.? n!) (nClip (Sub (vstd!arithmetic.power2.pow2.? n!) 1)))
    :pattern ((vstd!bits.low_bits_mask.? n!))
    :qid internal_vstd!bits.low_bits_mask.?_definition
    :skolemid skolem_internal_vstd!bits.low_bits_mask.?_definition
))))
(assert
 (forall ((n! Poly)) (!
   (=>
    (has_type n! NAT)
    (<= 0 (vstd!bits.low_bits_mask.? n!))
   )
   :pattern ((vstd!bits.low_bits_mask.? n!))
   :qid internal_vstd!bits.low_bits_mask.?_pre_post_definition
   :skolemid skolem_internal_vstd!bits.low_bits_mask.?_pre_post_definition
)))

;; Function-Specs vstd::bits::lemma_u64_low_bits_mask_is_mod
(declare-fun req%vstd!bits.lemma_u64_low_bits_mask_is_mod. (Int Int) Bool)
(declare-const %%global_location_label%%20 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%vstd!bits.lemma_u64_low_bits_mask_is_mod. x! n!) (=>
     %%global_location_label%%20
     (< n! 64)
   ))
   :pattern ((req%vstd!bits.lemma_u64_low_bits_mask_is_mod. x! n!))
   :qid internal_req__vstd!bits.lemma_u64_low_bits_mask_is_mod._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u64_low_bits_mask_is_mod._definition
)))
(declare-fun ens%vstd!bits.lemma_u64_low_bits_mask_is_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (ens%vstd!bits.lemma_u64_low_bits_mask_is_mod. x! n!) (= (uClip 64 (bitand (I x!)
       (I (uClip 64 (vstd!bits.low_bits_mask.? (I n!))))
      )
     ) (EucMod x! (uClip 64 (vstd!arithmetic.power2.pow2.? (I n!))))
   ))
   :pattern ((ens%vstd!bits.lemma_u64_low_bits_mask_is_mod. x! n!))
   :qid internal_ens__vstd!bits.lemma_u64_low_bits_mask_is_mod._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u64_low_bits_mask_is_mod._definition
)))

;; Broadcast vstd::bits::lemma_u64_low_bits_mask_is_mod
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u64_low_bits_mask_is_mod.)
  (forall ((x! Poly) (n! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 64))
      (has_type n! NAT)
     )
     (=>
      (< (%I n!) 64)
      (= (uClip 64 (bitand (I (%I x!)) (I (uClip 64 (vstd!bits.low_bits_mask.? n!))))) (
        EucMod (%I x!) (uClip 64 (vstd!arithmetic.power2.pow2.? n!))
    ))))
    :pattern ((uClip 64 (bitand (I (%I x!)) (I (uClip 64 (vstd!bits.low_bits_mask.? n!))))))
    :qid user_vstd__bits__lemma_u64_low_bits_mask_is_mod_43
    :skolemid skolem_user_vstd__bits__lemma_u64_low_bits_mask_is_mod_43
))))

;; Function-Axioms vstd::raw_ptr::impl&%3::view
(assert
 (fuel_bool_default fuel%vstd!raw_ptr.impl&%3.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!raw_ptr.impl&%3.view.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (= (vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!) (vstd!view.View.view.?
      $ (PTR T&. T&) self!
    ))
    :pattern ((vstd!view.View.view.? (CONST_PTR $) (PTR T&. T&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%vstd!view.View. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_vstd__raw_ptr__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__raw_ptr__impl&__3_trait_impl_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::u8_32_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat.)
  (forall ((bytes! Poly)) (!
    (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!) (nClip (Add (nClip (Add (
          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (
                          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (
                                          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (
                                                          nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Mul (%I (vstd!seq.Seq.index.?
                                                                       $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) bytes!) (
                                                                        I 0
                                                                      ))
                                                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 0 8))))
                                                                    )
                                                                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                          8
                                                                         ) $ (CONST_INT 32)
                                                                        ) bytes!
                                                                       ) (I 1)
                                                                      )
                                                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 1 8))))
                                                                  )))
                                                                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                        8
                                                                       ) $ (CONST_INT 32)
                                                                      ) bytes!
                                                                     ) (I 2)
                                                                    )
                                                                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 2 8))))
                                                                )))
                                                               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                      8
                                                                     ) $ (CONST_INT 32)
                                                                    ) bytes!
                                                                   ) (I 3)
                                                                  )
                                                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 3 8))))
                                                              )))
                                                             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                    8
                                                                   ) $ (CONST_INT 32)
                                                                  ) bytes!
                                                                 ) (I 4)
                                                                )
                                                               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 4 8))))
                                                            )))
                                                           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                  8
                                                                 ) $ (CONST_INT 32)
                                                                ) bytes!
                                                               ) (I 5)
                                                              )
                                                             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 5 8))))
                                                          )))
                                                         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                8
                                                               ) $ (CONST_INT 32)
                                                              ) bytes!
                                                             ) (I 6)
                                                            )
                                                           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 6 8))))
                                                        )))
                                                       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                              8
                                                             ) $ (CONST_INT 32)
                                                            ) bytes!
                                                           ) (I 7)
                                                          )
                                                         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 7 8))))
                                                      )))
                                                     ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                            8
                                                           ) $ (CONST_INT 32)
                                                          ) bytes!
                                                         ) (I 8)
                                                        )
                                                       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 8 8))))
                                                    )))
                                                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                          8
                                                         ) $ (CONST_INT 32)
                                                        ) bytes!
                                                       ) (I 9)
                                                      )
                                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 9 8))))
                                                  )))
                                                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                        8
                                                       ) $ (CONST_INT 32)
                                                      ) bytes!
                                                     ) (I 10)
                                                    )
                                                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 10 8))))
                                                )))
                                               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                      8
                                                     ) $ (CONST_INT 32)
                                                    ) bytes!
                                                   ) (I 11)
                                                  )
                                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 11 8))))
                                              )))
                                             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                    8
                                                   ) $ (CONST_INT 32)
                                                  ) bytes!
                                                 ) (I 12)
                                                )
                                               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 12 8))))
                                            )))
                                           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                  8
                                                 ) $ (CONST_INT 32)
                                                ) bytes!
                                               ) (I 13)
                                              )
                                             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 13 8))))
                                          )))
                                         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                8
                                               ) $ (CONST_INT 32)
                                              ) bytes!
                                             ) (I 14)
                                            )
                                           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 14 8))))
                                        )))
                                       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                              8
                                             ) $ (CONST_INT 32)
                                            ) bytes!
                                           ) (I 15)
                                          )
                                         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 15 8))))
                                      )))
                                     ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                            8
                                           ) $ (CONST_INT 32)
                                          ) bytes!
                                         ) (I 16)
                                        )
                                       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 16 8))))
                                    )))
                                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                          8
                                         ) $ (CONST_INT 32)
                                        ) bytes!
                                       ) (I 17)
                                      )
                                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 17 8))))
                                  )))
                                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                        8
                                       ) $ (CONST_INT 32)
                                      ) bytes!
                                     ) (I 18)
                                    )
                                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 18 8))))
                                )))
                               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                      8
                                     ) $ (CONST_INT 32)
                                    ) bytes!
                                   ) (I 19)
                                  )
                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 19 8))))
                              )))
                             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                    8
                                   ) $ (CONST_INT 32)
                                  ) bytes!
                                 ) (I 20)
                                )
                               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 20 8))))
                            )))
                           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                  8
                                 ) $ (CONST_INT 32)
                                ) bytes!
                               ) (I 21)
                              )
                             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 21 8))))
                          )))
                         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                8
                               ) $ (CONST_INT 32)
                              ) bytes!
                             ) (I 22)
                            )
                           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 22 8))))
                        )))
                       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                              8
                             ) $ (CONST_INT 32)
                            ) bytes!
                           ) (I 23)
                          )
                         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 23 8))))
                      )))
                     ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                            8
                           ) $ (CONST_INT 32)
                          ) bytes!
                         ) (I 24)
                        )
                       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 24 8))))
                    )))
                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                          8
                         ) $ (CONST_INT 32)
                        ) bytes!
                       ) (I 25)
                      )
                     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 25 8))))
                  )))
                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                        8
                       ) $ (CONST_INT 32)
                      ) bytes!
                     ) (I 26)
                    )
                   ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 26 8))))
                )))
               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                      8
                     ) $ (CONST_INT 32)
                    ) bytes!
                   ) (I 27)
                  )
                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 27 8))))
              )))
             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                    8
                   ) $ (CONST_INT 32)
                  ) bytes!
                 ) (I 28)
                )
               ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 28 8))))
            )))
           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                  8
                 ) $ (CONST_INT 32)
                ) bytes!
               ) (I 29)
              )
             ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 29 8))))
          )))
         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                8
               ) $ (CONST_INT 32)
              ) bytes!
             ) (I 30)
            )
           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 30 8))))
        )))
       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
              8
             ) $ (CONST_INT 32)
            ) bytes!
           ) (I 31)
          )
         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 31 8))))
    )))))
    :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!))
    :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_definition
))))
(assert
 (forall ((bytes! Poly)) (!
   (=>
    (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (<= 0 (curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!))
   :qid internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.u8_32_as_nat.?_pre_post_definition
)))

;; Function-Specs curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(declare-fun req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. (Poly Poly)
 Bool
)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((bytes! Poly) (j! Poly)) (!
   (= (req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. bytes! j!) (=>
     %%global_location_label%%21
     (<= (%I j!) (vstd!seq.Seq.len.? $ (UINT 8) bytes!))
   ))
   :pattern ((req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. bytes! j!))
   :qid internal_req__curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. Fuel)
(assert
 (forall ((bytes! Poly) (j! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%) (
     curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_zero_definition
)))
(assert
 (forall ((bytes! Poly) (j! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type j! NAT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! (succ fuel%))
     (ite
      (= (%I j!) 0)
      0
      (let
       ((j1$ (nClip (Sub (%I j!) 1))))
       (nClip (Add (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! (I j1$)
          fuel%
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul j1$ 8)))) (%I (vstd!seq.Seq.index.?
             $ (UINT 8) bytes! (I j1$)
   ))))))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! (succ
      fuel%
   )))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
  (forall ((bytes! Poly) (j! Poly)) (!
    (=>
     (and
      (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
      (has_type j! NAT)
     )
     (= (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!) (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.?
       bytes! j! (succ fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!))
    :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_definition
))))
(assert
 (forall ((bytes! Poly) (j! Poly)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type j! NAT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? bytes! j!))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.?_pre_post_definition
)))
(assert
 (forall ((bytes! Poly) (j! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type j! NAT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%))
   )
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? bytes! j! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.rec__bytes_as_nat_prefix.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__bytes_as_nat_prefix.?_pre_post_rec_definition
)))

;; Function-Axioms vstd::seq_lib::impl&%0::map
(assert
 (fuel_bool_default fuel%vstd!seq_lib.impl&%0.map.)
)
(declare-fun %%lambda%%1 (Dcr Type Poly %%Function%%) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Poly) (%%hole%%3 %%Function%%)
   (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) i$) (%%apply%%1
     %%hole%%3 i$ (vstd!seq.Seq.index.? %%hole%%0 %%hole%%1 %%hole%%2 i$)
   ))
   :pattern ((%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) i$))
)))
(assert
 (=>
  (fuel_bool fuel%vstd!seq_lib.impl&%0.map.)
  (forall ((A&. Dcr) (A& Type) (B&. Dcr) (B& Type) (self! Poly) (f! Poly)) (!
    (= (vstd!seq_lib.impl&%0.map.? A&. A& B&. B& self! f!) (vstd!seq.Seq.new.? B&. B& $
      (TYPE%fun%1. $ INT B&. B&) (I (vstd!seq.Seq.len.? A&. A& self!)) (Poly%fun%1. (mk_fun
        (%%lambda%%1 A&. A& self! (%Poly%fun%2. f!))
    ))))
    :pattern ((vstd!seq_lib.impl&%0.map.? A&. A& B&. B& self! f!))
    :qid internal_vstd!seq_lib.impl&__0.map.?_definition
    :skolemid skolem_internal_vstd!seq_lib.impl&__0.map.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (B&. Dcr) (B& Type) (self! Poly) (f! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type f! (TYPE%fun%2. $ INT A&. A& B&. B&))
    )
    (has_type (vstd!seq_lib.impl&%0.map.? A&. A& B&. B& self! f!) (TYPE%vstd!seq.Seq. B&.
      B&
   )))
   :pattern ((vstd!seq_lib.impl&%0.map.? A&. A& B&. B& self! f!))
   :qid internal_vstd!seq_lib.impl&__0.map.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq_lib.impl&__0.map.?_pre_post_definition
)))

;; Function-Axioms vstd::view::impl&%0::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%0.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%0.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (REF A&.) A& self!) (vstd!view.View.view.? A&. A& self!))
    )
    :pattern ((vstd!view.View.view.? (REF A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%2::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%2.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%2.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (tr_bound%vstd!view.View. A&. A&)
     (= (vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (BOX $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%4::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%4.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%4.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (RC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%6::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%6.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%6.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!view.View. A&. A&)
     )
     (= (vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!) (vstd!view.View.view.?
       A&. A& self!
    )))
    :pattern ((vstd!view.View.view.? (ARC $ ALLOCATOR_GLOBAL A&.) A& self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%12::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%12.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%12.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ TYPE%tuple%0. self!) self!)
    :pattern ((vstd!view.View.view.? $ TYPE%tuple%0. self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%14::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%14.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%14.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ BOOL self!) self!)
    :pattern ((vstd!view.View.view.? $ BOOL self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%16::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%16.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%16.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 8) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 8) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%20::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%20.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%20.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 32) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 32) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%22::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%22.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%22.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 64) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 64) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%26::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%26.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%26.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ USIZE self!) self!)
    :pattern ((vstd!view.View.view.? $ USIZE self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%32::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%32.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%32.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (SINT 32) self!) self!)
    :pattern ((vstd!view.View.view.? $ (SINT 32) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::core_specs::words_as_nat_gen
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.words_as_nat_gen. Fuel)
(assert
 (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words! bits_per_word!
     fuel%
    ) (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words! bits_per_word!
     zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words!
     bits_per_word! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_gen._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_gen._fuel_to_zero_definition
)))
(assert
 (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type words! (TYPE%vstd!seq.Seq. $ NAT))
     (has_type num_words! INT)
     (has_type bits_per_word! INT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words! bits_per_word!
      (succ fuel%)
     ) (ite
      (<= (%I num_words!) 0)
      0
      (let
       ((word_value$ (nClip (Mul (%I (vstd!seq.Seq.index.? $ NAT words! (I (Sub (%I num_words!)
               1
            )))
           ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (Sub (%I num_words!) 1) (%I bits_per_word!)))))
       ))))
       (nClip (Add word_value$ (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words!
          (I (Sub (%I num_words!) 1)) bits_per_word! fuel%
   )))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words!
     bits_per_word! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_gen._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_gen._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen.)
  (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly)) (!
    (=>
     (and
      (has_type words! (TYPE%vstd!seq.Seq. $ NAT))
      (has_type num_words! INT)
      (has_type bits_per_word! INT)
     )
     (= (curve25519_dalek!specs.core_specs.words_as_nat_gen.? words! num_words! bits_per_word!)
      (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words! bits_per_word!
       (succ fuel_nat%curve25519_dalek!specs.core_specs.words_as_nat_gen.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.words_as_nat_gen.? words! num_words! bits_per_word!))
    :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_gen.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_gen.?_definition
))))
(assert
 (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly)) (!
   (=>
    (and
     (has_type words! (TYPE%vstd!seq.Seq. $ NAT))
     (has_type num_words! INT)
     (has_type bits_per_word! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.words_as_nat_gen.? words! num_words! bits_per_word!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.words_as_nat_gen.? words! num_words! bits_per_word!))
   :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_gen.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_gen.?_pre_post_definition
)))
(assert
 (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type words! (TYPE%vstd!seq.Seq. $ NAT))
     (has_type num_words! INT)
     (has_type bits_per_word! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words! bits_per_word!
      fuel%
   )))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words_as_nat_gen.? words! num_words!
     bits_per_word! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.rec__words_as_nat_gen.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__words_as_nat_gen.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::words_as_nat_u64
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.words_as_nat_u64.)
)
(declare-fun %%lambda%%2 () %%Function%%)
(assert
 (forall ((i$ Poly) (x$ Poly)) (!
   (= (%%apply%%1 %%lambda%%2 i$ x$) x$)
   :pattern ((%%apply%%1 %%lambda%%2 i$ x$))
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.words_as_nat_u64.)
  (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly)) (!
    (= (curve25519_dalek!specs.core_specs.words_as_nat_u64.? words! num_words! bits_per_word!)
     (curve25519_dalek!specs.core_specs.words_as_nat_gen.? (vstd!seq_lib.impl&%0.map.? $
       (UINT 64) $ NAT (vstd!view.View.view.? $slice (SLICE $ (UINT 64)) words!) (Poly%fun%2.
        (mk_fun %%lambda%%2)
       )
      ) num_words! bits_per_word!
    ))
    :pattern ((curve25519_dalek!specs.core_specs.words_as_nat_u64.? words! num_words! bits_per_word!))
    :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_u64.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_u64.?_definition
))))
(assert
 (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly)) (!
   (=>
    (and
     (has_type words! (SLICE $ (UINT 64)))
     (has_type num_words! INT)
     (has_type bits_per_word! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.words_as_nat_u64.? words! num_words! bits_per_word!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.words_as_nat_u64.? words! num_words! bits_per_word!))
   :qid internal_curve25519_dalek!specs.core_specs.words_as_nat_u64.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words_as_nat_u64.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::seq_as_nat_52
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.)
)
(declare-const fuel_nat%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52. Fuel)
(assert
 (forall ((limbs! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.? limbs! fuel%) (curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.?
     limbs! zero
   ))
   :pattern ((curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.? limbs! fuel%))
   :qid internal_curve25519_dalek!specs.scalar52_specs.seq_as_nat_52._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.seq_as_nat_52._fuel_to_zero_definition
)))
(assert
 (forall ((limbs! Poly) (fuel% Fuel)) (!
   (=>
    (has_type limbs! (TYPE%vstd!seq.Seq. $ NAT))
    (= (curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.? limbs! (succ fuel%))
     (ite
      (= (vstd!seq.Seq.len.? $ NAT limbs!) 0)
      0
      (nClip (Add (%I (vstd!seq.Seq.index.? $ NAT limbs! (I 0))) (nClip (Mul (curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.?
           (vstd!seq.Seq.subrange.? $ NAT limbs! (I 1) (I (vstd!seq.Seq.len.? $ NAT limbs!)))
           fuel%
          ) (vstd!arithmetic.power2.pow2.? (I 52))
   )))))))
   :pattern ((curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.? limbs! (succ fuel%)))
   :qid internal_curve25519_dalek!specs.scalar52_specs.seq_as_nat_52._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.seq_as_nat_52._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.)
  (forall ((limbs! Poly)) (!
    (=>
     (has_type limbs! (TYPE%vstd!seq.Seq. $ NAT))
     (= (curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.? limbs!) (curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.?
       limbs! (succ fuel_nat%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.)
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.? limbs!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (TYPE%vstd!seq.Seq. $ NAT))
    (<= 0 (curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.? limbs!))
   :qid internal_curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.?_pre_post_definition
)))
(assert
 (forall ((limbs! Poly) (fuel% Fuel)) (!
   (=>
    (has_type limbs! (TYPE%vstd!seq.Seq. $ NAT))
    (<= 0 (curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.? limbs! fuel%))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.? limbs! fuel%))
   :qid internal_curve25519_dalek!specs.scalar52_specs.rec__seq_as_nat_52.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.rec__seq_as_nat_52.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::limbs52_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.? limbs!) (curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.?
      (vstd!seq_lib.impl&%0.map.? $ (UINT 64) $ NAT (vstd!view.View.view.? $slice (SLICE $
         (UINT 64)
        ) limbs!
       ) (Poly%fun%2. (mk_fun %%lambda%%2))
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.? limbs!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (SLICE $ (UINT 64)))
    (<= 0 (curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.? limbs!))
   :qid internal_curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::scalar52_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.)
  (forall ((s! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? s!) (curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.?
      (vstd!array.spec_array_as_slice.? $ (UINT 64) $ (CONST_INT 5) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. s!)
    )))))
    :pattern ((curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? s!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.?_definition
))))
(assert
 (forall ((s! Poly)) (!
   (=>
    (has_type s! TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
    (<= 0 (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? s!))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? s!))
   :qid internal_curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded.)
  (forall ((s! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? s!) (forall ((i$ Poly)) (
       !
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
               (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. s!)
             ))
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I 52)))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. s!)
          ))
         ) i$
       ))
       :qid user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_44
       :skolemid skolem_user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_44
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.limbs_bounded.? s!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.limbs_bounded.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (REF A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (REF A&.) A&))
   :qid internal_vstd__view__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%vstd!view.View. A&. A&)
    (tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (BOX $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (RC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__4_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!view.View. A&. A&)
    )
    (tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&)
   )
   :pattern ((tr_bound%vstd!view.View. (ARC $ ALLOCATOR_GLOBAL A&.) A&))
   :qid internal_vstd__view__impl&__6_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (SINT 32))
)

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::bit_lemmas::lemma_u64_bit_or_is_plus
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.bit_lemmas.lemma_u64_bit_or_is_plus.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%22 Bool)
(declare-const %%global_location_label%%23 Bool)
(declare-const %%global_location_label%%24 Bool)
(assert
 (forall ((a! Int) (b! Int) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.bit_lemmas.lemma_u64_bit_or_is_plus.
     a! b! k!
    ) (and
     (=>
      %%global_location_label%%22
      (< k! 64)
     )
     (=>
      %%global_location_label%%23
      (< a! (uClip 64 (bitshl (I (uClip 64 1)) (I k!))))
     )
     (=>
      %%global_location_label%%24
      (<= b! (uClip 64 (bitshr (I 18446744073709551615) (I k!))))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.bit_lemmas.lemma_u64_bit_or_is_plus.
     a! b! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.bit_lemmas.lemma_u64_bit_or_is_plus._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.bit_lemmas.lemma_u64_bit_or_is_plus._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.bit_lemmas.lemma_u64_bit_or_is_plus.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.bit_lemmas.lemma_u64_bit_or_is_plus.
     a! b! k!
    ) (= (uClip 64 (bitor (I a!) (I (uClip 64 (bitshl (I b!) (I k!)))))) (Add a! (uClip
       64 (bitshl (I b!) (I k!))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.bit_lemmas.lemma_u64_bit_or_is_plus.
     a! b! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.bit_lemmas.lemma_u64_bit_or_is_plus._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.bit_lemmas.lemma_u64_bit_or_is_plus._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::mul_lemmas::lemma_mul_le
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. (Int
  Int Int Int
 ) Bool
)
(declare-const %%global_location_label%%25 Bool)
(declare-const %%global_location_label%%26 Bool)
(assert
 (forall ((a1! Int) (b1! Int) (a2! Int) (b2! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. a1! b1! a2!
     b2!
    ) (and
     (=>
      %%global_location_label%%25
      (<= a1! b1!)
     )
     (=>
      %%global_location_label%%26
      (<= a2! b2!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. a1! b1!
     a2! b2!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. (Int
  Int Int Int
 ) Bool
)
(assert
 (forall ((a1! Int) (b1! Int) (a2! Int) (b2! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. a1! b1! a2!
     b2!
    ) (<= (nClip (Mul a1! a2!)) (nClip (Mul b1! b2!)))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. a1! b1!
     a2! b2!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_byte_lemmas::bytes_to_scalar_lemmas::lemma_byte_to_word_step
(declare-fun req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step.
 (%%Function%% %%Function%% Int Int) Bool
)
(declare-fun %%lambda%%3 (Int Dcr Type Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Int) (%%hole%%1 Dcr) (%%hole%%2 Type) (%%hole%%3 Poly) (j2$ Poly))
  (!
   (= (%%apply%%0 (%%lambda%%3 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) j2$) (vstd!seq.Seq.index.?
     %%hole%%1 %%hole%%2 %%hole%%3 (I (Add %%hole%%0 (%I j2$)))
   ))
   :pattern ((%%apply%%0 (%%lambda%%3 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) j2$))
)))
(declare-const %%global_location_label%%27 Bool)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(assert
 (forall ((bytes! %%Function%%) (words! %%Function%%) (i! Int) (j! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step.
     bytes! words! i! j!
    ) (and
     (=>
      %%global_location_label%%27
      (and
       (let
        ((tmp%%$ j!))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ 8)
       ))
       (let
        ((tmp%%$ i!))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ 4)
     ))))
     (=>
      %%global_location_label%%28
      (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 4)
          ) (Poly%array%. words!)
         ) (I i!)
        )
       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul j! 8))))
     ))
     (=>
      %%global_location_label%%29
      (forall ((i2$ Poly)) (!
        (=>
         (has_type i2$ INT)
         (=>
          (let
           ((tmp%%$ (%I i2$)))
           (and
            (<= (Add i! 1) tmp%%$)
            (< tmp%%$ 4)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 4)
              ) (Poly%array%. words!)
             ) i2$
            )
           ) 0
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 4)
           ) (Poly%array%. words!)
          ) i2$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_byte_to_word_step_45
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_byte_to_word_step_45
     )))
     (=>
      %%global_location_label%%30
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 4)
          ) (Poly%array%. words!)
         ) (I i!)
        )
       ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
          8
         ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%3 (Mul i! 8)
            $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
              bytes!
         )))))
        ) (I j!)
     )))
     (=>
      %%global_location_label%%31
      (forall ((i2$ Poly)) (!
        (=>
         (has_type i2$ INT)
         (=>
          (let
           ((tmp%%$ (%I i2$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ i!)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 4)
              ) (Poly%array%. words!)
             ) i2$
            )
           ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
              8
             ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%3 (Mul (%I i2$)
                 8
                ) $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
                  bytes!
             )))))
            ) (I 8)
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 4)
           ) (Poly%array%. words!)
          ) i2$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_byte_to_word_step_46
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_byte_to_word_step_46
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step.
     bytes! words! i! j!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step.
 (%%Function%% %%Function%% Int Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (words! %%Function%%) (i! Int) (j! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step.
     bytes! words! i! j!
    ) (and
     (< (uClip 64 (bitor (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
             $ (UINT 64) $ (CONST_INT 4)
            ) (Poly%array%. words!)
           ) (I i!)
         ))
        ) (I (uClip 64 (bitshl (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
               ) (I (Add (Mul i! 8) j!))
            )))
           ) (I (Mul j! 8))
       ))))
      ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (nClip (Add j! 1)) 8))))
     )
     (= (uClip 64 (bitor (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
             $ (UINT 64) $ (CONST_INT 4)
            ) (Poly%array%. words!)
           ) (I i!)
         ))
        ) (I (uClip 64 (bitshl (I (uClip 64 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
               ) (I (Add (Mul i! 8) j!))
            )))
           ) (I (Mul j! 8))
       ))))
      ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
         8
        ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%3 (nClip (Mul
             i! 8
            )
           ) $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
             bytes!
        )))))
       ) (I (nClip (Add j! 1)))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step.
     bytes! words! i! j!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::mul_lemmas::lemma_mul_commutative_8_terms
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_commutative_8_terms.
 (Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int) Bool
)
(assert
 (forall ((a0! Int) (b0! Int) (a1! Int) (b1! Int) (a2! Int) (b2! Int) (a3! Int) (b3!
    Int
   ) (a4! Int) (b4! Int) (a5! Int) (b5! Int) (a6! Int) (b6! Int) (a7! Int) (b7! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_commutative_8_terms.
     a0! b0! a1! b1! a2! b2! a3! b3! a4! b4! a5! b5! a6! b6! a7! b7!
    ) (= (Add (Add (Add (Add (Add (Add (Add (Mul a0! b0!) (Mul a1! b1!)) (Mul a2! b2!)) (Mul
           a3! b3!
          )
         ) (Mul a4! b4!)
        ) (Mul a5! b5!)
       ) (Mul a6! b6!)
      ) (Mul a7! b7!)
     ) (Add (Add (Add (Add (Add (Add (Add (Mul b0! a0!) (Mul b1! a1!)) (Mul b2! a2!)) (Mul b3!
           a3!
          )
         ) (Mul b4! a4!)
        ) (Mul b5! a5!)
       ) (Mul b6! a6!)
      ) (Mul b7! a7!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_commutative_8_terms.
     a0! b0! a1! b1! a2! b2! a3! b3! a4! b4! a5! b5! a6! b6! a7! b7!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_commutative_8_terms._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_commutative_8_terms._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_distributivity_over_word
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
 (Int Int Int Int Int Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%32 Bool)
(assert
 (forall ((word! Int) (byte0! Int) (byte1! Int) (byte2! Int) (byte3! Int) (byte4! Int)
   (byte5! Int) (byte6! Int) (byte7! Int) (exp! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
     word! byte0! byte1! byte2! byte3! byte4! byte5! byte6! byte7! exp!
    ) (=>
     %%global_location_label%%32
     (= word! (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip
                     (Mul byte0! (vstd!arithmetic.power2.pow2.? (I 0)))
                    ) (nClip (Mul byte1! (vstd!arithmetic.power2.pow2.? (I 8))))
                   )
                  ) (nClip (Mul byte2! (vstd!arithmetic.power2.pow2.? (I 16))))
                 )
                ) (nClip (Mul byte3! (vstd!arithmetic.power2.pow2.? (I 24))))
               )
              ) (nClip (Mul byte4! (vstd!arithmetic.power2.pow2.? (I 32))))
             )
            ) (nClip (Mul byte5! (vstd!arithmetic.power2.pow2.? (I 40))))
           )
          ) (nClip (Mul byte6! (vstd!arithmetic.power2.pow2.? (I 48))))
         )
        ) (nClip (Mul byte7! (vstd!arithmetic.power2.pow2.? (I 56))))
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
     word! byte0! byte1! byte2! byte3! byte4! byte5! byte6! byte7! exp!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
 (Int Int Int Int Int Int Int Int Int Int) Bool
)
(assert
 (forall ((word! Int) (byte0! Int) (byte1! Int) (byte2! Int) (byte3! Int) (byte4! Int)
   (byte5! Int) (byte6! Int) (byte7! Int) (exp! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
     word! byte0! byte1! byte2! byte3! byte4! byte5! byte6! byte7! exp!
    ) (= (nClip (Mul word! (vstd!arithmetic.power2.pow2.? (I exp!)))) (nClip (Add (nClip
        (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Mul byte0! (vstd!arithmetic.power2.pow2.?
                      (I exp!)
                    ))
                   ) (nClip (Mul byte1! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 8))))))
                  )
                 ) (nClip (Mul byte2! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 16))))))
                )
               ) (nClip (Mul byte3! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 24))))))
              )
             ) (nClip (Mul byte4! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 32))))))
            )
           ) (nClip (Mul byte5! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 40))))))
          )
         ) (nClip (Mul byte6! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 48))))))
        )
       ) (nClip (Mul byte7! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 56))))))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
     word! byte0! byte1! byte2! byte3! byte4! byte5! byte6! byte7! exp!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_byte_lemmas::bytes_to_scalar_lemmas::lemma_bytes_to_word_equivalence
(declare-fun req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence.
 (%%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%33 Bool)
(assert
 (forall ((bytes! %%Function%%) (words! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence.
     bytes! words!
    ) (=>
     %%global_location_label%%33
     (forall ((i2$ Poly)) (!
       (=>
        (has_type i2$ INT)
        (=>
         (let
          ((tmp%%$ (%I i2$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 4)
         ))
         (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 4)
             ) (Poly%array%. words!)
            ) i2$
           )
          ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
             8
            ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%3 (Mul (%I i2$)
                8
               ) $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
                 bytes!
            )))))
           ) (I 8)
       ))))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 4)
          ) (Poly%array%. words!)
         ) i2$
       ))
       :qid user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_bytes_to_word_equivalence_68
       :skolemid skolem_user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_bytes_to_word_equivalence_68
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence.
     bytes! words!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence.
 (%%Function%% %%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%) (words! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence.
     bytes! words!
    ) (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (curve25519_dalek!specs.core_specs.words_as_nat_u64.?
      (vstd!array.spec_array_as_slice.? $ (UINT 64) $ (CONST_INT 4) (Poly%array%. words!))
      (I 4) (I 64)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence.
     bytes! words!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence._definition
)))

;; Function-Def curve25519_dalek::lemmas::scalar_byte_lemmas::bytes_to_scalar_lemmas::lemma_bytes_to_word_equivalence
;; curve25519-dalek/src/lemmas/scalar_byte_lemmas/bytes_to_scalar_lemmas.rs:224:1: 224:80 (#0)
(get-info :all-statistics)
(push)
 (declare-const bytes! %%Function%%)
 (declare-const words! %%Function%%)
 (declare-const tmp%1 Int)
 (declare-const tmp%2 Int)
 (declare-const tmp%3 Int)
 (declare-const tmp%4 Int)
 (declare-const tmp%5 Int)
 (declare-const tmp%6 Int)
 (declare-const tmp%7 Int)
 (declare-const tmp%8 Int)
 (declare-const tmp%9 Int)
 (declare-const tmp%10 Int)
 (declare-const tmp%11 Int)
 (declare-const tmp%12 Int)
 (declare-const tmp%13 Int)
 (declare-const tmp%14 Int)
 (declare-const tmp%15 Int)
 (declare-const tmp%16 Int)
 (declare-const tmp%17 Int)
 (declare-const tmp%18 Int)
 (declare-const tmp%19 Int)
 (declare-const tmp%20 Int)
 (declare-const tmp%21 Int)
 (declare-const tmp%22 Int)
 (declare-const tmp%23 Int)
 (declare-const tmp%24 Int)
 (declare-const tmp%25 Int)
 (declare-const tmp%26 Int)
 (declare-const tmp%27 Int)
 (declare-const tmp%28 Int)
 (declare-const tmp%29 Int)
 (declare-const tmp%30 Int)
 (declare-const tmp%31 Int)
 (declare-const tmp%32 Int)
 (declare-const tmp%33 Int)
 (declare-const tmp%34 Int)
 (declare-const tmp%35 Int)
 (declare-const tmp%36 Int)
 (declare-const tmp%37 Int)
 (declare-const tmp%38 Int)
 (declare-const tmp%39 Int)
 (declare-const tmp%40 Int)
 (declare-const tmp%41 Int)
 (declare-const tmp%42 Int)
 (declare-const tmp%43 Int)
 (declare-const tmp%44 Int)
 (declare-const tmp%45 Int)
 (declare-const tmp%46 Int)
 (declare-const tmp%47 Int)
 (declare-const tmp%48 Int)
 (declare-const tmp%49 Int)
 (declare-const tmp%50 Int)
 (declare-const tmp%51 Int)
 (declare-const tmp%52 Int)
 (declare-const tmp%53 Int)
 (declare-const tmp%54 Int)
 (declare-const tmp%55 Int)
 (declare-const tmp%56 Int)
 (declare-const tmp%57 Int)
 (declare-const tmp%58 Int)
 (declare-const tmp%59 Int)
 (declare-const tmp%60 Int)
 (declare-const tmp%61 Int)
 (declare-const tmp%62 Int)
 (declare-const tmp%63 Int)
 (declare-const tmp%64 Int)
 (declare-const tmp%65 Int)
 (declare-const tmp%66 Int)
 (declare-const tmp%67 Int)
 (declare-const tmp%68 Int)
 (declare-const tmp%69 Int)
 (declare-const tmp%70 Int)
 (declare-const tmp%71 Int)
 (declare-const tmp%72 Int)
 (declare-const tmp%73 Int)
 (declare-const tmp%74 Int)
 (declare-const tmp%75 Int)
 (declare-const tmp%76 Int)
 (declare-const tmp%77 Int)
 (declare-const tmp%78 Int)
 (declare-const tmp%79 Int)
 (declare-const tmp%80 Int)
 (declare-const tmp%81 Int)
 (declare-const tmp%82 Int)
 (declare-const tmp%83 Int)
 (declare-const tmp%84 Int)
 (declare-const tmp%85 Int)
 (declare-const tmp%86 Int)
 (declare-const tmp%87 Int)
 (declare-const tmp%88 Int)
 (declare-const tmp%89 Int)
 (declare-const tmp%90 Int)
 (declare-const tmp%91 Int)
 (declare-const tmp%92 Int)
 (declare-const tmp%93 Int)
 (declare-const tmp%94 Int)
 (declare-const tmp%95 Int)
 (declare-const tmp%96 Int)
 (declare-const tmp%97 Int)
 (declare-const tmp%98 Int)
 (declare-const tmp%99 Int)
 (declare-const tmp%100 Int)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%array%. bytes!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
 )
 (assert
  (has_type (Poly%array%. words!) (ARRAY $ (UINT 64) $ (CONST_INT 4)))
 )
 (assert
  (forall ((i2$ Poly)) (!
    (=>
     (has_type i2$ INT)
     (=>
      (let
       ((tmp%%$ (%I i2$)))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 4)
      ))
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 4)
          ) (Poly%array%. words!)
         ) i2$
        )
       ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
          8
         ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%3 (Mul (%I i2$)
             8
            ) $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
              bytes!
         )))))
        ) (I 8)
    ))))
    :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
        $ (CONST_INT 4)
       ) (Poly%array%. words!)
      ) i2$
    ))
    :qid user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_bytes_to_word_equivalence_73
    :skolemid skolem_user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_bytes_to_word_equivalence_73
 )))
 ;; assertion failed
 (declare-const %%location_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%1 Bool)
 ;; assertion failed
 (declare-const %%location_label%%2 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%3 Bool)
 ;; assertion failed
 (declare-const %%location_label%%4 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%5 Bool)
 ;; assertion failed
 (declare-const %%location_label%%6 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%7 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%8 Bool)
 (assert
  (not (and
    (=>
     (fuel_bool fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
     (=>
      (exists ((fuel% Fuel)) (= fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.
        (succ (succ (succ (succ (succ (succ (succ (succ fuel%))))))))
      ))
      (=>
       (= tmp%1 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 32)
           ) (Poly%array%. bytes!)
          ) (I 0)
       )))
       (=>
        (= tmp%2 (vstd!arithmetic.power2.pow2.? (I 0)))
        (=>
         (= tmp%3 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
              $ (CONST_INT 32)
             ) (Poly%array%. bytes!)
            ) (I 1)
         )))
         (=>
          (= tmp%4 (vstd!arithmetic.power2.pow2.? (I 8)))
          (=>
           (= tmp%5 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                $ (CONST_INT 32)
               ) (Poly%array%. bytes!)
              ) (I 2)
           )))
           (=>
            (= tmp%6 (vstd!arithmetic.power2.pow2.? (I 16)))
            (=>
             (= tmp%7 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                  $ (CONST_INT 32)
                 ) (Poly%array%. bytes!)
                ) (I 3)
             )))
             (=>
              (= tmp%8 (vstd!arithmetic.power2.pow2.? (I 24)))
              (=>
               (= tmp%9 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                    $ (CONST_INT 32)
                   ) (Poly%array%. bytes!)
                  ) (I 4)
               )))
               (=>
                (= tmp%10 (vstd!arithmetic.power2.pow2.? (I 32)))
                (=>
                 (= tmp%11 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                       8
                      ) $ (CONST_INT 32)
                     ) (Poly%array%. bytes!)
                    ) (I 5)
                 )))
                 (=>
                  (= tmp%12 (vstd!arithmetic.power2.pow2.? (I 40)))
                  (=>
                   (= tmp%13 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                         8
                        ) $ (CONST_INT 32)
                       ) (Poly%array%. bytes!)
                      ) (I 6)
                   )))
                   (=>
                    (= tmp%14 (vstd!arithmetic.power2.pow2.? (I 48)))
                    (=>
                     (= tmp%15 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                           8
                          ) $ (CONST_INT 32)
                         ) (Poly%array%. bytes!)
                        ) (I 7)
                     )))
                     (=>
                      (= tmp%16 (vstd!arithmetic.power2.pow2.? (I 56)))
                      (=>
                       (ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_commutative_8_terms.
                        tmp%1 tmp%2 tmp%3 tmp%4 tmp%5 tmp%6 tmp%7 tmp%8 tmp%9 tmp%10 tmp%11 tmp%12 tmp%13
                        tmp%14 tmp%15 tmp%16
                       )
                       (=>
                        %%location_label%%0
                        (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                             (CONST_INT 4)
                            ) (Poly%array%. words!)
                           ) (I 0)
                          )
                         ) (Add (Add (Add (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                                    $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
                                   ) (I 0)
                                  )
                                 ) (vstd!arithmetic.power2.pow2.? (I 0))
                                ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                     $ (CONST_INT 32)
                                    ) (Poly%array%. bytes!)
                                   ) (I 1)
                                  )
                                 ) (vstd!arithmetic.power2.pow2.? (I 8))
                                )
                               ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                    $ (CONST_INT 32)
                                   ) (Poly%array%. bytes!)
                                  ) (I 2)
                                 )
                                ) (vstd!arithmetic.power2.pow2.? (I 16))
                               )
                              ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                   $ (CONST_INT 32)
                                  ) (Poly%array%. bytes!)
                                 ) (I 3)
                                )
                               ) (vstd!arithmetic.power2.pow2.? (I 24))
                              )
                             ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                  $ (CONST_INT 32)
                                 ) (Poly%array%. bytes!)
                                ) (I 4)
                               )
                              ) (vstd!arithmetic.power2.pow2.? (I 32))
                             )
                            ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                 $ (CONST_INT 32)
                                ) (Poly%array%. bytes!)
                               ) (I 5)
                              )
                             ) (vstd!arithmetic.power2.pow2.? (I 40))
                            )
                           ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                $ (CONST_INT 32)
                               ) (Poly%array%. bytes!)
                              ) (I 6)
                             )
                            ) (vstd!arithmetic.power2.pow2.? (I 48))
                           )
                          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                               $ (CONST_INT 32)
                              ) (Poly%array%. bytes!)
                             ) (I 7)
                            )
                           ) (vstd!arithmetic.power2.pow2.? (I 56))
    )))))))))))))))))))))))
    (=>
     (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 4)
         ) (Poly%array%. words!)
        ) (I 0)
       )
      ) (Add (Add (Add (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                 $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
                ) (I 0)
               )
              ) (vstd!arithmetic.power2.pow2.? (I 0))
             ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                  $ (CONST_INT 32)
                 ) (Poly%array%. bytes!)
                ) (I 1)
               )
              ) (vstd!arithmetic.power2.pow2.? (I 8))
             )
            ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                 $ (CONST_INT 32)
                ) (Poly%array%. bytes!)
               ) (I 2)
              )
             ) (vstd!arithmetic.power2.pow2.? (I 16))
            )
           ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                $ (CONST_INT 32)
               ) (Poly%array%. bytes!)
              ) (I 3)
             )
            ) (vstd!arithmetic.power2.pow2.? (I 24))
           )
          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
               $ (CONST_INT 32)
              ) (Poly%array%. bytes!)
             ) (I 4)
            )
           ) (vstd!arithmetic.power2.pow2.? (I 32))
          )
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
              $ (CONST_INT 32)
             ) (Poly%array%. bytes!)
            ) (I 5)
           )
          ) (vstd!arithmetic.power2.pow2.? (I 40))
         )
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
             $ (CONST_INT 32)
            ) (Poly%array%. bytes!)
           ) (I 6)
          )
         ) (vstd!arithmetic.power2.pow2.? (I 48))
        )
       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
            $ (CONST_INT 32)
           ) (Poly%array%. bytes!)
          ) (I 7)
         )
        ) (vstd!arithmetic.power2.pow2.? (I 56))
     )))
     (=>
      (= tmp%17 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
            64
           ) $ (CONST_INT 4)
          ) (Poly%array%. words!)
         ) (I 0)
      )))
      (=>
       (= tmp%18 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
             8
            ) $ (CONST_INT 32)
           ) (Poly%array%. bytes!)
          ) (I 0)
       )))
       (=>
        (= tmp%19 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
              8
             ) $ (CONST_INT 32)
            ) (Poly%array%. bytes!)
           ) (I 1)
        )))
        (=>
         (= tmp%20 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
               8
              ) $ (CONST_INT 32)
             ) (Poly%array%. bytes!)
            ) (I 2)
         )))
         (=>
          (= tmp%21 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                8
               ) $ (CONST_INT 32)
              ) (Poly%array%. bytes!)
             ) (I 3)
          )))
          (=>
           (= tmp%22 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                 8
                ) $ (CONST_INT 32)
               ) (Poly%array%. bytes!)
              ) (I 4)
           )))
           (=>
            (= tmp%23 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                  8
                 ) $ (CONST_INT 32)
                ) (Poly%array%. bytes!)
               ) (I 5)
            )))
            (=>
             (= tmp%24 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                   8
                  ) $ (CONST_INT 32)
                 ) (Poly%array%. bytes!)
                ) (I 6)
             )))
             (=>
              (= tmp%25 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                    8
                   ) $ (CONST_INT 32)
                  ) (Poly%array%. bytes!)
                 ) (I 7)
              )))
              (and
               (=>
                %%location_label%%1
                (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
                 tmp%17 tmp%18 tmp%19 tmp%20 tmp%21 tmp%22 tmp%23 tmp%24 tmp%25 0
               ))
               (=>
                (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
                 tmp%17 tmp%18 tmp%19 tmp%20 tmp%21 tmp%22 tmp%23 tmp%24 tmp%25 0
                )
                (and
                 (=>
                  (fuel_bool fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
                  (=>
                   (exists ((fuel% Fuel)) (= fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.
                     (succ (succ (succ (succ (succ (succ (succ (succ fuel%))))))))
                   ))
                   (=>
                    (= tmp%26 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                          8
                         ) $ (CONST_INT 32)
                        ) (Poly%array%. bytes!)
                       ) (I 8)
                    )))
                    (=>
                     (= tmp%27 (vstd!arithmetic.power2.pow2.? (I 0)))
                     (=>
                      (= tmp%28 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                            8
                           ) $ (CONST_INT 32)
                          ) (Poly%array%. bytes!)
                         ) (I 9)
                      )))
                      (=>
                       (= tmp%29 (vstd!arithmetic.power2.pow2.? (I 8)))
                       (=>
                        (= tmp%30 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                              8
                             ) $ (CONST_INT 32)
                            ) (Poly%array%. bytes!)
                           ) (I 10)
                        )))
                        (=>
                         (= tmp%31 (vstd!arithmetic.power2.pow2.? (I 16)))
                         (=>
                          (= tmp%32 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                8
                               ) $ (CONST_INT 32)
                              ) (Poly%array%. bytes!)
                             ) (I 11)
                          )))
                          (=>
                           (= tmp%33 (vstd!arithmetic.power2.pow2.? (I 24)))
                           (=>
                            (= tmp%34 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                  8
                                 ) $ (CONST_INT 32)
                                ) (Poly%array%. bytes!)
                               ) (I 12)
                            )))
                            (=>
                             (= tmp%35 (vstd!arithmetic.power2.pow2.? (I 32)))
                             (=>
                              (= tmp%36 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                    8
                                   ) $ (CONST_INT 32)
                                  ) (Poly%array%. bytes!)
                                 ) (I 13)
                              )))
                              (=>
                               (= tmp%37 (vstd!arithmetic.power2.pow2.? (I 40)))
                               (=>
                                (= tmp%38 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                      8
                                     ) $ (CONST_INT 32)
                                    ) (Poly%array%. bytes!)
                                   ) (I 14)
                                )))
                                (=>
                                 (= tmp%39 (vstd!arithmetic.power2.pow2.? (I 48)))
                                 (=>
                                  (= tmp%40 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                        8
                                       ) $ (CONST_INT 32)
                                      ) (Poly%array%. bytes!)
                                     ) (I 15)
                                  )))
                                  (=>
                                   (= tmp%41 (vstd!arithmetic.power2.pow2.? (I 56)))
                                   (=>
                                    (ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_commutative_8_terms.
                                     tmp%26 tmp%27 tmp%28 tmp%29 tmp%30 tmp%31 tmp%32 tmp%33 tmp%34 tmp%35 tmp%36 tmp%37
                                     tmp%38 tmp%39 tmp%40 tmp%41
                                    )
                                    (=>
                                     %%location_label%%2
                                     (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                                          (CONST_INT 4)
                                         ) (Poly%array%. words!)
                                        ) (I 1)
                                       )
                                      ) (Add (Add (Add (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                                                 $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
                                                ) (I 8)
                                               )
                                              ) (vstd!arithmetic.power2.pow2.? (I 0))
                                             ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                  $ (CONST_INT 32)
                                                 ) (Poly%array%. bytes!)
                                                ) (I 9)
                                               )
                                              ) (vstd!arithmetic.power2.pow2.? (I 8))
                                             )
                                            ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                 $ (CONST_INT 32)
                                                ) (Poly%array%. bytes!)
                                               ) (I 10)
                                              )
                                             ) (vstd!arithmetic.power2.pow2.? (I 16))
                                            )
                                           ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                $ (CONST_INT 32)
                                               ) (Poly%array%. bytes!)
                                              ) (I 11)
                                             )
                                            ) (vstd!arithmetic.power2.pow2.? (I 24))
                                           )
                                          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                               $ (CONST_INT 32)
                                              ) (Poly%array%. bytes!)
                                             ) (I 12)
                                            )
                                           ) (vstd!arithmetic.power2.pow2.? (I 32))
                                          )
                                         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                              $ (CONST_INT 32)
                                             ) (Poly%array%. bytes!)
                                            ) (I 13)
                                           )
                                          ) (vstd!arithmetic.power2.pow2.? (I 40))
                                         )
                                        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                             $ (CONST_INT 32)
                                            ) (Poly%array%. bytes!)
                                           ) (I 14)
                                          )
                                         ) (vstd!arithmetic.power2.pow2.? (I 48))
                                        )
                                       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                            $ (CONST_INT 32)
                                           ) (Poly%array%. bytes!)
                                          ) (I 15)
                                         )
                                        ) (vstd!arithmetic.power2.pow2.? (I 56))
                 )))))))))))))))))))))))
                 (=>
                  (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                       (CONST_INT 4)
                      ) (Poly%array%. words!)
                     ) (I 1)
                    )
                   ) (Add (Add (Add (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                              $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
                             ) (I 8)
                            )
                           ) (vstd!arithmetic.power2.pow2.? (I 0))
                          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                               $ (CONST_INT 32)
                              ) (Poly%array%. bytes!)
                             ) (I 9)
                            )
                           ) (vstd!arithmetic.power2.pow2.? (I 8))
                          )
                         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                              $ (CONST_INT 32)
                             ) (Poly%array%. bytes!)
                            ) (I 10)
                           )
                          ) (vstd!arithmetic.power2.pow2.? (I 16))
                         )
                        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                             $ (CONST_INT 32)
                            ) (Poly%array%. bytes!)
                           ) (I 11)
                          )
                         ) (vstd!arithmetic.power2.pow2.? (I 24))
                        )
                       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                            $ (CONST_INT 32)
                           ) (Poly%array%. bytes!)
                          ) (I 12)
                         )
                        ) (vstd!arithmetic.power2.pow2.? (I 32))
                       )
                      ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                           $ (CONST_INT 32)
                          ) (Poly%array%. bytes!)
                         ) (I 13)
                        )
                       ) (vstd!arithmetic.power2.pow2.? (I 40))
                      )
                     ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                          $ (CONST_INT 32)
                         ) (Poly%array%. bytes!)
                        ) (I 14)
                       )
                      ) (vstd!arithmetic.power2.pow2.? (I 48))
                     )
                    ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                         $ (CONST_INT 32)
                        ) (Poly%array%. bytes!)
                       ) (I 15)
                      )
                     ) (vstd!arithmetic.power2.pow2.? (I 56))
                  )))
                  (=>
                   (= tmp%42 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                         64
                        ) $ (CONST_INT 4)
                       ) (Poly%array%. words!)
                      ) (I 1)
                   )))
                   (=>
                    (= tmp%43 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                          8
                         ) $ (CONST_INT 32)
                        ) (Poly%array%. bytes!)
                       ) (I 8)
                    )))
                    (=>
                     (= tmp%44 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                           8
                          ) $ (CONST_INT 32)
                         ) (Poly%array%. bytes!)
                        ) (I 9)
                     )))
                     (=>
                      (= tmp%45 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                            8
                           ) $ (CONST_INT 32)
                          ) (Poly%array%. bytes!)
                         ) (I 10)
                      )))
                      (=>
                       (= tmp%46 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                             8
                            ) $ (CONST_INT 32)
                           ) (Poly%array%. bytes!)
                          ) (I 11)
                       )))
                       (=>
                        (= tmp%47 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                              8
                             ) $ (CONST_INT 32)
                            ) (Poly%array%. bytes!)
                           ) (I 12)
                        )))
                        (=>
                         (= tmp%48 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                               8
                              ) $ (CONST_INT 32)
                             ) (Poly%array%. bytes!)
                            ) (I 13)
                         )))
                         (=>
                          (= tmp%49 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                8
                               ) $ (CONST_INT 32)
                              ) (Poly%array%. bytes!)
                             ) (I 14)
                          )))
                          (=>
                           (= tmp%50 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                 8
                                ) $ (CONST_INT 32)
                               ) (Poly%array%. bytes!)
                              ) (I 15)
                           )))
                           (and
                            (=>
                             %%location_label%%3
                             (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
                              tmp%42 tmp%43 tmp%44 tmp%45 tmp%46 tmp%47 tmp%48 tmp%49 tmp%50 64
                            ))
                            (=>
                             (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
                              tmp%42 tmp%43 tmp%44 tmp%45 tmp%46 tmp%47 tmp%48 tmp%49 tmp%50 64
                             )
                             (and
                              (=>
                               (fuel_bool fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
                               (=>
                                (exists ((fuel% Fuel)) (= fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.
                                  (succ (succ (succ (succ (succ (succ (succ (succ fuel%))))))))
                                ))
                                (=>
                                 (= tmp%51 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                       8
                                      ) $ (CONST_INT 32)
                                     ) (Poly%array%. bytes!)
                                    ) (I 16)
                                 )))
                                 (=>
                                  (= tmp%52 (vstd!arithmetic.power2.pow2.? (I 0)))
                                  (=>
                                   (= tmp%53 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                         8
                                        ) $ (CONST_INT 32)
                                       ) (Poly%array%. bytes!)
                                      ) (I 17)
                                   )))
                                   (=>
                                    (= tmp%54 (vstd!arithmetic.power2.pow2.? (I 8)))
                                    (=>
                                     (= tmp%55 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                           8
                                          ) $ (CONST_INT 32)
                                         ) (Poly%array%. bytes!)
                                        ) (I 18)
                                     )))
                                     (=>
                                      (= tmp%56 (vstd!arithmetic.power2.pow2.? (I 16)))
                                      (=>
                                       (= tmp%57 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                             8
                                            ) $ (CONST_INT 32)
                                           ) (Poly%array%. bytes!)
                                          ) (I 19)
                                       )))
                                       (=>
                                        (= tmp%58 (vstd!arithmetic.power2.pow2.? (I 24)))
                                        (=>
                                         (= tmp%59 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                               8
                                              ) $ (CONST_INT 32)
                                             ) (Poly%array%. bytes!)
                                            ) (I 20)
                                         )))
                                         (=>
                                          (= tmp%60 (vstd!arithmetic.power2.pow2.? (I 32)))
                                          (=>
                                           (= tmp%61 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                 8
                                                ) $ (CONST_INT 32)
                                               ) (Poly%array%. bytes!)
                                              ) (I 21)
                                           )))
                                           (=>
                                            (= tmp%62 (vstd!arithmetic.power2.pow2.? (I 40)))
                                            (=>
                                             (= tmp%63 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                   8
                                                  ) $ (CONST_INT 32)
                                                 ) (Poly%array%. bytes!)
                                                ) (I 22)
                                             )))
                                             (=>
                                              (= tmp%64 (vstd!arithmetic.power2.pow2.? (I 48)))
                                              (=>
                                               (= tmp%65 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                     8
                                                    ) $ (CONST_INT 32)
                                                   ) (Poly%array%. bytes!)
                                                  ) (I 23)
                                               )))
                                               (=>
                                                (= tmp%66 (vstd!arithmetic.power2.pow2.? (I 56)))
                                                (=>
                                                 (ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_commutative_8_terms.
                                                  tmp%51 tmp%52 tmp%53 tmp%54 tmp%55 tmp%56 tmp%57 tmp%58 tmp%59 tmp%60 tmp%61 tmp%62
                                                  tmp%63 tmp%64 tmp%65 tmp%66
                                                 )
                                                 (=>
                                                  %%location_label%%4
                                                  (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                                                       (CONST_INT 4)
                                                      ) (Poly%array%. words!)
                                                     ) (I 2)
                                                    )
                                                   ) (Add (Add (Add (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                                                              $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
                                                             ) (I 16)
                                                            )
                                                           ) (vstd!arithmetic.power2.pow2.? (I 0))
                                                          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                               $ (CONST_INT 32)
                                                              ) (Poly%array%. bytes!)
                                                             ) (I 17)
                                                            )
                                                           ) (vstd!arithmetic.power2.pow2.? (I 8))
                                                          )
                                                         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                              $ (CONST_INT 32)
                                                             ) (Poly%array%. bytes!)
                                                            ) (I 18)
                                                           )
                                                          ) (vstd!arithmetic.power2.pow2.? (I 16))
                                                         )
                                                        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                             $ (CONST_INT 32)
                                                            ) (Poly%array%. bytes!)
                                                           ) (I 19)
                                                          )
                                                         ) (vstd!arithmetic.power2.pow2.? (I 24))
                                                        )
                                                       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                            $ (CONST_INT 32)
                                                           ) (Poly%array%. bytes!)
                                                          ) (I 20)
                                                         )
                                                        ) (vstd!arithmetic.power2.pow2.? (I 32))
                                                       )
                                                      ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                           $ (CONST_INT 32)
                                                          ) (Poly%array%. bytes!)
                                                         ) (I 21)
                                                        )
                                                       ) (vstd!arithmetic.power2.pow2.? (I 40))
                                                      )
                                                     ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                          $ (CONST_INT 32)
                                                         ) (Poly%array%. bytes!)
                                                        ) (I 22)
                                                       )
                                                      ) (vstd!arithmetic.power2.pow2.? (I 48))
                                                     )
                                                    ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                         $ (CONST_INT 32)
                                                        ) (Poly%array%. bytes!)
                                                       ) (I 23)
                                                      )
                                                     ) (vstd!arithmetic.power2.pow2.? (I 56))
                              )))))))))))))))))))))))
                              (=>
                               (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                                    (CONST_INT 4)
                                   ) (Poly%array%. words!)
                                  ) (I 2)
                                 )
                                ) (Add (Add (Add (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                                           $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
                                          ) (I 16)
                                         )
                                        ) (vstd!arithmetic.power2.pow2.? (I 0))
                                       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                            $ (CONST_INT 32)
                                           ) (Poly%array%. bytes!)
                                          ) (I 17)
                                         )
                                        ) (vstd!arithmetic.power2.pow2.? (I 8))
                                       )
                                      ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                           $ (CONST_INT 32)
                                          ) (Poly%array%. bytes!)
                                         ) (I 18)
                                        )
                                       ) (vstd!arithmetic.power2.pow2.? (I 16))
                                      )
                                     ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                          $ (CONST_INT 32)
                                         ) (Poly%array%. bytes!)
                                        ) (I 19)
                                       )
                                      ) (vstd!arithmetic.power2.pow2.? (I 24))
                                     )
                                    ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                         $ (CONST_INT 32)
                                        ) (Poly%array%. bytes!)
                                       ) (I 20)
                                      )
                                     ) (vstd!arithmetic.power2.pow2.? (I 32))
                                    )
                                   ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                        $ (CONST_INT 32)
                                       ) (Poly%array%. bytes!)
                                      ) (I 21)
                                     )
                                    ) (vstd!arithmetic.power2.pow2.? (I 40))
                                   )
                                  ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                       $ (CONST_INT 32)
                                      ) (Poly%array%. bytes!)
                                     ) (I 22)
                                    )
                                   ) (vstd!arithmetic.power2.pow2.? (I 48))
                                  )
                                 ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                      $ (CONST_INT 32)
                                     ) (Poly%array%. bytes!)
                                    ) (I 23)
                                   )
                                  ) (vstd!arithmetic.power2.pow2.? (I 56))
                               )))
                               (=>
                                (= tmp%67 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                      64
                                     ) $ (CONST_INT 4)
                                    ) (Poly%array%. words!)
                                   ) (I 2)
                                )))
                                (=>
                                 (= tmp%68 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                       8
                                      ) $ (CONST_INT 32)
                                     ) (Poly%array%. bytes!)
                                    ) (I 16)
                                 )))
                                 (=>
                                  (= tmp%69 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                        8
                                       ) $ (CONST_INT 32)
                                      ) (Poly%array%. bytes!)
                                     ) (I 17)
                                  )))
                                  (=>
                                   (= tmp%70 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                         8
                                        ) $ (CONST_INT 32)
                                       ) (Poly%array%. bytes!)
                                      ) (I 18)
                                   )))
                                   (=>
                                    (= tmp%71 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                          8
                                         ) $ (CONST_INT 32)
                                        ) (Poly%array%. bytes!)
                                       ) (I 19)
                                    )))
                                    (=>
                                     (= tmp%72 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                           8
                                          ) $ (CONST_INT 32)
                                         ) (Poly%array%. bytes!)
                                        ) (I 20)
                                     )))
                                     (=>
                                      (= tmp%73 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                            8
                                           ) $ (CONST_INT 32)
                                          ) (Poly%array%. bytes!)
                                         ) (I 21)
                                      )))
                                      (=>
                                       (= tmp%74 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                             8
                                            ) $ (CONST_INT 32)
                                           ) (Poly%array%. bytes!)
                                          ) (I 22)
                                       )))
                                       (=>
                                        (= tmp%75 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                              8
                                             ) $ (CONST_INT 32)
                                            ) (Poly%array%. bytes!)
                                           ) (I 23)
                                        )))
                                        (and
                                         (=>
                                          %%location_label%%5
                                          (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
                                           tmp%67 tmp%68 tmp%69 tmp%70 tmp%71 tmp%72 tmp%73 tmp%74 tmp%75 128
                                         ))
                                         (=>
                                          (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
                                           tmp%67 tmp%68 tmp%69 tmp%70 tmp%71 tmp%72 tmp%73 tmp%74 tmp%75 128
                                          )
                                          (and
                                           (=>
                                            (fuel_bool fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.)
                                            (=>
                                             (exists ((fuel% Fuel)) (= fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.
                                               (succ (succ (succ (succ (succ (succ (succ (succ (succ fuel%)))))))))
                                             ))
                                             (=>
                                              (= tmp%76 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                    8
                                                   ) $ (CONST_INT 32)
                                                  ) (Poly%array%. bytes!)
                                                 ) (I 24)
                                              )))
                                              (=>
                                               (= tmp%77 (vstd!arithmetic.power2.pow2.? (I 0)))
                                               (=>
                                                (= tmp%78 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                      8
                                                     ) $ (CONST_INT 32)
                                                    ) (Poly%array%. bytes!)
                                                   ) (I 25)
                                                )))
                                                (=>
                                                 (= tmp%79 (vstd!arithmetic.power2.pow2.? (I 8)))
                                                 (=>
                                                  (= tmp%80 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                        8
                                                       ) $ (CONST_INT 32)
                                                      ) (Poly%array%. bytes!)
                                                     ) (I 26)
                                                  )))
                                                  (=>
                                                   (= tmp%81 (vstd!arithmetic.power2.pow2.? (I 16)))
                                                   (=>
                                                    (= tmp%82 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                          8
                                                         ) $ (CONST_INT 32)
                                                        ) (Poly%array%. bytes!)
                                                       ) (I 27)
                                                    )))
                                                    (=>
                                                     (= tmp%83 (vstd!arithmetic.power2.pow2.? (I 24)))
                                                     (=>
                                                      (= tmp%84 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                            8
                                                           ) $ (CONST_INT 32)
                                                          ) (Poly%array%. bytes!)
                                                         ) (I 28)
                                                      )))
                                                      (=>
                                                       (= tmp%85 (vstd!arithmetic.power2.pow2.? (I 32)))
                                                       (=>
                                                        (= tmp%86 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                              8
                                                             ) $ (CONST_INT 32)
                                                            ) (Poly%array%. bytes!)
                                                           ) (I 29)
                                                        )))
                                                        (=>
                                                         (= tmp%87 (vstd!arithmetic.power2.pow2.? (I 40)))
                                                         (=>
                                                          (= tmp%88 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                8
                                                               ) $ (CONST_INT 32)
                                                              ) (Poly%array%. bytes!)
                                                             ) (I 30)
                                                          )))
                                                          (=>
                                                           (= tmp%89 (vstd!arithmetic.power2.pow2.? (I 48)))
                                                           (=>
                                                            (= tmp%90 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                                  8
                                                                 ) $ (CONST_INT 32)
                                                                ) (Poly%array%. bytes!)
                                                               ) (I 31)
                                                            )))
                                                            (=>
                                                             (= tmp%91 (vstd!arithmetic.power2.pow2.? (I 56)))
                                                             (=>
                                                              (ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_commutative_8_terms.
                                                               tmp%76 tmp%77 tmp%78 tmp%79 tmp%80 tmp%81 tmp%82 tmp%83 tmp%84 tmp%85 tmp%86 tmp%87
                                                               tmp%88 tmp%89 tmp%90 tmp%91
                                                              )
                                                              (=>
                                                               %%location_label%%6
                                                               (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                                                                    (CONST_INT 4)
                                                                   ) (Poly%array%. words!)
                                                                  ) (I 3)
                                                                 )
                                                                ) (Add (Add (Add (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                                                                           $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
                                                                          ) (I 24)
                                                                         )
                                                                        ) (vstd!arithmetic.power2.pow2.? (I 0))
                                                                       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                                            $ (CONST_INT 32)
                                                                           ) (Poly%array%. bytes!)
                                                                          ) (I 25)
                                                                         )
                                                                        ) (vstd!arithmetic.power2.pow2.? (I 8))
                                                                       )
                                                                      ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                                           $ (CONST_INT 32)
                                                                          ) (Poly%array%. bytes!)
                                                                         ) (I 26)
                                                                        )
                                                                       ) (vstd!arithmetic.power2.pow2.? (I 16))
                                                                      )
                                                                     ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                                          $ (CONST_INT 32)
                                                                         ) (Poly%array%. bytes!)
                                                                        ) (I 27)
                                                                       )
                                                                      ) (vstd!arithmetic.power2.pow2.? (I 24))
                                                                     )
                                                                    ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                                         $ (CONST_INT 32)
                                                                        ) (Poly%array%. bytes!)
                                                                       ) (I 28)
                                                                      )
                                                                     ) (vstd!arithmetic.power2.pow2.? (I 32))
                                                                    )
                                                                   ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                                        $ (CONST_INT 32)
                                                                       ) (Poly%array%. bytes!)
                                                                      ) (I 29)
                                                                     )
                                                                    ) (vstd!arithmetic.power2.pow2.? (I 40))
                                                                   )
                                                                  ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                                       $ (CONST_INT 32)
                                                                      ) (Poly%array%. bytes!)
                                                                     ) (I 30)
                                                                    )
                                                                   ) (vstd!arithmetic.power2.pow2.? (I 48))
                                                                  )
                                                                 ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                                      $ (CONST_INT 32)
                                                                     ) (Poly%array%. bytes!)
                                                                    ) (I 31)
                                                                   )
                                                                  ) (vstd!arithmetic.power2.pow2.? (I 56))
                                           )))))))))))))))))))))))
                                           (=>
                                            (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                                                 (CONST_INT 4)
                                                ) (Poly%array%. words!)
                                               ) (I 3)
                                              )
                                             ) (Add (Add (Add (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.?
                                                        $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. bytes!)
                                                       ) (I 24)
                                                      )
                                                     ) (vstd!arithmetic.power2.pow2.? (I 0))
                                                    ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                         $ (CONST_INT 32)
                                                        ) (Poly%array%. bytes!)
                                                       ) (I 25)
                                                      )
                                                     ) (vstd!arithmetic.power2.pow2.? (I 8))
                                                    )
                                                   ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                        $ (CONST_INT 32)
                                                       ) (Poly%array%. bytes!)
                                                      ) (I 26)
                                                     )
                                                    ) (vstd!arithmetic.power2.pow2.? (I 16))
                                                   )
                                                  ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                       $ (CONST_INT 32)
                                                      ) (Poly%array%. bytes!)
                                                     ) (I 27)
                                                    )
                                                   ) (vstd!arithmetic.power2.pow2.? (I 24))
                                                  )
                                                 ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                      $ (CONST_INT 32)
                                                     ) (Poly%array%. bytes!)
                                                    ) (I 28)
                                                   )
                                                  ) (vstd!arithmetic.power2.pow2.? (I 32))
                                                 )
                                                ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                     $ (CONST_INT 32)
                                                    ) (Poly%array%. bytes!)
                                                   ) (I 29)
                                                  )
                                                 ) (vstd!arithmetic.power2.pow2.? (I 40))
                                                )
                                               ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                    $ (CONST_INT 32)
                                                   ) (Poly%array%. bytes!)
                                                  ) (I 30)
                                                 )
                                                ) (vstd!arithmetic.power2.pow2.? (I 48))
                                               )
                                              ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
                                                   $ (CONST_INT 32)
                                                  ) (Poly%array%. bytes!)
                                                 ) (I 31)
                                                )
                                               ) (vstd!arithmetic.power2.pow2.? (I 56))
                                            )))
                                            (=>
                                             (= tmp%92 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                   64
                                                  ) $ (CONST_INT 4)
                                                 ) (Poly%array%. words!)
                                                ) (I 3)
                                             )))
                                             (=>
                                              (= tmp%93 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                    8
                                                   ) $ (CONST_INT 32)
                                                  ) (Poly%array%. bytes!)
                                                 ) (I 24)
                                              )))
                                              (=>
                                               (= tmp%94 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                     8
                                                    ) $ (CONST_INT 32)
                                                   ) (Poly%array%. bytes!)
                                                  ) (I 25)
                                               )))
                                               (=>
                                                (= tmp%95 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                      8
                                                     ) $ (CONST_INT 32)
                                                    ) (Poly%array%. bytes!)
                                                   ) (I 26)
                                                )))
                                                (=>
                                                 (= tmp%96 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                       8
                                                      ) $ (CONST_INT 32)
                                                     ) (Poly%array%. bytes!)
                                                    ) (I 27)
                                                 )))
                                                 (=>
                                                  (= tmp%97 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                        8
                                                       ) $ (CONST_INT 32)
                                                      ) (Poly%array%. bytes!)
                                                     ) (I 28)
                                                  )))
                                                  (=>
                                                   (= tmp%98 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                         8
                                                        ) $ (CONST_INT 32)
                                                       ) (Poly%array%. bytes!)
                                                      ) (I 29)
                                                   )))
                                                   (=>
                                                    (= tmp%99 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                          8
                                                         ) $ (CONST_INT 32)
                                                        ) (Poly%array%. bytes!)
                                                       ) (I 30)
                                                    )))
                                                    (=>
                                                     (= tmp%100 (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT
                                                           8
                                                          ) $ (CONST_INT 32)
                                                         ) (Poly%array%. bytes!)
                                                        ) (I 31)
                                                     )))
                                                     (and
                                                      (=>
                                                       %%location_label%%7
                                                       (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
                                                        tmp%92 tmp%93 tmp%94 tmp%95 tmp%96 tmp%97 tmp%98 tmp%99 tmp%100 192
                                                      ))
                                                      (=>
                                                       (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
                                                        tmp%92 tmp%93 tmp%94 tmp%95 tmp%96 tmp%97 tmp%98 tmp%99 tmp%100 192
                                                       )
                                                       (=>
                                                        (fuel_bool fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat.)
                                                        (=>
                                                         (fuel_bool fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen.)
                                                         (=>
                                                          (exists ((fuel% Fuel)) (= fuel_nat%curve25519_dalek!specs.core_specs.words_as_nat_gen.
                                                            (succ (succ (succ (succ fuel%))))
                                                          ))
                                                          (=>
                                                           %%location_label%%8
                                                           (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (curve25519_dalek!specs.core_specs.words_as_nat_u64.?
                                                             (vstd!array.spec_array_as_slice.? $ (UINT 64) $ (CONST_INT 4) (Poly%array%. words!))
                                                             (I 4) (I 64)
 ))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
