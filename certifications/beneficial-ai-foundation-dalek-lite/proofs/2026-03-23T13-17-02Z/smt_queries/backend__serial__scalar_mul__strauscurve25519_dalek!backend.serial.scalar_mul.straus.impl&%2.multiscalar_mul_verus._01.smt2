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

;; MODULE 'module backend::serial::scalar_mul::straus'
;; curve25519-dalek/src/backend/serial/scalar_mul/straus.rs:859:9: 859:37 (#3438)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!std_specs.num.u8_specs.impl&%2.obeys_cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.u8_specs.impl&%2.cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.i8_specs.impl&%2.obeys_cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.i8_specs.impl&%2.cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.u16_specs.impl&%2.obeys_cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.u16_specs.impl&%2.cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.u32_specs.impl&%2.obeys_cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.u32_specs.impl&%2.cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.i32_specs.impl&%2.obeys_cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.i32_specs.impl&%2.cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.u64_specs.impl&%2.obeys_cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.u64_specs.impl&%2.cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.u128_specs.impl&%2.obeys_cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.u128_specs.impl&%2.cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.usize_specs.impl&%2.obeys_cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.num.usize_specs.impl&%2.cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%6.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%6.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%7.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%7.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%8.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%8.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%9.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%9.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%10.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%10.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%11.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%11.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%12.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%12.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%13.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%13.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%14.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%14.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%15.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%15.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%16.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%16.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%17.obeys_from_spec. FuelId)
(declare-const fuel%vstd!std_specs.convert.impl&%17.from_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%31.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%31.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%32.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%33.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%33.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%33.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%34.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%34.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%35.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%36.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%36.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%36.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%38.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%38.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%38.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.add_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%40.add_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%43.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%43.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%44.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%44.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%45.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%45.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%45.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%46.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%46.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%46.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%47.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%47.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%48.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%48.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%48.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%50.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%50.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%50.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%52.sub_req. FuelId)
(declare-const fuel%vstd!std_specs.ops.impl&%52.sub_spec. FuelId)
(declare-const fuel%vstd!std_specs.option.impl&%0.arrow_0. FuelId)
(declare-const fuel%vstd!std_specs.option.is_some. FuelId)
(declare-const fuel%vstd!std_specs.option.spec_unwrap. FuelId)
(declare-const fuel%vstd!std_specs.option.impl&%3.obeys_cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.option.impl&%3.cmp_spec. FuelId)
(declare-const fuel%vstd!std_specs.vec.axiom_spec_len. FuelId)
(declare-const fuel%vstd!std_specs.vec.axiom_vec_has_resolved. FuelId)
(declare-const fuel%vstd!array.array_view. FuelId)
(declare-const fuel%vstd!array.impl&%0.view. FuelId)
(declare-const fuel%vstd!array.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!array.lemma_array_index. FuelId)
(declare-const fuel%vstd!array.array_len_matches_n. FuelId)
(declare-const fuel%vstd!array.axiom_spec_array_as_slice. FuelId)
(declare-const fuel%vstd!array.axiom_array_ext_equal. FuelId)
(declare-const fuel%vstd!array.axiom_array_has_resolved. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.impl&%0.skip. FuelId)
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
(declare-const fuel%vstd!view.impl&%10.view. FuelId)
(declare-const fuel%vstd!view.impl&%12.view. FuelId)
(declare-const fuel%vstd!view.impl&%14.view. FuelId)
(declare-const fuel%vstd!view.impl&%16.view. FuelId)
(declare-const fuel%vstd!view.impl&%18.view. FuelId)
(declare-const fuel%vstd!view.impl&%20.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%24.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%28.view. FuelId)
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%vstd!view.impl&%42.view. FuelId)
(declare-const fuel%vstd!view.impl&%44.view. FuelId)
(declare-const fuel%vstd!view.impl&%46.view. FuelId)
(declare-const fuel%vstd!view.impl&%48.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.radix_16_all_bounded_seq.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_input_valid.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_input_valid.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.obeys_add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_req.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.obeys_sub_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.sub_req.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.sub_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.obeys_add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_req.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.obeys_sub_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.sub_req.
 FuelId
)
(declare-const fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.sub_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_identity. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_double. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_completed_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_point.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.completed_to_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.completed_to_extended. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.projective_to_extended. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls. FuelId)
(declare-const fuel%curve25519_dalek!specs.edwards_specs.points_to_affine. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.u64_5_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_add. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_mul. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_neg. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_square. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_inv. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.mask51. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.spec_negate. FuelId)
(declare-const fuel%curve25519_dalek!specs.iterator_specs.all_points_some. FuelId)
(declare-const fuel%curve25519_dalek!specs.iterator_specs.unwrap_points. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.scalar_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.scalar_as_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.is_canonical_scalar. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.reconstruct. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.is_valid_naf. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_2w. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_16. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_16. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.radix_16_digit_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar_specs.radix_16_all_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.group_order. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.group_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%0.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%0.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%1.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%1.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%2.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%2.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%3.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!specs.window_specs.impl&%3.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%17.obeys_add_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%17.add_req. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%17.add_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%24.obeys_sub_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%24.sub_req. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%24.sub_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%39.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%39.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%40.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%40.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%41.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%41.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%42.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%42.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%43.obeys_from_spec. FuelId)
(declare-const fuel%curve25519_dalek!scalar.impl&%43.from_spec. FuelId)
(declare-const fuel%curve25519_dalek!edwards.impl&%31.obeys_add_spec. FuelId)
(declare-const fuel%curve25519_dalek!edwards.impl&%31.add_req. FuelId)
(declare-const fuel%curve25519_dalek!edwards.impl&%31.add_spec. FuelId)
(declare-const fuel%curve25519_dalek!edwards.impl&%38.obeys_sub_spec. FuelId)
(declare-const fuel%curve25519_dalek!edwards.impl&%38.sub_req. FuelId)
(declare-const fuel%curve25519_dalek!edwards.impl&%38.sub_spec. FuelId)
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
 (distinct fuel%vstd!std_specs.num.u8_specs.impl&%2.obeys_cmp_spec. fuel%vstd!std_specs.num.u8_specs.impl&%2.cmp_spec.
  fuel%vstd!std_specs.num.i8_specs.impl&%2.obeys_cmp_spec. fuel%vstd!std_specs.num.i8_specs.impl&%2.cmp_spec.
  fuel%vstd!std_specs.num.u16_specs.impl&%2.obeys_cmp_spec. fuel%vstd!std_specs.num.u16_specs.impl&%2.cmp_spec.
  fuel%vstd!std_specs.num.u32_specs.impl&%2.obeys_cmp_spec. fuel%vstd!std_specs.num.u32_specs.impl&%2.cmp_spec.
  fuel%vstd!std_specs.num.i32_specs.impl&%2.obeys_cmp_spec. fuel%vstd!std_specs.num.i32_specs.impl&%2.cmp_spec.
  fuel%vstd!std_specs.num.u64_specs.impl&%2.obeys_cmp_spec. fuel%vstd!std_specs.num.u64_specs.impl&%2.cmp_spec.
  fuel%vstd!std_specs.num.u128_specs.impl&%2.obeys_cmp_spec. fuel%vstd!std_specs.num.u128_specs.impl&%2.cmp_spec.
  fuel%vstd!std_specs.num.usize_specs.impl&%2.obeys_cmp_spec. fuel%vstd!std_specs.num.usize_specs.impl&%2.cmp_spec.
  fuel%vstd!std_specs.convert.impl&%6.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%6.from_spec.
  fuel%vstd!std_specs.convert.impl&%7.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%7.from_spec.
  fuel%vstd!std_specs.convert.impl&%8.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%8.from_spec.
  fuel%vstd!std_specs.convert.impl&%9.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%9.from_spec.
  fuel%vstd!std_specs.convert.impl&%10.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%10.from_spec.
  fuel%vstd!std_specs.convert.impl&%11.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%11.from_spec.
  fuel%vstd!std_specs.convert.impl&%12.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%12.from_spec.
  fuel%vstd!std_specs.convert.impl&%13.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%13.from_spec.
  fuel%vstd!std_specs.convert.impl&%14.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%14.from_spec.
  fuel%vstd!std_specs.convert.impl&%15.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%15.from_spec.
  fuel%vstd!std_specs.convert.impl&%16.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%16.from_spec.
  fuel%vstd!std_specs.convert.impl&%17.obeys_from_spec. fuel%vstd!std_specs.convert.impl&%17.from_spec.
  fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%31.add_req.
  fuel%vstd!std_specs.ops.impl&%31.add_spec. fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%32.add_req. fuel%vstd!std_specs.ops.impl&%32.add_spec.
  fuel%vstd!std_specs.ops.impl&%33.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%33.add_req.
  fuel%vstd!std_specs.ops.impl&%33.add_spec. fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%34.add_req. fuel%vstd!std_specs.ops.impl&%34.add_spec.
  fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%35.add_req.
  fuel%vstd!std_specs.ops.impl&%35.add_spec. fuel%vstd!std_specs.ops.impl&%36.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%36.add_req. fuel%vstd!std_specs.ops.impl&%36.add_spec.
  fuel%vstd!std_specs.ops.impl&%38.obeys_add_spec. fuel%vstd!std_specs.ops.impl&%38.add_req.
  fuel%vstd!std_specs.ops.impl&%38.add_spec. fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec.
  fuel%vstd!std_specs.ops.impl&%40.add_req. fuel%vstd!std_specs.ops.impl&%40.add_spec.
  fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec. fuel%vstd!std_specs.ops.impl&%43.sub_req.
  fuel%vstd!std_specs.ops.impl&%43.sub_spec. fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec.
  fuel%vstd!std_specs.ops.impl&%44.sub_req. fuel%vstd!std_specs.ops.impl&%44.sub_spec.
  fuel%vstd!std_specs.ops.impl&%45.obeys_sub_spec. fuel%vstd!std_specs.ops.impl&%45.sub_req.
  fuel%vstd!std_specs.ops.impl&%45.sub_spec. fuel%vstd!std_specs.ops.impl&%46.obeys_sub_spec.
  fuel%vstd!std_specs.ops.impl&%46.sub_req. fuel%vstd!std_specs.ops.impl&%46.sub_spec.
  fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec. fuel%vstd!std_specs.ops.impl&%47.sub_req.
  fuel%vstd!std_specs.ops.impl&%47.sub_spec. fuel%vstd!std_specs.ops.impl&%48.obeys_sub_spec.
  fuel%vstd!std_specs.ops.impl&%48.sub_req. fuel%vstd!std_specs.ops.impl&%48.sub_spec.
  fuel%vstd!std_specs.ops.impl&%50.obeys_sub_spec. fuel%vstd!std_specs.ops.impl&%50.sub_req.
  fuel%vstd!std_specs.ops.impl&%50.sub_spec. fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec.
  fuel%vstd!std_specs.ops.impl&%52.sub_req. fuel%vstd!std_specs.ops.impl&%52.sub_spec.
  fuel%vstd!std_specs.option.impl&%0.arrow_0. fuel%vstd!std_specs.option.is_some. fuel%vstd!std_specs.option.spec_unwrap.
  fuel%vstd!std_specs.option.impl&%3.obeys_cmp_spec. fuel%vstd!std_specs.option.impl&%3.cmp_spec.
  fuel%vstd!std_specs.vec.axiom_spec_len. fuel%vstd!std_specs.vec.axiom_vec_has_resolved.
  fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index.
  fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_spec_array_as_slice.
  fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized.
  fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.impl&%0.skip. fuel%vstd!seq.axiom_seq_index_decreases.
  fuel%vstd!seq.axiom_seq_subrange_decreases. fuel%vstd!seq.axiom_seq_empty. fuel%vstd!seq.axiom_seq_new_len.
  fuel%vstd!seq.axiom_seq_new_index. fuel%vstd!seq.axiom_seq_push_len. fuel%vstd!seq.axiom_seq_push_index_same.
  fuel%vstd!seq.axiom_seq_push_index_different. fuel%vstd!seq.axiom_seq_ext_equal.
  fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!seq.axiom_seq_subrange_len. fuel%vstd!seq.axiom_seq_subrange_index.
  fuel%vstd!seq.lemma_seq_two_subranges_index. fuel%vstd!seq_lib.impl&%0.map. fuel%vstd!slice.impl&%2.spec_index.
  fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal. fuel%vstd!slice.axiom_slice_has_resolved.
  fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view. fuel%vstd!view.impl&%4.view.
  fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%10.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%18.view.
  fuel%vstd!view.impl&%20.view. fuel%vstd!view.impl&%22.view. fuel%vstd!view.impl&%24.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%28.view. fuel%vstd!view.impl&%32.view.
  fuel%vstd!view.impl&%42.view. fuel%vstd!view.impl&%44.view. fuel%vstd!view.impl&%46.view.
  fuel%vstd!view.impl&%48.view. fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req. fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec. fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req.
  fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec. fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd. fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
  fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum. fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.radix_16_all_bounded_seq.
  fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_input_valid.
  fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_input_valid.
  fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.obeys_add_spec. fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_req.
  fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_spec. fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.obeys_sub_spec.
  fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.sub_req. fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.sub_spec.
  fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.obeys_add_spec. fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_req.
  fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_spec. fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.obeys_sub_spec.
  fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.sub_req. fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.sub_spec.
  fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.
  fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective. fuel%curve25519_dalek!specs.edwards_specs.edwards_identity.
  fuel%curve25519_dalek!specs.edwards_specs.is_identity_edwards_point. fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point. fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.
  fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point. fuel%curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat. fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.
  fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_nat. fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.
  fuel%curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat. fuel%curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.
  fuel%curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards. fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point. fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.
  fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards. fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.
  fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards. fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels.
  fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels. fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_add. fuel%curve25519_dalek!specs.edwards_specs.edwards_double.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_neg. fuel%curve25519_dalek!specs.edwards_specs.edwards_sub.
  fuel%curve25519_dalek!specs.edwards_specs.is_valid_completed_point. fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_point.
  fuel%curve25519_dalek!specs.edwards_specs.completed_to_projective. fuel%curve25519_dalek!specs.edwards_specs.completed_to_extended.
  fuel%curve25519_dalek!specs.edwards_specs.projective_to_extended. fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.
  fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed. fuel%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.
  fuel%curve25519_dalek!specs.edwards_specs.points_to_affine. fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.
  fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded. fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.
  fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs. fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs.
  fuel%curve25519_dalek!specs.field_specs.fe51_as_nat. fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.
  fuel%curve25519_dalek!specs.field_specs.field_add. fuel%curve25519_dalek!specs.field_specs.field_sub.
  fuel%curve25519_dalek!specs.field_specs.field_mul. fuel%curve25519_dalek!specs.field_specs.field_neg.
  fuel%curve25519_dalek!specs.field_specs.field_square. fuel%curve25519_dalek!specs.field_specs.field_inv.
  fuel%curve25519_dalek!specs.field_specs_u64.p. fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical. fuel%curve25519_dalek!specs.field_specs_u64.mask51.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.
  fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec. fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.
  fuel%curve25519_dalek!specs.field_specs_u64.spec_negate. fuel%curve25519_dalek!specs.iterator_specs.all_points_some.
  fuel%curve25519_dalek!specs.iterator_specs.unwrap_points. fuel%curve25519_dalek!specs.scalar_specs.scalar_as_nat.
  fuel%curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical. fuel%curve25519_dalek!specs.scalar_specs.scalar_as_canonical.
  fuel%curve25519_dalek!specs.scalar_specs.is_canonical_scalar. fuel%curve25519_dalek!specs.scalar_specs.reconstruct.
  fuel%curve25519_dalek!specs.scalar_specs.is_valid_naf. fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.
  fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_2w. fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_16.
  fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_16. fuel%curve25519_dalek!specs.scalar_specs.radix_16_digit_bounded.
  fuel%curve25519_dalek!specs.scalar_specs.radix_16_all_bounded. fuel%curve25519_dalek!specs.scalar52_specs.group_order.
  fuel%curve25519_dalek!specs.scalar52_specs.group_canonical. fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.
  fuel%curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded. fuel%curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.
  fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords. fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.
  fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.
  fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.
  fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective. fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.
  fuel%curve25519_dalek!specs.window_specs.impl&%0.obeys_from_spec. fuel%curve25519_dalek!specs.window_specs.impl&%0.from_spec.
  fuel%curve25519_dalek!specs.window_specs.impl&%1.obeys_from_spec. fuel%curve25519_dalek!specs.window_specs.impl&%1.from_spec.
  fuel%curve25519_dalek!specs.window_specs.impl&%2.obeys_from_spec. fuel%curve25519_dalek!specs.window_specs.impl&%2.from_spec.
  fuel%curve25519_dalek!specs.window_specs.impl&%3.obeys_from_spec. fuel%curve25519_dalek!specs.window_specs.impl&%3.from_spec.
  fuel%curve25519_dalek!scalar.impl&%17.obeys_add_spec. fuel%curve25519_dalek!scalar.impl&%17.add_req.
  fuel%curve25519_dalek!scalar.impl&%17.add_spec. fuel%curve25519_dalek!scalar.impl&%24.obeys_sub_spec.
  fuel%curve25519_dalek!scalar.impl&%24.sub_req. fuel%curve25519_dalek!scalar.impl&%24.sub_spec.
  fuel%curve25519_dalek!scalar.impl&%39.obeys_from_spec. fuel%curve25519_dalek!scalar.impl&%39.from_spec.
  fuel%curve25519_dalek!scalar.impl&%40.obeys_from_spec. fuel%curve25519_dalek!scalar.impl&%40.from_spec.
  fuel%curve25519_dalek!scalar.impl&%41.obeys_from_spec. fuel%curve25519_dalek!scalar.impl&%41.from_spec.
  fuel%curve25519_dalek!scalar.impl&%42.obeys_from_spec. fuel%curve25519_dalek!scalar.impl&%42.from_spec.
  fuel%curve25519_dalek!scalar.impl&%43.obeys_from_spec. fuel%curve25519_dalek!scalar.impl&%43.from_spec.
  fuel%curve25519_dalek!edwards.impl&%31.obeys_add_spec. fuel%curve25519_dalek!edwards.impl&%31.add_req.
  fuel%curve25519_dalek!edwards.impl&%31.add_spec. fuel%curve25519_dalek!edwards.impl&%38.obeys_sub_spec.
  fuel%curve25519_dalek!edwards.impl&%38.sub_req. fuel%curve25519_dalek!edwards.impl&%38.sub_spec.
  fuel%vstd!array.group_array_axioms. fuel%vstd!function.group_function_axioms. fuel%vstd!laws_cmp.group_laws_cmp.
  fuel%vstd!laws_eq.bool_laws.group_laws_eq. fuel%vstd!laws_eq.u8_laws.group_laws_eq.
  fuel%vstd!laws_eq.i8_laws.group_laws_eq. fuel%vstd!laws_eq.u16_laws.group_laws_eq.
  fuel%vstd!laws_eq.i16_laws.group_laws_eq. fuel%vstd!laws_eq.u32_laws.group_laws_eq.
  fuel%vstd!laws_eq.i32_laws.group_laws_eq. fuel%vstd!laws_eq.u64_laws.group_laws_eq.
  fuel%vstd!laws_eq.i64_laws.group_laws_eq. fuel%vstd!laws_eq.u128_laws.group_laws_eq.
  fuel%vstd!laws_eq.i128_laws.group_laws_eq. fuel%vstd!laws_eq.usize_laws.group_laws_eq.
  fuel%vstd!laws_eq.isize_laws.group_laws_eq. fuel%vstd!laws_eq.group_laws_eq. fuel%vstd!layout.group_layout_axioms.
  fuel%vstd!map.group_map_axioms. fuel%vstd!multiset.group_multiset_axioms. fuel%vstd!raw_ptr.group_raw_ptr_axioms.
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
 (=>
  (fuel_bool_default fuel%vstd!std_specs.vec.group_vec_axioms.)
  (and
   (fuel_bool_default fuel%vstd!std_specs.vec.axiom_spec_len.)
   (fuel_bool_default fuel%vstd!std_specs.vec.axiom_vec_has_resolved.)
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
(declare-fun tr_bound%core!clone.Clone. (Dcr Type) Bool)
(declare-fun tr_bound%core!cmp.PartialEq. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!cmp.Eq. (Dcr Type) Bool)
(declare-fun tr_bound%core!cmp.PartialOrd. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!cmp.Ord. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.cmp.OrdSpec. (Dcr Type) Bool)
(declare-fun tr_bound%core!convert.From. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.convert.FromSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!alloc.Allocator. (Dcr Type) Bool)
(declare-fun tr_bound%core!iter.traits.iterator.Iterator. (Dcr Type) Bool)
(declare-fun tr_bound%core!borrow.Borrow. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.arith.Add. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.ops.AddSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.arith.Sub. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.ops.SubSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.option.OptionAdditionalFns. (Dcr Type Dcr Type)
 Bool
)
(declare-fun tr_bound%curve25519_dalek!traits.Identity. (Dcr Type) Bool)

;; Associated-Type-Decls
(declare-fun proj%%vstd!view.View./V (Dcr Type) Dcr)
(declare-fun proj%vstd!view.View./V (Dcr Type) Type)
(declare-fun proj%%core!iter.traits.iterator.Iterator./Item (Dcr Type) Dcr)
(declare-fun proj%core!iter.traits.iterator.Iterator./Item (Dcr Type) Type)
(declare-fun proj%%core!ops.arith.Add./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.arith.Add./Output (Dcr Type Dcr Type) Type)
(declare-fun proj%%core!ops.arith.Sub./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.arith.Sub./Output (Dcr Type Dcr Type) Type)

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
(declare-sort alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
 0
)
(declare-sort alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
 0
)
(declare-sort alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>. 0)
(declare-sort alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
 0
)
(declare-sort alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
 0
)
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort vstd!seq.Seq<i8.>. 0)
(declare-sort vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
 0
)
(declare-sort vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. 0)
(declare-sort vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. 0)
(declare-sort vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
 0
)
(declare-sort vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
 0
)
(declare-sort vstd!seq.Seq<vstd!seq.Seq<i8.>.>. 0)
(declare-sort vstd!seq.Seq<tuple%2<nat./nat.>.>. 0)
(declare-sort slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
 0
)
(declare-sort slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
 0
)
(declare-sort allocator_global%. 0)
(declare-datatypes ((core!cmp.Ordering. 0) (core!option.Option. 0) (vstd!raw_ptr.PtrData.
   0
  ) (curve25519_dalek!backend.serial.u64.field.FieldElement51. 0) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   0
  ) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint. 0) (curve25519_dalek!backend.serial.curve_models.CompletedPoint.
   0
  ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. 0) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   0
  ) (curve25519_dalek!scalar.Scalar. 0) (curve25519_dalek!edwards.EdwardsPoint. 0)
  (curve25519_dalek!window.LookupTable. 0) (curve25519_dalek!window.NafLookupTable5.
   0
  ) (tuple%0. 0) (tuple%1. 0) (tuple%2. 0) (tuple%3. 0) (tuple%4. 0)
 ) (((core!cmp.Ordering./Less) (core!cmp.Ordering./Equal) (core!cmp.Ordering./Greater))
  ((core!option.Option./None) (core!option.Option./Some (core!option.Option./Some/?0 Poly)))
  ((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     %%Function%%
   ))
  ) ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
    (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?gcd
     Int
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?x
     Int
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?y
     Int
   ))
  ) ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint (
     curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?Y
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?Z
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
  ) ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?Y
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?Z
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?T
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
  ) ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint
    (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_plus_x
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_minus_x
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?xy2d
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
  ) ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
    (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_plus_X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_minus_X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Z
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?T2d
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
  ) ((curve25519_dalek!scalar.Scalar./Scalar (curve25519_dalek!scalar.Scalar./Scalar/?bytes
     %%Function%%
   ))
  ) ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?X
     curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Y curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Z curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?T curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   )
  ) ((curve25519_dalek!window.LookupTable./LookupTable (curve25519_dalek!window.LookupTable./LookupTable/?0
     %%Function%%
   ))
  ) ((curve25519_dalek!window.NafLookupTable5./NafLookupTable5 (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/?0
     %%Function%%
   ))
  ) ((tuple%0./tuple%0)) ((tuple%1./tuple%1 (tuple%1./tuple%1/?0 Poly))) ((tuple%2./tuple%2
    (tuple%2./tuple%2/?0 Poly) (tuple%2./tuple%2/?1 Poly)
   )
  ) ((tuple%3./tuple%3 (tuple%3./tuple%3/?0 Poly) (tuple%3./tuple%3/?1 Poly) (tuple%3./tuple%3/?2
     Poly
   ))
  ) ((tuple%4./tuple%4 (tuple%4./tuple%4/?0 Poly) (tuple%4./tuple%4/?1 Poly) (tuple%4./tuple%4/?2
     Poly
    ) (tuple%4./tuple%4/?3 Poly)
))))
(declare-fun core!option.Option./Some/0 (Dcr Type core!option.Option.) Poly)
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) %%Function%%
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Int
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X
 (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
 (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z
 (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
 (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!scalar.Scalar./Scalar/bytes (curve25519_dalek!scalar.Scalar.)
 %%Function%%
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (curve25519_dalek!edwards.EdwardsPoint.)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun curve25519_dalek!window.LookupTable./LookupTable/0 (curve25519_dalek!window.LookupTable.)
 %%Function%%
)
(declare-fun curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (curve25519_dalek!window.NafLookupTable5.)
 %%Function%%
)
(declare-fun tuple%1./tuple%1/0 (tuple%1.) Poly)
(declare-fun tuple%2./tuple%2/0 (tuple%2.) Poly)
(declare-fun tuple%2./tuple%2/1 (tuple%2.) Poly)
(declare-fun tuple%3./tuple%3/0 (tuple%3.) Poly)
(declare-fun tuple%3./tuple%3/1 (tuple%3.) Poly)
(declare-fun tuple%3./tuple%3/2 (tuple%3.) Poly)
(declare-fun tuple%4./tuple%4/0 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/1 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/2 (tuple%4.) Poly)
(declare-fun tuple%4./tuple%4/3 (tuple%4.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%fun%2. (Dcr Type Dcr Type Dcr Type) Type)
(declare-const TYPE%core!cmp.Ordering. Type)
(declare-fun TYPE%core!option.Option. (Dcr Type) Type)
(declare-fun TYPE%alloc!vec.Vec. (Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. Type)
(declare-const TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 Type
)
(declare-const TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
 Type
)
(declare-const TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint. Type)
(declare-const TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
 Type
)
(declare-const TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 Type
)
(declare-const TYPE%curve25519_dalek!scalar.Scalar. Type)
(declare-const TYPE%curve25519_dalek!edwards.EdwardsPoint. Type)
(declare-fun TYPE%curve25519_dalek!window.LookupTable. (Dcr Type) Type)
(declare-fun TYPE%curve25519_dalek!window.NafLookupTable5. (Dcr Type) Type)
(declare-fun TYPE%tuple%1. (Dcr Type) Type)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%tuple%3. (Dcr Type Dcr Type Dcr Type) Type)
(declare-fun TYPE%tuple%4. (Dcr Type Dcr Type Dcr Type Dcr Type) Type)
(declare-fun FNDEF%core!convert.From.from. (Dcr Type Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%fun%2. (%%Function%%) Poly)
(declare-fun %Poly%fun%2. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
 (alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.)
 Poly
)
(declare-fun %Poly%alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
 (Poly) alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
)
(declare-fun Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
 (alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.) Poly
)
(declare-fun %Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
 (Poly) alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
)
(declare-fun Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.
 (alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.) Poly
)
(declare-fun %Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.
 (Poly) alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.
)
(declare-fun Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
 (alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.)
 Poly
)
(declare-fun %Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
 (Poly) alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
)
(declare-fun Poly%alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
 (alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.)
 Poly
)
(declare-fun %Poly%alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
 (Poly) alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<i8.>. (vstd!seq.Seq<i8.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<i8.>. (Poly) vstd!seq.Seq<i8.>.)
(declare-fun Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
 (vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.) Poly
)
(declare-fun %Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
 (Poly) vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
)
(declare-fun Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. (vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)
 Poly
)
(declare-fun %Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. (Poly) vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)
(declare-fun Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. (vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.)
 Poly
)
(declare-fun %Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. (Poly) vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.)
(declare-fun Poly%vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
 (vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.)
 Poly
)
(declare-fun %Poly%vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
 (Poly) vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
)
(declare-fun Poly%vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
 (vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.)
 Poly
)
(declare-fun %Poly%vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
 (Poly) vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
)
(declare-fun Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. (vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
 Poly
)
(declare-fun %Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. (Poly) vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
(declare-fun Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. (vstd!seq.Seq<tuple%2<nat./nat.>.>.)
 Poly
)
(declare-fun %Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. (Poly) vstd!seq.Seq<tuple%2<nat./nat.>.>.)
(declare-fun Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
 (slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.) Poly
)
(declare-fun %Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
 (Poly) slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
)
(declare-fun Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
 (slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.) Poly
)
(declare-fun %Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
 (Poly) slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%core!cmp.Ordering. (core!cmp.Ordering.) Poly)
(declare-fun %Poly%core!cmp.Ordering. (Poly) core!cmp.Ordering.)
(declare-fun Poly%core!option.Option. (core!option.Option.) Poly)
(declare-fun %Poly%core!option.Option. (Poly) core!option.Option.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Poly
)
(declare-fun %Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 (Poly) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)
(declare-fun Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (
  Poly
 ) curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
)
(declare-fun Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. (curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. (Poly)
 curve25519_dalek!backend.serial.curve_models.CompletedPoint.
)
(declare-fun Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (
  curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
 ) Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
 (Poly) curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
)
(declare-fun Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.) Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 (Poly) curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
)
(declare-fun Poly%curve25519_dalek!scalar.Scalar. (curve25519_dalek!scalar.Scalar.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!scalar.Scalar. (Poly) curve25519_dalek!scalar.Scalar.)
(declare-fun Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!edwards.EdwardsPoint. (Poly) curve25519_dalek!edwards.EdwardsPoint.)
(declare-fun Poly%curve25519_dalek!window.LookupTable. (curve25519_dalek!window.LookupTable.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!window.LookupTable. (Poly) curve25519_dalek!window.LookupTable.)
(declare-fun Poly%curve25519_dalek!window.NafLookupTable5. (curve25519_dalek!window.NafLookupTable5.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!window.NafLookupTable5. (Poly) curve25519_dalek!window.NafLookupTable5.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(declare-fun Poly%tuple%1. (tuple%1.) Poly)
(declare-fun %Poly%tuple%1. (Poly) tuple%1.)
(declare-fun Poly%tuple%2. (tuple%2.) Poly)
(declare-fun %Poly%tuple%2. (Poly) tuple%2.)
(declare-fun Poly%tuple%3. (tuple%3.) Poly)
(declare-fun %Poly%tuple%3. (Poly) tuple%3.)
(declare-fun Poly%tuple%4. (tuple%4.) Poly)
(declare-fun %Poly%tuple%4. (Poly) tuple%4.)
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
 (forall ((x alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.))
  (!
   (= x (%Poly%alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
     (Poly%alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
      x
   )))
   :pattern ((Poly%alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
     x
   ))
   :qid internal_alloc__vec__Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global__.>_box_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global__.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%alloc!vec.Vec. $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      $ ALLOCATOR_GLOBAL
    ))
    (= x (Poly%alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
      (%Poly%alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
       x
   ))))
   :pattern ((has_type x (TYPE%alloc!vec.Vec. $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      $ ALLOCATOR_GLOBAL
   )))
   :qid internal_alloc__vec__Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global__.>_unbox_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global__.>_unbox_axiom_definition
)))
(assert
 (forall ((x alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.))
  (!
   (has_type (Poly%alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
     x
    ) (TYPE%alloc!vec.Vec. $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     $ ALLOCATOR_GLOBAL
   ))
   :pattern ((has_type (Poly%alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
      x
     ) (TYPE%alloc!vec.Vec. $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      $ ALLOCATOR_GLOBAL
   )))
   :qid internal_alloc__vec__Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global__.>_has_type_always_definition
   :skolemid skolem_internal_alloc__vec__Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global__.>_has_type_always_definition
)))
(assert
 (forall ((x alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.))
  (!
   (= x (%Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
     (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. x)
   ))
   :pattern ((Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
     x
   ))
   :qid internal_alloc__vec__Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global__.>_box_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global__.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL))
    (= x (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
      (%Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. x)
   )))
   :pattern ((has_type x (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
      $ ALLOCATOR_GLOBAL
   )))
   :qid internal_alloc__vec__Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global__.>_unbox_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global__.>_unbox_axiom_definition
)))
(assert
 (forall ((x alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.))
  (!
   (has_type (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
     x
    ) (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL)
   )
   :pattern ((has_type (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
      x
     ) (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL)
   ))
   :qid internal_alloc__vec__Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global__.>_has_type_always_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global__.>_has_type_always_definition
)))
(assert
 (forall ((x alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.)) (
   !
   (= x (%Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>. (Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.
      x
   )))
   :pattern ((Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.
     x
   ))
   :qid internal_alloc__vec__Vec<curve25519_dalek!scalar.Scalar./allocator_global__.>_box_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!scalar.Scalar./allocator_global__.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!scalar.Scalar. $ ALLOCATOR_GLOBAL))
    (= x (Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>. (%Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.
       x
   ))))
   :pattern ((has_type x (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!scalar.Scalar. $
      ALLOCATOR_GLOBAL
   )))
   :qid internal_alloc__vec__Vec<curve25519_dalek!scalar.Scalar./allocator_global__.>_unbox_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!scalar.Scalar./allocator_global__.>_unbox_axiom_definition
)))
(assert
 (forall ((x alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.)) (
   !
   (has_type (Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.
     x
    ) (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!scalar.Scalar. $ ALLOCATOR_GLOBAL)
   )
   :pattern ((has_type (Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.
      x
     ) (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!scalar.Scalar. $ ALLOCATOR_GLOBAL)
   ))
   :qid internal_alloc__vec__Vec<curve25519_dalek!scalar.Scalar./allocator_global__.>_has_type_always_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!scalar.Scalar./allocator_global__.>_has_type_always_definition
)))
(assert
 (forall ((x alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.))
  (!
   (= x (%Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
     (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
      x
   )))
   :pattern ((Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
     x
   ))
   :qid internal_alloc__vec__Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_box_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      $ ALLOCATOR_GLOBAL
    ))
    (= x (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
      (%Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
       x
   ))))
   :pattern ((has_type x (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) $ ALLOCATOR_GLOBAL
   )))
   :qid internal_alloc__vec__Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_unbox_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_unbox_axiom_definition
)))
(assert
 (forall ((x alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.))
  (!
   (has_type (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
     x
    ) (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
     $ ALLOCATOR_GLOBAL
   ))
   :pattern ((has_type (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
      x
     ) (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      $ ALLOCATOR_GLOBAL
   )))
   :qid internal_alloc__vec__Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_has_type_always_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_has_type_always_definition
)))
(assert
 (forall ((x alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.))
  (!
   (= x (%Poly%alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
     (Poly%alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
      x
   )))
   :pattern ((Poly%alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
     x
   ))
   :qid internal_alloc__vec__Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_box_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $
       TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) $ ALLOCATOR_GLOBAL
    ))
    (= x (Poly%alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
      (%Poly%alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
       x
   ))))
   :pattern ((has_type x (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) $ ALLOCATOR_GLOBAL
   )))
   :qid internal_alloc__vec__Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_unbox_axiom_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_unbox_axiom_definition
)))
(assert
 (forall ((x alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.))
  (!
   (has_type (Poly%alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
     x
    ) (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
     $ ALLOCATOR_GLOBAL
   ))
   :pattern ((has_type (Poly%alloc!vec.Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
      x
     ) (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      $ ALLOCATOR_GLOBAL
   )))
   :qid internal_alloc__vec__Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_has_type_always_definition
   :skolemid skolem_internal_alloc__vec__Vec<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global__.>_has_type_always_definition
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
 (forall ((x vstd!seq.Seq<i8.>.)) (!
   (= x (%Poly%vstd!seq.Seq<i8.>. (Poly%vstd!seq.Seq<i8.>. x)))
   :pattern ((Poly%vstd!seq.Seq<i8.>. x))
   :qid internal_vstd__seq__Seq<i8.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<i8.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (SINT 8)))
    (= x (Poly%vstd!seq.Seq<i8.>. (%Poly%vstd!seq.Seq<i8.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (SINT 8))))
   :qid internal_vstd__seq__Seq<i8.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<i8.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<i8.>.)) (!
   (has_type (Poly%vstd!seq.Seq<i8.>. x) (TYPE%vstd!seq.Seq. $ (SINT 8)))
   :pattern ((has_type (Poly%vstd!seq.Seq<i8.>. x) (TYPE%vstd!seq.Seq. $ (SINT 8))))
   :qid internal_vstd__seq__Seq<i8.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<i8.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.))
  (!
   (= x (%Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
     (Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>. x)
   ))
   :pattern ((Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
     x
   ))
   :qid internal_vstd__seq__Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)))
    (= x (Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
      (%Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))))
   :qid internal_vstd__seq__Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.))
  (!
   (has_type (Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
     x
    ) (TYPE%vstd!seq.Seq. $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
   )
   :pattern ((has_type (Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
      x
     ) (TYPE%vstd!seq.Seq. $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
   ))
   :qid internal_vstd__seq__Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)) (!
   (= x (%Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
      x
   )))
   :pattern ((Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. x))
   :qid internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
    (= x (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. (%Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)))
   :qid internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)) (!
   (has_type (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. x) (TYPE%vstd!seq.Seq.
     $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ))
   :pattern ((has_type (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. x)
     (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   ))
   :qid internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!edwards.EdwardsPoint.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.)) (!
   (= x (%Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
      x
   )))
   :pattern ((Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. x))
   :qid internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.))
    (= x (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. (%Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.)))
   :qid internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.)) (!
   (has_type (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. x) (TYPE%vstd!seq.Seq.
     $ TYPE%curve25519_dalek!scalar.Scalar.
   ))
   :pattern ((has_type (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. x) (TYPE%vstd!seq.Seq.
      $ TYPE%curve25519_dalek!scalar.Scalar.
   )))
   :qid internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!scalar.Scalar.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.))
  (!
   (= x (%Poly%vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
     (Poly%vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
      x
   )))
   :pattern ((Poly%vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
     x
   ))
   :qid internal_vstd__seq__Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)))
    (= x (Poly%vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
      (%Poly%vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))))
   :qid internal_vstd__seq__Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.))
  (!
   (has_type (Poly%vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
     x
    ) (TYPE%vstd!seq.Seq. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
   )
   :pattern ((has_type (Poly%vstd!seq.Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
      x
     ) (TYPE%vstd!seq.Seq. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
   ))
   :qid internal_vstd__seq__Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.))
  (!
   (= x (%Poly%vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
     (Poly%vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
      x
   )))
   :pattern ((Poly%vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
     x
   ))
   :qid internal_vstd__seq__Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)))
    (= x (Poly%vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
      (%Poly%vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))))
   :qid internal_vstd__seq__Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.))
  (!
   (has_type (Poly%vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
     x
    ) (TYPE%vstd!seq.Seq. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
   )
   :pattern ((has_type (Poly%vstd!seq.Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>.
      x
     ) (TYPE%vstd!seq.Seq. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
   ))
   :qid internal_vstd__seq__Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<curve25519_dalek!window.NafLookupTable5<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)) (!
   (= x (%Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
      x
   )))
   :pattern ((Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. x))
   :qid internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
    (= x (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. (%Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8)))))
   :qid internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)) (!
   (has_type (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. x) (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq.
      $ (SINT 8)
   )))
   :pattern ((has_type (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. x) (TYPE%vstd!seq.Seq. $
      (TYPE%vstd!seq.Seq. $ (SINT 8))
   )))
   :qid internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<vstd!seq.Seq<i8.>.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<tuple%2<nat./nat.>.>.)) (!
   (= x (%Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
      x
   )))
   :pattern ((Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. x))
   :qid internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
    (= x (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. (%Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT))))
   :qid internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<tuple%2<nat./nat.>.>.)) (!
   (has_type (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. x) (TYPE%vstd!seq.Seq. (DST $) (
      TYPE%tuple%2. $ NAT $ NAT
   )))
   :pattern ((has_type (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. x) (TYPE%vstd!seq.Seq.
      (DST $) (TYPE%tuple%2. $ NAT $ NAT)
   )))
   :qid internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<tuple__2<nat./nat.>.>_has_type_always_definition
)))
(assert
 (forall ((x slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.))
  (!
   (= x (%Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
     (Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>. x)
   ))
   :pattern ((Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
     x
   ))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    (= x (Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
      (%Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>. x)
   )))
   :pattern ((has_type x (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.))
  (!
   (has_type (Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
     x
    ) (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   )
   :pattern ((has_type (Poly%slice%<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>.
      x
     ) (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   ))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.>_has_type_always_definition
)))
(assert
 (forall ((x slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.))
  (!
   (= x (%Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
     (Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
      x
   )))
   :pattern ((Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
     x
   ))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    (= x (Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
      (%Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
       x
   ))))
   :pattern ((has_type x (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.))
  (!
   (has_type (Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
     x
    ) (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :pattern ((has_type (Poly%slice%<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>.
      x
     ) (SLICE $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   ))
   :qid internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>_has_type_always_definition
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
 (forall ((x core!cmp.Ordering.)) (!
   (= x (%Poly%core!cmp.Ordering. (Poly%core!cmp.Ordering. x)))
   :pattern ((Poly%core!cmp.Ordering. x))
   :qid internal_core__cmp__Ordering_box_axiom_definition
   :skolemid skolem_internal_core__cmp__Ordering_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%core!cmp.Ordering.)
    (= x (Poly%core!cmp.Ordering. (%Poly%core!cmp.Ordering. x)))
   )
   :pattern ((has_type x TYPE%core!cmp.Ordering.))
   :qid internal_core__cmp__Ordering_unbox_axiom_definition
   :skolemid skolem_internal_core__cmp__Ordering_unbox_axiom_definition
)))
(assert
 (forall ((x core!cmp.Ordering.)) (!
   (has_type (Poly%core!cmp.Ordering. x) TYPE%core!cmp.Ordering.)
   :pattern ((has_type (Poly%core!cmp.Ordering. x) TYPE%core!cmp.Ordering.))
   :qid internal_core__cmp__Ordering_has_type_always_definition
   :skolemid skolem_internal_core__cmp__Ordering_has_type_always_definition
)))
(assert
 (forall ((x core!option.Option.)) (!
   (= x (%Poly%core!option.Option. (Poly%core!option.Option. x)))
   :pattern ((Poly%core!option.Option. x))
   :qid internal_core__option__Option_box_axiom_definition
   :skolemid skolem_internal_core__option__Option_box_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!option.Option. V&. V&))
    (= x (Poly%core!option.Option. (%Poly%core!option.Option. x)))
   )
   :pattern ((has_type x (TYPE%core!option.Option. V&. V&)))
   :qid internal_core__option__Option_unbox_axiom_definition
   :skolemid skolem_internal_core__option__Option_unbox_axiom_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type)) (!
   (has_type (Poly%core!option.Option. core!option.Option./None) (TYPE%core!option.Option.
     V&. V&
   ))
   :pattern ((has_type (Poly%core!option.Option. core!option.Option./None) (TYPE%core!option.Option.
      V&. V&
   )))
   :qid internal_core!option.Option./None_constructor_definition
   :skolemid skolem_internal_core!option.Option./None_constructor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (_0! Poly)) (!
   (=>
    (has_type _0! V&)
    (has_type (Poly%core!option.Option. (core!option.Option./Some _0!)) (TYPE%core!option.Option.
      V&. V&
   )))
   :pattern ((has_type (Poly%core!option.Option. (core!option.Option./Some _0!)) (TYPE%core!option.Option.
      V&. V&
   )))
   :qid internal_core!option.Option./Some_constructor_definition
   :skolemid skolem_internal_core!option.Option./Some_constructor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x core!option.Option.)) (!
   (=>
    (is-core!option.Option./Some x)
    (= (core!option.Option./Some/0 V&. V& x) (core!option.Option./Some/?0 x))
   )
   :pattern ((core!option.Option./Some/0 V&. V& x))
   :qid internal_core!option.Option./Some/0_accessor_definition
   :skolemid skolem_internal_core!option.Option./Some/0_accessor_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!option.Option. V&. V&))
    (has_type (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x)) V&)
   )
   :pattern ((core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x)) (has_type
     x (TYPE%core!option.Option. V&. V&)
   ))
   :qid internal_core!option.Option./Some/0_invariant_definition
   :skolemid skolem_internal_core!option.Option./Some/0_invariant_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (x core!option.Option.)) (!
   (=>
    (is-core!option.Option./Some x)
    (height_lt (height (core!option.Option./Some/0 V&. V& x)) (height (Poly%core!option.Option.
       x
   ))))
   :pattern ((height (core!option.Option./Some/0 V&. V& x)))
   :qid prelude_datatype_height_core!option.Option./Some/0
   :skolemid skolem_prelude_datatype_height_core!option.Option./Some/0
)))
(assert
 (forall ((V&. Dcr) (V& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%core!option.Option. V&. V&))
     (has_type y (TYPE%core!option.Option. V&. V&))
     (is-core!option.Option./None (%Poly%core!option.Option. x))
     (is-core!option.Option./None (%Poly%core!option.Option. y))
    )
    (ext_eq deep (TYPE%core!option.Option. V&. V&) x y)
   )
   :pattern ((ext_eq deep (TYPE%core!option.Option. V&. V&) x y))
   :qid internal_core!option.Option./None_ext_equal_definition
   :skolemid skolem_internal_core!option.Option./None_ext_equal_definition
)))
(assert
 (forall ((V&. Dcr) (V& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%core!option.Option. V&. V&))
     (has_type y (TYPE%core!option.Option. V&. V&))
     (is-core!option.Option./Some (%Poly%core!option.Option. x))
     (is-core!option.Option./Some (%Poly%core!option.Option. y))
     (ext_eq deep V& (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. x))
      (core!option.Option./Some/0 V&. V& (%Poly%core!option.Option. y))
    ))
    (ext_eq deep (TYPE%core!option.Option. V&. V&) x y)
   )
   :pattern ((ext_eq deep (TYPE%core!option.Option. V&. V&) x y))
   :qid internal_core!option.Option./Some_ext_equal_definition
   :skolemid skolem_internal_core!option.Option./Some_ext_equal_definition
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
 (forall ((x curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x))
   :qid internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (= x (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.))
   :qid internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__u64__field__FieldElement51_unbox_axiom_definition
)))
(assert
 (forall ((_limbs! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
       _limbs!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 _limbs!)
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.u64.field.FieldElement51.)) (!
   (= (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     x
    ) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (has_type (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
       (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x)
      )
     ) (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
     (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   )
   :qid internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= x (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
     (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   ))
   :pattern ((Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
     x
   ))
   :qid internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
    (= x (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   )))
   :pattern ((has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
   :qid internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__lemmas__common_lemmas__number_theory_lemmas__ExtGcdResult_unbox_axiom_definition
)))
(assert
 (forall ((_gcd! Int) (_x! Int) (_y! Int)) (!
   (=>
    (<= 0 _gcd!)
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       _gcd! _x! _y!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       _gcd! _x! _y!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?gcd
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
      (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
     (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. x)
    ) (has_type x TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.)
   )
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?x
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x_accessor_definition
)))
(assert
 (forall ((x curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.))
  (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
     x
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/?y
     x
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
     x
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y_accessor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectivePoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectivePoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (= x (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectivePoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectivePoint_unbox_axiom_definition
)))
(assert
 (forall ((_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _X!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint
       _X! _Y! _Z!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
      (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint _X!
       _Y! _Z!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?X
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?Y
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/?Z
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x))
   :qid internal_curve25519_dalek__backend__serial__curve_models__CompletedPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__CompletedPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (= x (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.))
   :qid internal_curve25519_dalek__backend__serial__curve_models__CompletedPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__CompletedPoint_unbox_axiom_definition
)))
(assert
 (forall ((_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_T! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _X!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _T!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint
       _X! _Y! _Z! _T!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
      (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint _X! _Y!
       _Z! _T!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X x)
    (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?X x)
   )
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X
       (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X
     (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y x)
    (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?Y x)
   )
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y
       (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y
     (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z x)
    (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?Z x)
   )
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z
       (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z
     (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T x)
    (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/?T x)
   )
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T
       (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T
     (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= x (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x))
   :qid internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (= x (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
   :qid internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__AffineNielsPoint_unbox_axiom_definition
)))
(assert
 (forall ((_y_plus_x! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_y_minus_x!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (_xy2d! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _y_plus_x!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _y_minus_x!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _xy2d!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    ))
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint
       _y_plus_x! _y_minus_x! _xy2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint _y_plus_x!
       _y_minus_x! _xy2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
     x
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_plus_x
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
       (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
     x
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?y_minus_x
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
       (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)) (!
   (= (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
     x
    ) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/?xy2d
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
       (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= x (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
     x
   ))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (= x (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
   :qid internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__backend__serial__curve_models__ProjectiveNielsPoint_unbox_axiom_definition
)))
(assert
 (forall ((_Y_plus_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y_minus_X!
    curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_T2d! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y_plus_X!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y_minus_X!)
      TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
     )
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _T2d!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
       _Y_plus_X! _Y_minus_X! _Z! _T2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
       _Y_plus_X! _Y_minus_X! _Z! _T2d!
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_plus_X
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Y_minus_X
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?Z
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)) (
   !
   (= (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     x
    ) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/?T2d
     x
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     x
   ))
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
       (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
     (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. x)
    ) (has_type x TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   )
   :qid internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!scalar.Scalar.)) (!
   (= x (%Poly%curve25519_dalek!scalar.Scalar. (Poly%curve25519_dalek!scalar.Scalar. x)))
   :pattern ((Poly%curve25519_dalek!scalar.Scalar. x))
   :qid internal_curve25519_dalek__scalar__Scalar_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__scalar__Scalar_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!scalar.Scalar.)
    (= x (Poly%curve25519_dalek!scalar.Scalar. (%Poly%curve25519_dalek!scalar.Scalar. x)))
   )
   :pattern ((has_type x TYPE%curve25519_dalek!scalar.Scalar.))
   :qid internal_curve25519_dalek__scalar__Scalar_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__scalar__Scalar_unbox_axiom_definition
)))
(assert
 (forall ((_bytes! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _bytes!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (has_type (Poly%curve25519_dalek!scalar.Scalar. (curve25519_dalek!scalar.Scalar./Scalar
       _bytes!
      )
     ) TYPE%curve25519_dalek!scalar.Scalar.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!scalar.Scalar. (curve25519_dalek!scalar.Scalar./Scalar
       _bytes!
      )
     ) TYPE%curve25519_dalek!scalar.Scalar.
   ))
   :qid internal_curve25519_dalek!scalar.Scalar./Scalar_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!scalar.Scalar./Scalar_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!scalar.Scalar.)) (!
   (= (curve25519_dalek!scalar.Scalar./Scalar/bytes x) (curve25519_dalek!scalar.Scalar./Scalar/?bytes
     x
   ))
   :pattern ((curve25519_dalek!scalar.Scalar./Scalar/bytes x))
   :qid internal_curve25519_dalek!scalar.Scalar./Scalar/bytes_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!scalar.Scalar./Scalar/bytes_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!scalar.Scalar.)
    (has_type (Poly%array%. (curve25519_dalek!scalar.Scalar./Scalar/bytes (%Poly%curve25519_dalek!scalar.Scalar.
        x
      ))
     ) (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!scalar.Scalar./Scalar/bytes (%Poly%curve25519_dalek!scalar.Scalar.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!scalar.Scalar.)
   )
   :qid internal_curve25519_dalek!scalar.Scalar./Scalar/bytes_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!scalar.Scalar./Scalar/bytes_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= x (%Poly%curve25519_dalek!edwards.EdwardsPoint. (Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!edwards.EdwardsPoint. x))
   :qid internal_curve25519_dalek__edwards__EdwardsPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__edwards__EdwardsPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (= x (Poly%curve25519_dalek!edwards.EdwardsPoint. (%Poly%curve25519_dalek!edwards.EdwardsPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.))
   :qid internal_curve25519_dalek__edwards__EdwardsPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__edwards__EdwardsPoint_unbox_axiom_definition
)))
(assert
 (forall ((_X! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_Y! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
   (_Z! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (_T! curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  ) (!
   (=>
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _X!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Y!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _Z!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. _T!) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint
       _X! _Y! _Z! _T!
      )
     ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint
       _X! _Y! _Z! _T!
      )
     ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?X
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/X_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Y
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Y_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?Z
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/Z_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T x) (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/?T
     x
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T x))
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T
       (%Poly%curve25519_dalek!edwards.EdwardsPoint. x)
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T (%Poly%curve25519_dalek!edwards.EdwardsPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.EdwardsPoint.)
   )
   :qid internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.EdwardsPoint./EdwardsPoint/T_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!window.LookupTable.)) (!
   (= x (%Poly%curve25519_dalek!window.LookupTable. (Poly%curve25519_dalek!window.LookupTable.
      x
   )))
   :pattern ((Poly%curve25519_dalek!window.LookupTable. x))
   :qid internal_curve25519_dalek__window__LookupTable_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__window__LookupTable_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%curve25519_dalek!window.LookupTable. T&. T&))
    (= x (Poly%curve25519_dalek!window.LookupTable. (%Poly%curve25519_dalek!window.LookupTable.
       x
   ))))
   :pattern ((has_type x (TYPE%curve25519_dalek!window.LookupTable. T&. T&)))
   :qid internal_curve25519_dalek__window__LookupTable_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__window__LookupTable_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_0! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _0!) (ARRAY T&. T& $ (CONST_INT 8)))
    (has_type (Poly%curve25519_dalek!window.LookupTable. (curve25519_dalek!window.LookupTable./LookupTable
       _0!
      )
     ) (TYPE%curve25519_dalek!window.LookupTable. T&. T&)
   ))
   :pattern ((has_type (Poly%curve25519_dalek!window.LookupTable. (curve25519_dalek!window.LookupTable./LookupTable
       _0!
      )
     ) (TYPE%curve25519_dalek!window.LookupTable. T&. T&)
   ))
   :qid internal_curve25519_dalek!window.LookupTable./LookupTable_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!window.LookupTable./LookupTable_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!window.LookupTable.)) (!
   (= (curve25519_dalek!window.LookupTable./LookupTable/0 x) (curve25519_dalek!window.LookupTable./LookupTable/?0
     x
   ))
   :pattern ((curve25519_dalek!window.LookupTable./LookupTable/0 x))
   :qid internal_curve25519_dalek!window.LookupTable./LookupTable/0_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!window.LookupTable./LookupTable/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%curve25519_dalek!window.LookupTable. T&. T&))
    (has_type (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
        x
      ))
     ) (ARRAY T&. T& $ (CONST_INT 8))
   ))
   :pattern ((curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
      x
     )
    ) (has_type x (TYPE%curve25519_dalek!window.LookupTable. T&. T&))
   )
   :qid internal_curve25519_dalek!window.LookupTable./LookupTable/0_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!window.LookupTable./LookupTable/0_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!window.NafLookupTable5.)) (!
   (= x (%Poly%curve25519_dalek!window.NafLookupTable5. (Poly%curve25519_dalek!window.NafLookupTable5.
      x
   )))
   :pattern ((Poly%curve25519_dalek!window.NafLookupTable5. x))
   :qid internal_curve25519_dalek__window__NafLookupTable5_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__window__NafLookupTable5_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&))
    (= x (Poly%curve25519_dalek!window.NafLookupTable5. (%Poly%curve25519_dalek!window.NafLookupTable5.
       x
   ))))
   :pattern ((has_type x (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&)))
   :qid internal_curve25519_dalek__window__NafLookupTable5_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__window__NafLookupTable5_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (_0! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _0!) (ARRAY T&. T& $ (CONST_INT 8)))
    (has_type (Poly%curve25519_dalek!window.NafLookupTable5. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5
       _0!
      )
     ) (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&)
   ))
   :pattern ((has_type (Poly%curve25519_dalek!window.NafLookupTable5. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5
       _0!
      )
     ) (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&)
   ))
   :qid internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!window.NafLookupTable5.)) (!
   (= (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 x) (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/?0
     x
   ))
   :pattern ((curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 x))
   :qid internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&))
    (has_type (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0
       (%Poly%curve25519_dalek!window.NafLookupTable5. x)
      )
     ) (ARRAY T&. T& $ (CONST_INT 8))
   ))
   :pattern ((curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
      x
     )
    ) (has_type x (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&))
   )
   :qid internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0_invariant_definition
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
(assert
 (forall ((x tuple%1.)) (!
   (= x (%Poly%tuple%1. (Poly%tuple%1. x)))
   :pattern ((Poly%tuple%1. x))
   :qid internal_crate__tuple__1_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__1_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%1. T%0&. T%0&))
    (= x (Poly%tuple%1. (%Poly%tuple%1. x)))
   )
   :pattern ((has_type x (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_crate__tuple__1_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__1_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (_0! Poly)) (!
   (=>
    (has_type _0! T%0&)
    (has_type (Poly%tuple%1. (tuple%1./tuple%1 _0!)) (TYPE%tuple%1. T%0&. T%0&))
   )
   :pattern ((has_type (Poly%tuple%1. (tuple%1./tuple%1 _0!)) (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_tuple__1./tuple__1_constructor_definition
   :skolemid skolem_internal_tuple__1./tuple__1_constructor_definition
)))
(assert
 (forall ((x tuple%1.)) (!
   (= (tuple%1./tuple%1/0 x) (tuple%1./tuple%1/?0 x))
   :pattern ((tuple%1./tuple%1/0 x))
   :qid internal_tuple__1./tuple__1/0_accessor_definition
   :skolemid skolem_internal_tuple__1./tuple__1/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%1. T%0&. T%0&))
    (has_type (tuple%1./tuple%1/0 (%Poly%tuple%1. x)) T%0&)
   )
   :pattern ((tuple%1./tuple%1/0 (%Poly%tuple%1. x)) (has_type x (TYPE%tuple%1. T%0&. T%0&)))
   :qid internal_tuple__1./tuple__1/0_invariant_definition
   :skolemid skolem_internal_tuple__1./tuple__1/0_invariant_definition
)))
(assert
 (forall ((x tuple%1.)) (!
   (=>
    (is-tuple%1./tuple%1 x)
    (height_lt (height (tuple%1./tuple%1/0 x)) (height (Poly%tuple%1. x)))
   )
   :pattern ((height (tuple%1./tuple%1/0 x)))
   :qid prelude_datatype_height_tuple%1./tuple%1/0
   :skolemid skolem_prelude_datatype_height_tuple%1./tuple%1/0
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (deep Bool) (x Poly) (y Poly)) (!
   (=>
    (and
     (has_type x (TYPE%tuple%1. T%0&. T%0&))
     (has_type y (TYPE%tuple%1. T%0&. T%0&))
     (ext_eq deep T%0& (tuple%1./tuple%1/0 (%Poly%tuple%1. x)) (tuple%1./tuple%1/0 (%Poly%tuple%1.
        y
    ))))
    (ext_eq deep (TYPE%tuple%1. T%0&. T%0&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%1. T%0&. T%0&) x y))
   :qid internal_tuple__1./tuple__1_ext_equal_definition
   :skolemid skolem_internal_tuple__1./tuple__1_ext_equal_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= x (%Poly%tuple%2. (Poly%tuple%2. x)))
   :pattern ((Poly%tuple%2. x))
   :qid internal_crate__tuple__2_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (= x (Poly%tuple%2. (%Poly%tuple%2. x)))
   )
   :pattern ((has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&)))
   :qid internal_crate__tuple__2_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__2_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (_0! Poly) (_1! Poly)) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
    )
    (has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&. T%0& T%1&.
      T%1&
   )))
   :pattern ((has_type (Poly%tuple%2. (tuple%2./tuple%2 _0! _1!)) (TYPE%tuple%2. T%0&.
      T%0& T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2_constructor_definition
   :skolemid skolem_internal_tuple__2./tuple__2_constructor_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/0 x) (tuple%2./tuple%2/?0 x))
   :pattern ((tuple%2./tuple%2/0 x))
   :qid internal_tuple__2./tuple__2/0_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) T%0&)
   )
   :pattern ((tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/0_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/0_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (= (tuple%2./tuple%2/1 x) (tuple%2./tuple%2/?1 x))
   :pattern ((tuple%2./tuple%2/1 x))
   :qid internal_tuple__2./tuple__2/1_accessor_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
    (has_type (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) T%1&)
   )
   :pattern ((tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (has_type x (TYPE%tuple%2. T%0&. T%0&
      T%1&. T%1&
   )))
   :qid internal_tuple__2./tuple__2/1_invariant_definition
   :skolemid skolem_internal_tuple__2./tuple__2/1_invariant_definition
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/0 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/0 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/0
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/0
)))
(assert
 (forall ((x tuple%2.)) (!
   (=>
    (is-tuple%2./tuple%2 x)
    (height_lt (height (tuple%2./tuple%2/1 x)) (height (Poly%tuple%2. x)))
   )
   :pattern ((height (tuple%2./tuple%2/1 x)))
   :qid prelude_datatype_height_tuple%2./tuple%2/1
   :skolemid skolem_prelude_datatype_height_tuple%2./tuple%2/1
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (deep Bool) (x Poly) (y Poly))
  (!
   (=>
    (and
     (has_type x (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (has_type y (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&))
     (ext_eq deep T%0& (tuple%2./tuple%2/0 (%Poly%tuple%2. x)) (tuple%2./tuple%2/0 (%Poly%tuple%2.
        y
     )))
     (ext_eq deep T%1& (tuple%2./tuple%2/1 (%Poly%tuple%2. x)) (tuple%2./tuple%2/1 (%Poly%tuple%2.
        y
    ))))
    (ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%2. T%0&. T%0& T%1&. T%1&) x y))
   :qid internal_tuple__2./tuple__2_ext_equal_definition
   :skolemid skolem_internal_tuple__2./tuple__2_ext_equal_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= x (%Poly%tuple%3. (Poly%tuple%3. x)))
   :pattern ((Poly%tuple%3. x))
   :qid internal_crate__tuple__3_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__3_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (= x (Poly%tuple%3. (%Poly%tuple%3. x)))
   )
   :pattern ((has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&)))
   :qid internal_crate__tuple__3_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__3_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (_0!
    Poly
   ) (_1! Poly) (_2! Poly)
  ) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
     (has_type _2! T%2&)
    )
    (has_type (Poly%tuple%3. (tuple%3./tuple%3 _0! _1! _2!)) (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :pattern ((has_type (Poly%tuple%3. (tuple%3./tuple%3 _0! _1! _2!)) (TYPE%tuple%3. T%0&.
      T%0& T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3_constructor_definition
   :skolemid skolem_internal_tuple__3./tuple__3_constructor_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/0 x) (tuple%3./tuple%3/?0 x))
   :pattern ((tuple%3./tuple%3/0 x))
   :qid internal_tuple__3./tuple__3/0_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/0 (%Poly%tuple%3. x)) T%0&)
   )
   :pattern ((tuple%3./tuple%3/0 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/0_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/0_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/1 x) (tuple%3./tuple%3/?1 x))
   :pattern ((tuple%3./tuple%3/1 x))
   :qid internal_tuple__3./tuple__3/1_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/1 (%Poly%tuple%3. x)) T%1&)
   )
   :pattern ((tuple%3./tuple%3/1 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/1_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/1_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (= (tuple%3./tuple%3/2 x) (tuple%3./tuple%3/?2 x))
   :pattern ((tuple%3./tuple%3/2 x))
   :qid internal_tuple__3./tuple__3/2_accessor_definition
   :skolemid skolem_internal_tuple__3./tuple__3/2_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (x
    Poly
   )
  ) (!
   (=>
    (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
    (has_type (tuple%3./tuple%3/2 (%Poly%tuple%3. x)) T%2&)
   )
   :pattern ((tuple%3./tuple%3/2 (%Poly%tuple%3. x)) (has_type x (TYPE%tuple%3. T%0&. T%0&
      T%1&. T%1& T%2&. T%2&
   )))
   :qid internal_tuple__3./tuple__3/2_invariant_definition
   :skolemid skolem_internal_tuple__3./tuple__3/2_invariant_definition
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/0 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/0 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/0
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/0
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/1 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/1 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/1
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/1
)))
(assert
 (forall ((x tuple%3.)) (!
   (=>
    (is-tuple%3./tuple%3 x)
    (height_lt (height (tuple%3./tuple%3/2 x)) (height (Poly%tuple%3. x)))
   )
   :pattern ((height (tuple%3./tuple%3/2 x)))
   :qid prelude_datatype_height_tuple%3./tuple%3/2
   :skolemid skolem_prelude_datatype_height_tuple%3./tuple%3/2
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (deep
    Bool
   ) (x Poly) (y Poly)
  ) (!
   (=>
    (and
     (has_type x (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (has_type y (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&))
     (ext_eq deep T%0& (tuple%3./tuple%3/0 (%Poly%tuple%3. x)) (tuple%3./tuple%3/0 (%Poly%tuple%3.
        y
     )))
     (ext_eq deep T%1& (tuple%3./tuple%3/1 (%Poly%tuple%3. x)) (tuple%3./tuple%3/1 (%Poly%tuple%3.
        y
     )))
     (ext_eq deep T%2& (tuple%3./tuple%3/2 (%Poly%tuple%3. x)) (tuple%3./tuple%3/2 (%Poly%tuple%3.
        y
    ))))
    (ext_eq deep (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%3. T%0&. T%0& T%1&. T%1& T%2&. T%2&) x y))
   :qid internal_tuple__3./tuple__3_ext_equal_definition
   :skolemid skolem_internal_tuple__3./tuple__3_ext_equal_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= x (%Poly%tuple%4. (Poly%tuple%4. x)))
   :pattern ((Poly%tuple%4. x))
   :qid internal_crate__tuple__4_box_axiom_definition
   :skolemid skolem_internal_crate__tuple__4_box_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (= x (Poly%tuple%4. (%Poly%tuple%4. x)))
   )
   :pattern ((has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&)))
   :qid internal_crate__tuple__4_unbox_axiom_definition
   :skolemid skolem_internal_crate__tuple__4_unbox_axiom_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (_0! Poly) (_1! Poly) (_2! Poly) (_3! Poly)
  ) (!
   (=>
    (and
     (has_type _0! T%0&)
     (has_type _1! T%1&)
     (has_type _2! T%2&)
     (has_type _3! T%3&)
    )
    (has_type (Poly%tuple%4. (tuple%4./tuple%4 _0! _1! _2! _3!)) (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :pattern ((has_type (Poly%tuple%4. (tuple%4./tuple%4 _0! _1! _2! _3!)) (TYPE%tuple%4.
      T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4_constructor_definition
   :skolemid skolem_internal_tuple__4./tuple__4_constructor_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/0 x) (tuple%4./tuple%4/?0 x))
   :pattern ((tuple%4./tuple%4/0 x))
   :qid internal_tuple__4./tuple__4/0_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/0_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/0 (%Poly%tuple%4. x)) T%0&)
   )
   :pattern ((tuple%4./tuple%4/0 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/0_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/0_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/1 x) (tuple%4./tuple%4/?1 x))
   :pattern ((tuple%4./tuple%4/1 x))
   :qid internal_tuple__4./tuple__4/1_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/1_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/1 (%Poly%tuple%4. x)) T%1&)
   )
   :pattern ((tuple%4./tuple%4/1 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/1_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/1_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/2 x) (tuple%4./tuple%4/?2 x))
   :pattern ((tuple%4./tuple%4/2 x))
   :qid internal_tuple__4./tuple__4/2_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/2_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/2 (%Poly%tuple%4. x)) T%2&)
   )
   :pattern ((tuple%4./tuple%4/2 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/2_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/2_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (= (tuple%4./tuple%4/3 x) (tuple%4./tuple%4/?3 x))
   :pattern ((tuple%4./tuple%4/3 x))
   :qid internal_tuple__4./tuple__4/3_accessor_definition
   :skolemid skolem_internal_tuple__4./tuple__4/3_accessor_definition
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (x Poly)
  ) (!
   (=>
    (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
    (has_type (tuple%4./tuple%4/3 (%Poly%tuple%4. x)) T%3&)
   )
   :pattern ((tuple%4./tuple%4/3 (%Poly%tuple%4. x)) (has_type x (TYPE%tuple%4. T%0&. T%0&
      T%1&. T%1& T%2&. T%2& T%3&. T%3&
   )))
   :qid internal_tuple__4./tuple__4/3_invariant_definition
   :skolemid skolem_internal_tuple__4./tuple__4/3_invariant_definition
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/0 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/0 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/0
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/0
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/1 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/1 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/1
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/1
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/2 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/2 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/2
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/2
)))
(assert
 (forall ((x tuple%4.)) (!
   (=>
    (is-tuple%4./tuple%4 x)
    (height_lt (height (tuple%4./tuple%4/3 x)) (height (Poly%tuple%4. x)))
   )
   :pattern ((height (tuple%4./tuple%4/3 x)))
   :qid prelude_datatype_height_tuple%4./tuple%4/3
   :skolemid skolem_prelude_datatype_height_tuple%4./tuple%4/3
)))
(assert
 (forall ((T%0&. Dcr) (T%0& Type) (T%1&. Dcr) (T%1& Type) (T%2&. Dcr) (T%2& Type) (T%3&.
    Dcr
   ) (T%3& Type) (deep Bool) (x Poly) (y Poly)
  ) (!
   (=>
    (and
     (has_type x (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
     (has_type y (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&))
     (ext_eq deep T%0& (tuple%4./tuple%4/0 (%Poly%tuple%4. x)) (tuple%4./tuple%4/0 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%1& (tuple%4./tuple%4/1 (%Poly%tuple%4. x)) (tuple%4./tuple%4/1 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%2& (tuple%4./tuple%4/2 (%Poly%tuple%4. x)) (tuple%4./tuple%4/2 (%Poly%tuple%4.
        y
     )))
     (ext_eq deep T%3& (tuple%4./tuple%4/3 (%Poly%tuple%4. x)) (tuple%4./tuple%4/3 (%Poly%tuple%4.
        y
    ))))
    (ext_eq deep (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&) x y)
   )
   :pattern ((ext_eq deep (TYPE%tuple%4. T%0&. T%0& T%1&. T%1& T%2&. T%2& T%3&. T%3&)
     x y
   ))
   :qid internal_tuple__4./tuple__4_ext_equal_definition
   :skolemid skolem_internal_tuple__4./tuple__4_ext_equal_definition
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
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!clone.Clone. Self%&. Self%&)
    (sized Self%&.)
   )
   :pattern ((tr_bound%core!clone.Clone. Self%&. Self%&))
   :qid internal_core__clone__Clone_trait_type_bounds_definition
   :skolemid skolem_internal_core__clone__Clone_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   true
   :pattern ((tr_bound%core!cmp.PartialEq. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__cmp__PartialEq_trait_type_bounds_definition
   :skolemid skolem_internal_core__cmp__PartialEq_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!cmp.Eq. Self%&. Self%&)
    (tr_bound%core!cmp.PartialEq. Self%&. Self%& Self%&. Self%&)
   )
   :pattern ((tr_bound%core!cmp.Eq. Self%&. Self%&))
   :qid internal_core__cmp__Eq_trait_type_bounds_definition
   :skolemid skolem_internal_core__cmp__Eq_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!cmp.PartialOrd. Self%&. Self%& Rhs&. Rhs&)
    (tr_bound%core!cmp.PartialEq. Self%&. Self%& Rhs&. Rhs&)
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__cmp__PartialOrd_trait_type_bounds_definition
   :skolemid skolem_internal_core__cmp__PartialOrd_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!cmp.Ord. Self%&. Self%&)
    (and
     (tr_bound%core!cmp.Eq. Self%&. Self%&)
     (tr_bound%core!cmp.PartialOrd. Self%&. Self%& Self%&. Self%&)
   ))
   :pattern ((tr_bound%core!cmp.Ord. Self%&. Self%&))
   :qid internal_core__cmp__Ord_trait_type_bounds_definition
   :skolemid skolem_internal_core__cmp__Ord_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.cmp.OrdSpec. Self%&. Self%&)
    (and
     (tr_bound%core!cmp.Eq. Self%&. Self%&)
     (tr_bound%core!cmp.PartialOrd. Self%&. Self%& Self%&. Self%&)
     (tr_bound%core!cmp.Ord. Self%&. Self%&)
   ))
   :pattern ((tr_bound%vstd!std_specs.cmp.OrdSpec. Self%&. Self%&))
   :qid internal_vstd__std_specs__cmp__OrdSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__cmp__OrdSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%core!convert.From. Self%&. Self%& T&. T&)
    (and
     (sized Self%&.)
     (sized T&.)
   ))
   :pattern ((tr_bound%core!convert.From. Self%&. Self%& T&. T&))
   :qid internal_core__convert__From_trait_type_bounds_definition
   :skolemid skolem_internal_core__convert__From_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.convert.FromSpec. Self%&. Self%& T&. T&)
    (and
     (sized Self%&.)
     (tr_bound%core!convert.From. Self%&. Self%& T&. T&)
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.convert.FromSpec. Self%&. Self%& T&. T&))
   :qid internal_vstd__std_specs__convert__FromSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__convert__FromSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%core!alloc.Allocator. Self%&. Self%&))
   :qid internal_core__alloc__Allocator_trait_type_bounds_definition
   :skolemid skolem_internal_core__alloc__Allocator_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!iter.traits.iterator.Iterator. Self%&. Self%&)
    (sized (proj%%core!iter.traits.iterator.Iterator./Item Self%&. Self%&))
   )
   :pattern ((tr_bound%core!iter.traits.iterator.Iterator. Self%&. Self%&))
   :qid internal_core__iter__traits__iterator__Iterator_trait_type_bounds_definition
   :skolemid skolem_internal_core__iter__traits__iterator__Iterator_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Borrowed&. Dcr) (Borrowed& Type)) (!
   true
   :pattern ((tr_bound%core!borrow.Borrow. Self%&. Self%& Borrowed&. Borrowed&))
   :qid internal_core__borrow__Borrow_trait_type_bounds_definition
   :skolemid skolem_internal_core__borrow__Borrow_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&)
    (and
     (sized Rhs&.)
     (sized (proj%%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&))
   ))
   :pattern ((tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__ops__arith__Add_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__arith__Add_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.ops.AddSpec. Self%&. Self%& Rhs&. Rhs&)
    (and
     (tr_bound%core!ops.arith.Add. Self%&. Self%& Rhs&. Rhs&)
     (sized Rhs&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.ops.AddSpec. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd__std_specs__ops__AddSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__ops__AddSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Sub. Self%&. Self%& Rhs&. Rhs&)
    (and
     (sized Rhs&.)
     (sized (proj%%core!ops.arith.Sub./Output Self%&. Self%& Rhs&. Rhs&))
   ))
   :pattern ((tr_bound%core!ops.arith.Sub. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_core__ops__arith__Sub_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__arith__Sub_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.ops.SubSpec. Self%&. Self%& Rhs&. Rhs&)
    (and
     (tr_bound%core!ops.arith.Sub. Self%&. Self%& Rhs&. Rhs&)
     (sized Rhs&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.ops.SubSpec. Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd__std_specs__ops__SubSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__ops__SubSpec_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.option.OptionAdditionalFns. Self%&. Self%& T&. T&)
    (and
     (sized Self%&.)
     (sized T&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.option.OptionAdditionalFns. Self%&. Self%& T&. T&))
   :qid internal_vstd__std_specs__option__OptionAdditionalFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__option__OptionAdditionalFns_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%curve25519_dalek!traits.Identity. Self%&. Self%&))
   :qid internal_curve25519_dalek__traits__Identity_trait_type_bounds_definition
   :skolemid skolem_internal_curve25519_dalek__traits__Identity_trait_type_bounds_definition
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
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)) $)
   :pattern ((proj%%vstd!view.View./V $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)) (TYPE%vstd!seq.Seq.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)) $)
   :pattern ((proj%%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)) (TYPE%core!option.Option.
     T&. T&
   ))
   :pattern ((proj%vstd!view.View./V $ (TYPE%core!option.Option. T&. T&)))
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
 (= (proj%%vstd!view.View./V $ (UINT 16)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 16)) (UINT 16))
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
 (= (proj%%vstd!view.View./V $ (UINT 128)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%vstd!view.View./V $ USIZE) $)
)
(assert
 (= (proj%vstd!view.View./V $ USIZE) USIZE)
)
(assert
 (= (proj%%vstd!view.View./V $ (SINT 8)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%vstd!view.View./V $ (SINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 32)) (SINT 32))
)
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (= (proj%%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)) (DST (proj%%vstd!view.View./V
      A0&. A0&
   )))
   :pattern ((proj%%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (= (proj%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)) (TYPE%tuple%1. (proj%%vstd!view.View./V
      A0&. A0&
     ) (proj%vstd!view.View./V A0&. A0&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (DST (proj%%vstd!view.View./V
      A1&. A1&
   )))
   :pattern ((proj%%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (= (proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)) (TYPE%tuple%2.
     (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&) (proj%%vstd!view.View./V
      A1&. A1&
     ) (proj%vstd!view.View./V A1&. A1&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (= (proj%%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
    (DST (proj%%vstd!view.View./V A2&. A2&))
   )
   :pattern ((proj%%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&.
      A2&
   )))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (= (proj%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
    (TYPE%tuple%3. (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&)
     (proj%%vstd!view.View./V A1&. A1&) (proj%vstd!view.View./V A1&. A1&) (proj%%vstd!view.View./V
      A2&. A2&
     ) (proj%vstd!view.View./V A2&. A2&)
   ))
   :pattern ((proj%vstd!view.View./V (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&)))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (= (proj%%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
     )
    ) (DST (proj%%vstd!view.View./V A3&. A3&))
   )
   :pattern ((proj%%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&.
      A2& A3&. A3&
   )))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (= (proj%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
     )
    ) (TYPE%tuple%4. (proj%%vstd!view.View./V A0&. A0&) (proj%vstd!view.View./V A0&. A0&)
     (proj%%vstd!view.View./V A1&. A1&) (proj%vstd!view.View./V A1&. A1&) (proj%%vstd!view.View./V
      A2&. A2&
     ) (proj%vstd!view.View./V A2&. A2&) (proj%%vstd!view.View./V A3&. A3&) (proj%vstd!view.View./V
      A3&. A3&
   )))
   :pattern ((proj%vstd!view.View./V (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2&
      A3&. A3&
   )))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 16) $ (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 16) $ (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 16) (REF $) (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 16) (REF $) (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 128) $ (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 128) $ (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (UINT 128) (REF $) (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (UINT 128) (REF $) (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 8) $ (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 8) $ (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 8) (REF $) (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 8) (REF $) (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 16) $ (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 16) $ (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 16) (REF $) (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 16) (REF $) (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 128) $ (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 128) $ (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (UINT 128) (REF $) (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (UINT 128) (REF $) (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 8) $ (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 8) $ (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 8) (REF $) (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 8) (REF $) (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output $ (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Add./Output $ (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 16) $ (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 16) $ (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 16) (REF $) (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 16) (REF $) (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 128) $ (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 128) $ (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (UINT 128) (REF $) (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (UINT 128) (REF $) (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (SINT 8) $ (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (SINT 8) $ (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (SINT 8) (REF $) (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (SINT 8) (REF $) (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ USIZE $ USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ USIZE $ USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ USIZE (REF $) USIZE) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ USIZE (REF $) USIZE) USIZE)
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 8) $ (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 8) $ (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 8) (REF $) (UINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 8) (REF $) (UINT 8)) (UINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 16) $ (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 16) $ (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 16) (REF $) (UINT 16)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 16) (REF $) (UINT 16)) (UINT 16))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 32) $ (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 32) $ (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 32) (REF $) (UINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 32) (REF $) (UINT 32)) (UINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 64) $ (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 64) $ (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 64) (REF $) (UINT 64)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 64) (REF $) (UINT 64)) (UINT 64))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 128) $ (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 128) $ (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (UINT 128) (REF $) (UINT 128)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (UINT 128) (REF $) (UINT 128)) (UINT 128))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (SINT 8) $ (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (SINT 8) $ (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (SINT 8) (REF $) (SINT 8)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (SINT 8) (REF $) (SINT 8)) (SINT 8))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (SINT 32) $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (SINT 32) $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Sub./Output $ (SINT 32) (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Sub./Output $ (SINT 32) (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!scalar.Scalar. (
    REF $
   ) TYPE%curve25519_dalek!scalar.Scalar.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!scalar.Scalar. (REF
    $
   ) TYPE%curve25519_dalek!scalar.Scalar.
  ) TYPE%curve25519_dalek!scalar.Scalar.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!scalar.Scalar. (
    REF $
   ) TYPE%curve25519_dalek!scalar.Scalar.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!scalar.Scalar. (REF
    $
   ) TYPE%curve25519_dalek!scalar.Scalar.
  ) TYPE%curve25519_dalek!scalar.Scalar.
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  ) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  ) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  ) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  ) TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!scalar.Scalar. $
   TYPE%curve25519_dalek!scalar.Scalar.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!scalar.Scalar. $
   TYPE%curve25519_dalek!scalar.Scalar.
  ) TYPE%curve25519_dalek!scalar.Scalar.
))
(assert
 (= (proj%%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))
(assert
 (= (proj%%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!scalar.Scalar. (REF $)
   TYPE%curve25519_dalek!scalar.Scalar.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!scalar.Scalar. (REF $)
   TYPE%curve25519_dalek!scalar.Scalar.
  ) TYPE%curve25519_dalek!scalar.Scalar.
))
(assert
 (= (proj%%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!scalar.Scalar. $ TYPE%curve25519_dalek!scalar.Scalar.)
  $
))
(assert
 (= (proj%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!scalar.Scalar. $ TYPE%curve25519_dalek!scalar.Scalar.)
  TYPE%curve25519_dalek!scalar.Scalar.
))
(assert
 (= (proj%%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (
    REF $
   ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))
(assert
 (= (proj%%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
   $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Add./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $
   TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!scalar.Scalar. $
   TYPE%curve25519_dalek!scalar.Scalar.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!scalar.Scalar. $
   TYPE%curve25519_dalek!scalar.Scalar.
  ) TYPE%curve25519_dalek!scalar.Scalar.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output $ TYPE%curve25519_dalek!scalar.Scalar. (REF $)
   TYPE%curve25519_dalek!scalar.Scalar.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output $ TYPE%curve25519_dalek!scalar.Scalar. (REF $)
   TYPE%curve25519_dalek!scalar.Scalar.
  ) TYPE%curve25519_dalek!scalar.Scalar.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output $ TYPE%curve25519_dalek!scalar.Scalar. $ TYPE%curve25519_dalek!scalar.Scalar.)
  $
))
(assert
 (= (proj%core!ops.arith.Sub./Output $ TYPE%curve25519_dalek!scalar.Scalar. $ TYPE%curve25519_dalek!scalar.Scalar.)
  TYPE%curve25519_dalek!scalar.Scalar.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
   (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (
    REF $
   ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))
(assert
 (= (proj%%core!ops.arith.Sub./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
   $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) $
))
(assert
 (= (proj%core!ops.arith.Sub./Output $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $
   TYPE%curve25519_dalek!edwards.EdwardsPoint.
  ) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

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

;; Function-Decl vstd::std_specs::vec::spec_vec_len
(declare-fun vstd!std_specs.vec.spec_vec_len.? (Dcr Type Dcr Type Poly) Int)

;; Function-Decl vstd::std_specs::cmp::OrdSpec::obeys_cmp_spec
(declare-fun vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? (Dcr Type) Poly)
(declare-fun vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec%default%.? (Dcr Type) Poly)

;; Function-Decl vstd::std_specs::cmp::OrdSpec::cmp_spec
(declare-fun vstd!std_specs.cmp.OrdSpec.cmp_spec.? (Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.cmp.OrdSpec.cmp_spec%default%.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::std_specs::convert::FromSpec::obeys_from_spec
(declare-fun vstd!std_specs.convert.FromSpec.obeys_from_spec.? (Dcr Type Dcr Type)
 Poly
)
(declare-fun vstd!std_specs.convert.FromSpec.obeys_from_spec%default%.? (Dcr Type Dcr
  Type
 ) Poly
)

;; Function-Decl vstd::std_specs::convert::FromSpec::from_spec
(declare-fun vstd!std_specs.convert.FromSpec.from_spec.? (Dcr Type Dcr Type Poly)
 Poly
)
(declare-fun vstd!std_specs.convert.FromSpec.from_spec%default%.? (Dcr Type Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::AddSpec::add_req
(declare-fun vstd!std_specs.ops.AddSpec.add_req.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.add_req%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::AddSpec::obeys_add_spec
(declare-fun vstd!std_specs.ops.AddSpec.obeys_add_spec.? (Dcr Type Dcr Type) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.obeys_add_spec%default%.? (Dcr Type Dcr Type)
 Poly
)

;; Function-Decl vstd::std_specs::ops::AddSpec::add_spec
(declare-fun vstd!std_specs.ops.AddSpec.add_spec.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.AddSpec.add_spec%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::SubSpec::sub_req
(declare-fun vstd!std_specs.ops.SubSpec.sub_req.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.SubSpec.sub_req%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::ops::SubSpec::obeys_sub_spec
(declare-fun vstd!std_specs.ops.SubSpec.obeys_sub_spec.? (Dcr Type Dcr Type) Poly)
(declare-fun vstd!std_specs.ops.SubSpec.obeys_sub_spec%default%.? (Dcr Type Dcr Type)
 Poly
)

;; Function-Decl vstd::std_specs::ops::SubSpec::sub_spec
(declare-fun vstd!std_specs.ops.SubSpec.sub_spec.? (Dcr Type Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.ops.SubSpec.sub_spec%default%.? (Dcr Type Dcr Type Poly
  Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::option::OptionAdditionalFns::arrow_0
(declare-fun vstd!std_specs.option.OptionAdditionalFns.arrow_0.? (Dcr Type Dcr Type
  Poly
 ) Poly
)
(declare-fun vstd!std_specs.option.OptionAdditionalFns.arrow_0%default%.? (Dcr Type
  Dcr Type Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::option::is_some
(declare-fun vstd!std_specs.option.is_some.? (Dcr Type Poly) Bool)

;; Function-Decl vstd::std_specs::option::spec_unwrap
(declare-fun vstd!std_specs.option.spec_unwrap.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::pervasive::arbitrary
(declare-fun vstd!pervasive.arbitrary.? (Dcr Type) Poly)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::p
(declare-fun curve25519_dalek!specs.field_specs_u64.p.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::field_canonical
(declare-fun curve25519_dalek!specs.field_specs_u64.field_canonical.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_field_canonical
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_canonical_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_x
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_x.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_y
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_y.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_z
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_z.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_t
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_t.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_as_nat
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? (Poly) tuple%4.)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_gcd
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?
 (Poly Poly) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
 (Poly Poly Fuel) Int
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_extended_gcd
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
 (Poly Poly) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
 (Poly Poly Fuel) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(declare-fun curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
 (Poly Poly) Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::field_inv
(declare-fun curve25519_dalek!specs.field_specs.field_inv.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_mul
(declare-fun curve25519_dalek!specs.field_specs.field_mul.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_as_affine
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::specs::field_specs::u64_5_bounded
(declare-fun curve25519_dalek!specs.field_specs.u64_5_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::field_specs::field_neg
(declare-fun curve25519_dalek!specs.field_specs.field_neg.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::mask51
(declare-fun curve25519_dalek!specs.field_specs_u64.mask51.? () Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::spec_reduce
(declare-fun curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::sixteen_p_vec
(declare-fun curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.? () %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::pre_reduce_limbs
(declare-fun curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::spec_negate
(declare-fun curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::edwards_specs::negate_projective_niels
(declare-fun curve25519_dalek!specs.edwards_specs.negate_projective_niels.? (Poly)
 curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
)

;; Function-Decl curve25519_dalek::specs::iterator_specs::spec_scalars_from_iter
(declare-fun curve25519_dalek!specs.iterator_specs.spec_scalars_from_iter.? (Dcr Type
  Dcr Type Poly
 ) vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
)

;; Function-Decl curve25519_dalek::specs::iterator_specs::spec_optional_points_from_iter
(declare-fun curve25519_dalek!specs.iterator_specs.spec_optional_points_from_iter.?
 (Dcr Type Poly) vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
)

;; Function-Decl curve25519_dalek::specs::iterator_specs::spec_points_from_iter
(declare-fun curve25519_dalek!specs.iterator_specs.spec_points_from_iter.? (Dcr Type
  Dcr Type Poly
 ) vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
)

;; Function-Decl curve25519_dalek::specs::core_specs::u8_32_as_nat
(declare-fun curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::group_order
(declare-fun curve25519_dalek!specs.scalar52_specs.group_order.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar_specs::is_canonical_scalar
(declare-fun curve25519_dalek!specs.scalar_specs.is_canonical_scalar.? (Poly) Bool)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::EDWARDS_D
(declare-fun curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.? () curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::field_specs::field_square
(declare-fun curve25519_dalek!specs.field_specs.field_square.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_sub
(declare-fun curve25519_dalek!specs.field_specs.field_sub.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_add
(declare-fun curve25519_dalek!specs.field_specs.field_add.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_on_edwards_curve_projective
(declare-fun curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?
 (Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_extended_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?
 (Poly Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_point_limbs_bounded
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::field_specs::sum_of_limbs_bounded
(declare-fun curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_well_formed_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_identity
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_identity.? (Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_add
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_add.? (Poly Poly Poly Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_double
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_double.? (Poly Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_scalar_mul
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly Poly)
 tuple%2.
)
(declare-fun curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? (Poly Poly
  Fuel
 ) tuple%2.
)

;; Function-Decl vstd::seq::impl&%0::skip
(declare-fun vstd!seq.impl&%0.skip.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq_lib::impl&%0::map
(declare-fun vstd!seq_lib.impl&%0.map.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_add_fe51_limbs
(declare-fun curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? (Poly Poly)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_sub_limbs
(declare-fun curve25519_dalek!specs.field_specs.spec_sub_limbs.? (Poly Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_scalar_mul_signed
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly
  Poly
 ) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_niels_point_as_affine_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::scalar_specs::is_valid_radix_2w
(declare-fun curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.? (Poly Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_niels_corresponds_to_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_projective_niels_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_sub
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_sub.? (Poly Poly Poly Poly)
 tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_column_sum
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
 (Poly Poly Poly Poly) tuple%2.
)
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
 (Poly Poly Poly Poly Fuel) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_ct_partial
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_partial.?
 (Poly Poly Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_vt_partial
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_partial.?
 (Poly Poly Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::radix_16_all_bounded_seq
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.radix_16_all_bounded_seq.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::scalar_specs::is_valid_naf
(declare-fun curve25519_dalek!specs.scalar_specs.is_valid_naf.? (Poly Poly) Bool)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table5_projective
(declare-fun curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::naf_lookup_table5_projective_limbs_bounded
(declare-fun curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_vt_input_valid
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_input_valid.?
 (Poly Poly Poly Poly Poly Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_lookup_table_projective
(declare-fun curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.?
 (Dcr Type Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::lookup_table_projective_limbs_bounded
(declare-fun curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.?
 (Dcr Type Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::scalar_specs::radix_16_digit_bounded
(declare-fun curve25519_dalek!specs.scalar_specs.radix_16_digit_bounded.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::scalar_specs::radix_16_all_bounded
(declare-fun curve25519_dalek!specs.scalar_specs.radix_16_all_bounded.? (Poly) Bool)

;; Function-Decl curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_ct_input_valid
(declare-fun curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_input_valid.?
 (Poly Poly Poly Poly Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_z_sum_bounded
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::edwards_specs::affine_niels_corresponds_to_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_affine_niels_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::affine_niels_point_as_affine_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_lookup_table_affine_coords
(declare-fun curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.?
 (Dcr Type Poly Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::lookup_table_affine_limbs_bounded
(declare-fun curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.?
 (Dcr Type Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_on_edwards_curve
(declare-fun curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_identity_edwards_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::completed_point_as_nat
(declare-fun curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? (Poly)
 tuple%4.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::completed_point_as_affine_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_point_edwards_as_nat
(declare-fun curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?
 (Poly) tuple%3.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::identity_projective_point_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?
 (Poly) curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_point_as_affine_edwards
(declare-fun curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?
 (Poly) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::identity_affine_niels
(declare-fun curve25519_dalek!specs.edwards_specs.identity_affine_niels.? (Poly) curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::identity_projective_niels
(declare-fun curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (Poly)
 curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::edwards_neg
(declare-fun curve25519_dalek!specs.edwards_specs.edwards_neg.? (Poly) tuple%2.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_completed_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::is_valid_projective_point
(declare-fun curve25519_dalek!specs.edwards_specs.is_valid_projective_point.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::completed_to_projective
(declare-fun curve25519_dalek!specs.edwards_specs.completed_to_projective.? (Poly)
 tuple%3.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::completed_to_extended
(declare-fun curve25519_dalek!specs.edwards_specs.completed_to_extended.? (Poly) tuple%4.)

;; Function-Decl curve25519_dalek::specs::edwards_specs::projective_to_extended
(declare-fun curve25519_dalek!specs.edwards_specs.projective_to_extended.? (Poly)
 tuple%4.
)

;; Function-Decl curve25519_dalek::specs::scalar_specs::scalar_as_nat
(declare-fun curve25519_dalek!specs.scalar_specs.scalar_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::edwards_specs::sum_of_scalar_muls
(declare-fun curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? (Poly Poly)
 tuple%2.
)
(declare-fun curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? (Poly Poly
  Fuel
 ) tuple%2.
)

;; Function-Decl curve25519_dalek::specs::edwards_specs::points_to_affine
(declare-fun curve25519_dalek!specs.edwards_specs.points_to_affine.? (Poly) vstd!seq.Seq<tuple%2<nat./nat.>.>.)

;; Function-Decl curve25519_dalek::specs::field_specs::fe51_as_nat
(declare-fun curve25519_dalek!specs.field_specs.fe51_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::iterator_specs::all_points_some
(declare-fun curve25519_dalek!specs.iterator_specs.all_points_some.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::iterator_specs::unwrap_points
(declare-fun curve25519_dalek!specs.iterator_specs.unwrap_points.? (Poly) vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::group_canonical
(declare-fun curve25519_dalek!specs.scalar52_specs.group_canonical.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar_specs::u8_32_as_group_canonical
(declare-fun curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::scalar_specs::scalar_as_canonical
(declare-fun curve25519_dalek!specs.scalar_specs.scalar_as_canonical.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar_specs::reconstruct
(declare-fun curve25519_dalek!specs.scalar_specs.reconstruct.? (Poly) Int)
(declare-fun curve25519_dalek!specs.scalar_specs.rec%reconstruct.? (Poly Fuel) Int)

;; Function-Decl curve25519_dalek::specs::scalar_specs::reconstruct_radix_2w
(declare-fun curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.? (Poly Poly)
 Int
)
(declare-fun curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? (Poly Poly
  Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::specs::scalar_specs::reconstruct_radix_16
(declare-fun curve25519_dalek!specs.scalar_specs.reconstruct_radix_16.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar_specs::is_valid_radix_16
(declare-fun curve25519_dalek!specs.scalar_specs.is_valid_radix_16.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_lookup_table_affine
(declare-fun curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.? (Dcr
  Type Poly Poly Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::naf_lookup_table5_affine_limbs_bounded
(declare-fun curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table5_affine
(declare-fun curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.?
 (Poly Poly) Bool
)

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

;; Function-Axioms vstd::std_specs::vec::spec_vec_len
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (v! Poly)) (!
   (=>
    (has_type v! (TYPE%alloc!vec.Vec. T&. T& A&. A&))
    (uInv SZ (vstd!std_specs.vec.spec_vec_len.? T&. T& A&. A& v!))
   )
   :pattern ((vstd!std_specs.vec.spec_vec_len.? T&. T& A&. A& v!))
   :qid internal_vstd!std_specs.vec.spec_vec_len.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.vec.spec_vec_len.?_pre_post_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized A&.)
     (tr_bound%core!alloc.Allocator. A&. A&)
    )
    (tr_bound%vstd!view.View. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)))
   :qid internal_vstd__view__impl&__8_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__8_trait_impl_definition
)))

;; Broadcast vstd::std_specs::vec::axiom_spec_len
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.vec.axiom_spec_len.)
  (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (v! Poly)) (!
    (=>
     (has_type v! (TYPE%alloc!vec.Vec. T&. T& A&. A&))
     (=>
      (and
       (and
        (sized T&.)
        (sized A&.)
       )
       (tr_bound%core!alloc.Allocator. A&. A&)
      )
      (= (vstd!std_specs.vec.spec_vec_len.? T&. T& A&. A& v!) (vstd!seq.Seq.len.? T&. T&
        (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) v!)
    ))))
    :pattern ((vstd!std_specs.vec.spec_vec_len.? T&. T& A&. A& v!))
    :qid user_vstd__std_specs__vec__axiom_spec_len_27
    :skolemid skolem_user_vstd__std_specs__vec__axiom_spec_len_27
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!alloc.Allocator. $ ALLOCATOR_GLOBAL)
)

;; Broadcast vstd::std_specs::vec::axiom_vec_has_resolved
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.vec.axiom_vec_has_resolved.)
  (forall ((T&. Dcr) (T& Type) (vec! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type vec! (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL))
      (has_type i! INT)
     )
     (=>
      (sized T&.)
      (=>
       (let
        ((tmp%%$ (%I i!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!std_specs.vec.spec_vec_len.? T&. T& $ ALLOCATOR_GLOBAL vec!))
       ))
       (=>
        (has_resolved $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL) vec!)
        (has_resolved T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
            T&. T& $ ALLOCATOR_GLOBAL
           ) vec!
          ) i!
    ))))))
    :pattern ((has_resolved $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL) vec!) (vstd!seq.Seq.index.?
      T&. T& (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL) vec!)
      i!
    ))
    :qid user_vstd__std_specs__vec__axiom_vec_has_resolved_28
    :skolemid skolem_user_vstd__std_specs__vec__axiom_vec_has_resolved_28
))))

;; Function-Axioms vstd::std_specs::cmp::OrdSpec::obeys_cmp_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (has_type (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? Self%&. Self%&) BOOL)
   :pattern ((vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? Self%&. Self%&))
   :qid internal_vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::cmp::OrdSpec::cmp_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (other! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type other! Self%&)
    )
    (has_type (vstd!std_specs.cmp.OrdSpec.cmp_spec.? Self%&. Self%& self! other!) TYPE%core!cmp.Ordering.)
   )
   :pattern ((vstd!std_specs.cmp.OrdSpec.cmp_spec.? Self%&. Self%& self! other!))
   :qid internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_pre_post_definition
)))

;; Function-Specs core::cmp::Ord::cmp
(declare-fun ens%core!cmp.Ord.cmp. (Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (other! Poly) (r! Poly)) (!
   (= (ens%core!cmp.Ord.cmp. Self%&. Self%& self! other! r!) (and
     (has_type r! TYPE%core!cmp.Ordering.)
     (=>
      (%B (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? Self%&. Self%&))
      (= r! (vstd!std_specs.cmp.OrdSpec.cmp_spec.? Self%&. Self%& self! other!))
   )))
   :pattern ((ens%core!cmp.Ord.cmp. Self%&. Self%& self! other! r!))
   :qid internal_ens__core!cmp.Ord.cmp._definition
   :skolemid skolem_internal_ens__core!cmp.Ord.cmp._definition
)))

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

;; Function-Specs vstd::arithmetic::power2::lemma2_to64
(declare-fun ens%vstd!arithmetic.power2.lemma2_to64. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma2_to64. no%param) (and
     (= (vstd!arithmetic.power2.pow2.? (I 0)) 1)
     (= (vstd!arithmetic.power2.pow2.? (I 1)) 2)
     (= (vstd!arithmetic.power2.pow2.? (I 2)) 4)
     (= (vstd!arithmetic.power2.pow2.? (I 3)) 8)
     (= (vstd!arithmetic.power2.pow2.? (I 4)) 16)
     (= (vstd!arithmetic.power2.pow2.? (I 5)) 32)
     (= (vstd!arithmetic.power2.pow2.? (I 6)) 64)
     (= (vstd!arithmetic.power2.pow2.? (I 7)) 128)
     (= (vstd!arithmetic.power2.pow2.? (I 8)) 256)
     (= (vstd!arithmetic.power2.pow2.? (I 9)) 512)
     (= (vstd!arithmetic.power2.pow2.? (I 10)) 1024)
     (= (vstd!arithmetic.power2.pow2.? (I 11)) 2048)
     (= (vstd!arithmetic.power2.pow2.? (I 12)) 4096)
     (= (vstd!arithmetic.power2.pow2.? (I 13)) 8192)
     (= (vstd!arithmetic.power2.pow2.? (I 14)) 16384)
     (= (vstd!arithmetic.power2.pow2.? (I 15)) 32768)
     (= (vstd!arithmetic.power2.pow2.? (I 16)) 65536)
     (= (vstd!arithmetic.power2.pow2.? (I 17)) 131072)
     (= (vstd!arithmetic.power2.pow2.? (I 18)) 262144)
     (= (vstd!arithmetic.power2.pow2.? (I 19)) 524288)
     (= (vstd!arithmetic.power2.pow2.? (I 20)) 1048576)
     (= (vstd!arithmetic.power2.pow2.? (I 21)) 2097152)
     (= (vstd!arithmetic.power2.pow2.? (I 22)) 4194304)
     (= (vstd!arithmetic.power2.pow2.? (I 23)) 8388608)
     (= (vstd!arithmetic.power2.pow2.? (I 24)) 16777216)
     (= (vstd!arithmetic.power2.pow2.? (I 25)) 33554432)
     (= (vstd!arithmetic.power2.pow2.? (I 26)) 67108864)
     (= (vstd!arithmetic.power2.pow2.? (I 27)) 134217728)
     (= (vstd!arithmetic.power2.pow2.? (I 28)) 268435456)
     (= (vstd!arithmetic.power2.pow2.? (I 29)) 536870912)
     (= (vstd!arithmetic.power2.pow2.? (I 30)) 1073741824)
     (= (vstd!arithmetic.power2.pow2.? (I 31)) 2147483648)
     (= (vstd!arithmetic.power2.pow2.? (I 32)) 4294967296)
     (= (vstd!arithmetic.power2.pow2.? (I 64)) 18446744073709551616)
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma2_to64. no%param))
   :qid internal_ens__vstd!arithmetic.power2.lemma2_to64._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma2_to64._definition
)))

;; Function-Axioms vstd::std_specs::convert::FromSpec::obeys_from_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (has_type (vstd!std_specs.convert.FromSpec.obeys_from_spec.? Self%&. Self%& T&. T&)
    BOOL
   )
   :pattern ((vstd!std_specs.convert.FromSpec.obeys_from_spec.? Self%&. Self%& T&. T&))
   :qid internal_vstd!std_specs.convert.FromSpec.obeys_from_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.obeys_from_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::convert::FromSpec::from_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (v! Poly)) (!
   (=>
    (has_type v! T&)
    (has_type (vstd!std_specs.convert.FromSpec.from_spec.? Self%&. Self%& T&. T& v!) Self%&)
   )
   :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? Self%&. Self%& T&. T& v!))
   :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_pre_post_definition
)))

;; Function-Specs core::convert::From::from
(declare-fun ens%core!convert.From.from. (Dcr Type Dcr Type Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (v! Poly) (ret! Poly)) (!
   (= (ens%core!convert.From.from. Self%&. Self%& T&. T& v! ret!) (and
     (has_type ret! Self%&)
     (=>
      (%B (vstd!std_specs.convert.FromSpec.obeys_from_spec.? Self%&. Self%& T&. T&))
      (= ret! (vstd!std_specs.convert.FromSpec.from_spec.? Self%&. Self%& T&. T& v!))
   )))
   :pattern ((ens%core!convert.From.from. Self%&. Self%& T&. T& v! ret!))
   :qid internal_ens__core!convert.From.from._definition
   :skolemid skolem_internal_ens__core!convert.From.from._definition
)))
(assert
 (forall ((closure%$ Poly) (Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (has_type closure%$ (TYPE%tuple%1. T&. T&))
    (=>
     (let
      ((v$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      true
     )
     (closure_req (FNDEF%core!convert.From.from. Self%&. Self%& T&. T&) (DST T&.) (TYPE%tuple%1.
       T&. T&
      ) (F fndef_singleton) closure%$
   )))
   :pattern ((closure_req (FNDEF%core!convert.From.from. Self%&. Self%& T&. T&) (DST T&.)
     (TYPE%tuple%1. T&. T&) (F fndef_singleton) closure%$
   ))
   :qid user_core__convert__From__from_29
   :skolemid skolem_user_core__convert__From__from_29
)))
(assert
 (forall ((closure%$ Poly) (ret$ Poly) (Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type))
  (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. T&. T&))
     (has_type ret$ Self%&)
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. Self%&. Self%& T&. T&) (DST T&.) (TYPE%tuple%1.
       T&. T&
      ) (F fndef_singleton) closure%$ ret$
     )
     (let
      ((v$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (=>
       (%B (vstd!std_specs.convert.FromSpec.obeys_from_spec.? Self%&. Self%& T&. T&))
       (= ret$ (vstd!std_specs.convert.FromSpec.from_spec.? Self%&. Self%& T&. T& v$))
   ))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. Self%&. Self%& T&. T&) (DST T&.)
     (TYPE%tuple%1. T&. T&) (F fndef_singleton) closure%$ ret$
   ))
   :qid user_core__convert__From__from_30
   :skolemid skolem_user_core__convert__From__from_30
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::add_req
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     BOOL
   ))
   :pattern ((vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::obeys_add_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (has_type (vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&)
    BOOL
   )
   :pattern ((vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd!std_specs.ops.AddSpec.obeys_add_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.obeys_add_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::AddSpec::add_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     (proj%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&)
   ))
   :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_pre_post_definition
)))

;; Function-Specs core::ops::arith::Add::add
(declare-fun req%core!ops.arith.Add.add. (Dcr Type Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (= (req%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs!) (=>
     %%global_location_label%%5
     (%B (vstd!std_specs.ops.AddSpec.add_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   ))
   :pattern ((req%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_req__core!ops.arith.Add.add._definition
   :skolemid skolem_internal_req__core!ops.arith.Add.add._definition
)))
(declare-fun ens%core!ops.arith.Add.add. (Dcr Type Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly)
   (ret! Poly)
  ) (!
   (= (ens%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!) (and
     (has_type ret! (proj%core!ops.arith.Add./Output Self%&. Self%& Rhs&. Rhs&))
     (=>
      (%B (vstd!std_specs.ops.AddSpec.obeys_add_spec.? Self%&. Self%& Rhs&. Rhs&))
      (= ret! (vstd!std_specs.ops.AddSpec.add_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   )))
   :pattern ((ens%core!ops.arith.Add.add. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!))
   :qid internal_ens__core!ops.arith.Add.add._definition
   :skolemid skolem_internal_ens__core!ops.arith.Add.add._definition
)))

;; Function-Axioms vstd::std_specs::ops::SubSpec::sub_req
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.SubSpec.sub_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     BOOL
   ))
   :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::SubSpec::obeys_sub_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type)) (!
   (has_type (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? Self%&. Self%& Rhs&. Rhs&)
    BOOL
   )
   :pattern ((vstd!std_specs.ops.SubSpec.obeys_sub_spec.? Self%&. Self%& Rhs&. Rhs&))
   :qid internal_vstd!std_specs.ops.SubSpec.obeys_sub_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.obeys_sub_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::ops::SubSpec::sub_spec
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type rhs! Rhs&)
    )
    (has_type (vstd!std_specs.ops.SubSpec.sub_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!)
     (proj%core!ops.arith.Sub./Output Self%&. Self%& Rhs&. Rhs&)
   ))
   :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_pre_post_definition
)))

;; Function-Specs core::ops::arith::Sub::sub
(declare-fun req%core!ops.arith.Sub.sub. (Dcr Type Dcr Type Poly Poly) Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly))
  (!
   (= (req%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs!) (=>
     %%global_location_label%%6
     (%B (vstd!std_specs.ops.SubSpec.sub_req.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   ))
   :pattern ((req%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs!))
   :qid internal_req__core!ops.arith.Sub.sub._definition
   :skolemid skolem_internal_req__core!ops.arith.Sub.sub._definition
)))
(declare-fun ens%core!ops.arith.Sub.sub. (Dcr Type Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Rhs&. Dcr) (Rhs& Type) (self! Poly) (rhs! Poly)
   (ret! Poly)
  ) (!
   (= (ens%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!) (and
     (has_type ret! (proj%core!ops.arith.Sub./Output Self%&. Self%& Rhs&. Rhs&))
     (=>
      (%B (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? Self%&. Self%& Rhs&. Rhs&))
      (= ret! (vstd!std_specs.ops.SubSpec.sub_spec.? Self%&. Self%& Rhs&. Rhs& self! rhs!))
   )))
   :pattern ((ens%core!ops.arith.Sub.sub. Self%&. Self%& Rhs&. Rhs& self! rhs! ret!))
   :qid internal_ens__core!ops.arith.Sub.sub._definition
   :skolemid skolem_internal_ens__core!ops.arith.Sub.sub._definition
)))

;; Function-Axioms vstd::std_specs::option::OptionAdditionalFns::arrow_0
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!std_specs.option.OptionAdditionalFns.arrow_0.? Self%&. Self%& T&. T&
      self!
     ) T&
   ))
   :pattern ((vstd!std_specs.option.OptionAdditionalFns.arrow_0.? Self%&. Self%& T&. T&
     self!
   ))
   :qid internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::option::is_some
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.is_some.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.is_some.)
  (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
    (= (vstd!std_specs.option.is_some.? T&. T& option!) (is-core!option.Option./Some (%Poly%core!option.Option.
       option!
    )))
    :pattern ((vstd!std_specs.option.is_some.? T&. T& option!))
    :qid internal_vstd!std_specs.option.is_some.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.is_some.?_definition
))))

;; Function-Axioms vstd::std_specs::option::impl&%0::arrow_0
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.impl&%0.arrow_0.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.impl&%0.arrow_0.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!std_specs.option.OptionAdditionalFns.arrow_0.? $ (TYPE%core!option.Option.
        T&. T&
       ) T&. T& self!
      ) (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. self!))
    ))
    :pattern ((vstd!std_specs.option.OptionAdditionalFns.arrow_0.? $ (TYPE%core!option.Option.
       T&. T&
      ) T&. T& self!
    ))
    :qid internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.OptionAdditionalFns.arrow_0.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!std_specs.option.OptionAdditionalFns. $ (TYPE%core!option.Option. T&.
      T&
     ) T&. T&
   ))
   :pattern ((tr_bound%vstd!std_specs.option.OptionAdditionalFns. $ (TYPE%core!option.Option.
      T&. T&
     ) T&. T&
   ))
   :qid internal_vstd__std_specs__option__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__option__impl&__0_trait_impl_definition
)))

;; Function-Specs vstd::std_specs::option::spec_unwrap
(declare-fun req%vstd!std_specs.option.spec_unwrap. (Dcr Type Poly) Bool)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
   (= (req%vstd!std_specs.option.spec_unwrap. T&. T& option!) (=>
     %%global_location_label%%7
     (is-core!option.Option./Some (%Poly%core!option.Option. option!))
   ))
   :pattern ((req%vstd!std_specs.option.spec_unwrap. T&. T& option!))
   :qid internal_req__vstd!std_specs.option.spec_unwrap._definition
   :skolemid skolem_internal_req__vstd!std_specs.option.spec_unwrap._definition
)))

;; Function-Axioms vstd::std_specs::option::spec_unwrap
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.spec_unwrap.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.spec_unwrap.)
  (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
    (= (vstd!std_specs.option.spec_unwrap.? T&. T& option!) (core!option.Option./Some/0
      T&. T& (%Poly%core!option.Option. option!)
    ))
    :pattern ((vstd!std_specs.option.spec_unwrap.? T&. T& option!))
    :qid internal_vstd!std_specs.option.spec_unwrap.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
   (=>
    (has_type option! (TYPE%core!option.Option. T&. T&))
    (has_type (vstd!std_specs.option.spec_unwrap.? T&. T& option!) T&)
   )
   :pattern ((vstd!std_specs.option.spec_unwrap.? T&. T& option!))
   :qid internal_vstd!std_specs.option.spec_unwrap.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap.?_pre_post_definition
)))

;; Function-Specs vstd::std_specs::vec::vec_index
(declare-fun req%vstd!std_specs.vec.vec_index. (Dcr Type Dcr Type Poly Int) Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (vec! Poly) (i! Int)) (!
   (= (req%vstd!std_specs.vec.vec_index. T&. T& A&. A& vec! i!) (=>
     %%global_location_label%%8
     (< i! (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T&
         A&. A&
        ) vec!
   )))))
   :pattern ((req%vstd!std_specs.vec.vec_index. T&. T& A&. A& vec! i!))
   :qid internal_req__vstd!std_specs.vec.vec_index._definition
   :skolemid skolem_internal_req__vstd!std_specs.vec.vec_index._definition
)))
(declare-fun ens%vstd!std_specs.vec.vec_index. (Dcr Type Dcr Type Poly Int Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (vec! Poly) (i! Int) (element! Poly))
  (!
   (= (ens%vstd!std_specs.vec.vec_index. T&. T& A&. A& vec! i! element!) (and
     (has_type element! T&)
     (= element! (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
         T&. T& A&. A&
        ) vec!
       ) (I i!)
   ))))
   :pattern ((ens%vstd!std_specs.vec.vec_index. T&. T& A&. A& vec! i! element!))
   :qid internal_ens__vstd!std_specs.vec.vec_index._definition
   :skolemid skolem_internal_ens__vstd!std_specs.vec.vec_index._definition
)))

;; Function-Specs alloc::vec::impl&%1::len
(declare-fun ens%alloc!vec.impl&%1.len. (Dcr Type Dcr Type Poly Int) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (vec! Poly) (len! Int)) (!
   (= (ens%alloc!vec.impl&%1.len. T&. T& A&. A& vec! len!) (and
     (uInv SZ len!)
     (= len! (vstd!std_specs.vec.spec_vec_len.? T&. T& A&. A& vec!))
   ))
   :pattern ((ens%alloc!vec.impl&%1.len. T&. T& A&. A& vec! len!))
   :qid internal_ens__alloc!vec.impl&__1.len._definition
   :skolemid skolem_internal_ens__alloc!vec.impl&__1.len._definition
)))

;; Function-Specs alloc::vec::impl&%0::new
(declare-fun ens%alloc!vec.impl&%0.new. (Dcr Type Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (v! Poly)) (!
   (= (ens%alloc!vec.impl&%0.new. T&. T& v!) (and
     (has_type v! (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL))
     (= (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL) v!) (vstd!seq.Seq.empty.?
       T&. T&
   ))))
   :pattern ((ens%alloc!vec.impl&%0.new. T&. T& v!))
   :qid internal_ens__alloc!vec.impl&__0.new._definition
   :skolemid skolem_internal_ens__alloc!vec.impl&__0.new._definition
)))

;; Function-Specs alloc::vec::impl&%1::push
(declare-fun ens%alloc!vec.impl&%1.push. (Dcr Type Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (pre%vec! Poly) (vec! Poly) (value!
    Poly
   )
  ) (!
   (= (ens%alloc!vec.impl&%1.push. T&. T& A&. A& pre%vec! vec! value!) (and
     (has_type vec! (TYPE%alloc!vec.Vec. T&. T& A&. A&))
     (= (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) vec!) (vstd!seq.Seq.push.?
       T&. T& (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) pre%vec!) value!
   ))))
   :pattern ((ens%alloc!vec.impl&%1.push. T&. T& A&. A& pre%vec! vec! value!))
   :qid internal_ens__alloc!vec.impl&__1.push._definition
   :skolemid skolem_internal_ens__alloc!vec.impl&__1.push._definition
)))

;; Function-Specs vstd::array::array_index_get
(declare-fun req%vstd!array.array_index_get. (Dcr Type Dcr Type %%Function%% Int)
 Bool
)
(declare-const %%global_location_label%%9 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! %%Function%%) (i! Int)) (!
   (= (req%vstd!array.array_index_get. T&. T& N&. N& ar! i!) (=>
     %%global_location_label%%9
     (let
      ((tmp%%$ i!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (const_int N&))
   ))))
   :pattern ((req%vstd!array.array_index_get. T&. T& N&. N& ar! i!))
   :qid internal_req__vstd!array.array_index_get._definition
   :skolemid skolem_internal_req__vstd!array.array_index_get._definition
)))
(declare-fun ens%vstd!array.array_index_get. (Dcr Type Dcr Type %%Function%% Int Poly)
 Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! %%Function%%) (i! Int) (out! Poly))
  (!
   (= (ens%vstd!array.array_index_get. T&. T& N&. N& ar! i! out!) (and
     (has_type out! T&)
     (= out! (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
        (Poly%array%. ar!)
       ) (I i!)
   ))))
   :pattern ((ens%vstd!array.array_index_get. T&. T& N&. N& ar! i! out!))
   :qid internal_ens__vstd!array.array_index_get._definition
   :skolemid skolem_internal_ens__vstd!array.array_index_get._definition
)))

;; Function-Axioms vstd::pervasive::arbitrary
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (has_type (vstd!pervasive.arbitrary.? A&. A&) A&)
   :pattern ((vstd!pervasive.arbitrary.? A&. A&))
   :qid internal_vstd!pervasive.arbitrary.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.arbitrary.?_pre_post_definition
)))

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

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::p
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.p.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.p.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.p.? no%param) (nClip (Sub (vstd!arithmetic.power2.pow2.?
        (I 255)
       ) 19
    )))
    :pattern ((curve25519_dalek!specs.field_specs_u64.p.? no%param))
    :qid internal_curve25519_dalek!specs.field_specs_u64.p.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.p.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.field_specs_u64.p.? no%param))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.p.? no%param))
   :qid internal_curve25519_dalek!specs.field_specs_u64.p.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.p.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::field_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.)
  (forall ((n! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? n!) (EucMod (%I n!) (curve25519_dalek!specs.field_specs_u64.p.?
       (I 0)
    )))
    :pattern ((curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_definition
))))
(assert
 (forall ((n! Poly)) (!
   (=>
    (has_type n! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.field_canonical.? n!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.field_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!) (nClip (Add (nClip
        (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
               ) (I 0)
              )
             ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 51)) (%I (vstd!seq.Seq.index.? $ (UINT
                  64
                 ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 1)
            )))))
           ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 102)) (%I (vstd!seq.Seq.index.? $ (UINT
                64
               ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 2)
          )))))
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 153)) (%I (vstd!seq.Seq.index.? $ (UINT
              64
             ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 3)
        )))))
       ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 204)) (%I (vstd!seq.Seq.index.? $ (UINT
            64
           ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 4)
    )))))))
    :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::u64_5_as_field_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? limbs!))
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_as_canonical_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!) (curve25519_dalek!specs.field_specs_u64.u64_5_as_field_canonical.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
    ))))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_definition
))))
(assert
 (forall ((fe! Poly)) (!
   (=>
    (has_type fe! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (<= 0 (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? fe!))
   :qid internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_x
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_x.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_x.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_x.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_x.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_y
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_y.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_y.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_y.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_y.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_z
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_z.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_z.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_z.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_z.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_t
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_t.?
       point!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_t.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_t.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_t.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!) (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
      ))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ))))
        (let
         ((t$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
         ))))
         (tuple%4./tuple%4 (I x$) (I y$) (I z$) (I t$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%tuple%4. (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?
       point!
      )
     ) (TYPE%tuple%4. $ NAT $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_gcd
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
 Fuel
)
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
     fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
     zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_zero_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b!
      (succ fuel%)
     ) (ite
      (= (%I b!) 0)
      (%I a!)
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? b! (I (EucMod
         (%I a!) (%I b!)
        )
       ) fuel%
   ))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.)
  (forall ((a! Poly) (b! Poly)) (!
    (=>
     (and
      (has_type a! NAT)
      (has_type b! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a! b!) (
       curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a! b! (
        succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
    ))))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a!
      b!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a! b!))
   )
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? a!
     b!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.?_pre_post_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.? a!
      b! fuel%
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_gcd.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_gcd.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_extended_gcd
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
 Fuel
)
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_zero_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
      a! b! (succ fuel%)
     ) (ite
      (= (%I b!) 0)
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
       (%I a!) (%I (I 1)) (%I (I 0))
      )
      (let
       ((r$ (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
          b! (I (EucMod (%I a!) (%I b!))) fuel%
       )))
       (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult
        (%I (I (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/gcd
           (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
             r$
         ))))
        ) (%I (I (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
           (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
             r$
         ))))
        ) (%I (I (Sub (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
            (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
              r$
            ))
           ) (Mul (EucDiv (%I a!) (%I b!)) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/y
             (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
               r$
   ))))))))))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
  (forall ((a! Poly) (b! Poly)) (!
    (=>
     (and
      (has_type a! NAT)
      (has_type b! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
       a! b!
      ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
       a! b! (succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.)
    )))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
      a! b!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.? a!
       b!
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
     a! b!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?_pre_post_definition
)))
(assert
 (forall ((a! Poly) (b! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (has_type (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
       a! b! fuel%
      )
     ) TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec%spec_extended_gcd.?
     a! b! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_extended_gcd.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.rec__spec_extended_gcd.?_pre_post_rec_definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
 (Poly Poly) Bool
)
(declare-const %%global_location_label%%10 Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
    ) (and
     (=>
      %%global_location_label%%10
      (> (%I m!) 1)
     )
     (=>
      %%global_location_label%%11
      (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (EucMod
          (%I a!) (%I m!)
         )
        ) m!
       ) 1
   ))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse._definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::spec_mod_inverse
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.)
  (forall ((a! Poly) (m! Poly)) (!
    (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.? a!
      m!
     ) (ite
      (or
       (<= (%I m!) 1)
       (not (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (EucMod
            (%I a!) (%I m!)
           )
          ) m!
         ) 1
      )))
      0
      (let
       ((r$ (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.?
          (I (EucMod (%I a!) (%I m!))) m!
       )))
       (nClip (EucMod (Add (EucMod (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult./ExtGcdResult/x
            (%Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. (Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
              r$
            ))
           ) (%I m!)
          ) (%I m!)
         ) (%I m!)
    )))))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
      a! m!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_definition
))))
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type m! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
      a! m!
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
     a! m!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_inv
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_inv.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_inv.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_inv.? a!) (ite
      (= (EucMod (%I a!) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))) 0)
      0
      (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.? a!
       (I (curve25519_dalek!specs.field_specs_u64.p.? (I 0)))
    )))
    :pattern ((curve25519_dalek!specs.field_specs.field_inv.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_inv.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_inv.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_inv.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_inv.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_inv.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_inv.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_mul
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_mul.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_mul.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_mul.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Mul (%I a!) (%I b!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_mul.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_mul.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_mul.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_mul.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_mul.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_mul.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_mul.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_as_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((_t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z$))))
           (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I z_inv$)))
            (I (curve25519_dalek!specs.field_specs.field_mul.? (I y$) (I z_inv$)))
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
       point!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::u64_5_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.u64_5_bounded.)
  (forall ((limbs! Poly) (bit_limit! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.u64_5_bounded.? limbs! bit_limit!) (forall (
       (i$ Poly)
      ) (!
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
             ) limbs!
            ) i$
           )
          ) (uClip 64 (bitshl (I 1) (I (%I bit_limit!))))
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) limbs!
         ) i$
       ))
       :qid user_curve25519_dalek__specs__field_specs__u64_5_bounded_31
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__u64_5_bounded_31
    )))
    :pattern ((curve25519_dalek!specs.field_specs.u64_5_bounded.? limbs! bit_limit!))
    :qid internal_curve25519_dalek!specs.field_specs.u64_5_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.u64_5_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_limbs_bounded.)
  (forall ((fe! Poly) (bit_limit! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? fe! bit_limit!) (curve25519_dalek!specs.field_specs.u64_5_bounded.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
       )
      ) bit_limit!
    ))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? fe! bit_limit!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_neg
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_neg.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_neg.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_neg.? a!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
          a!
    ))))))
    :pattern ((curve25519_dalek!specs.field_specs.field_neg.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_neg.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_neg.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_neg.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_neg.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_neg.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_neg.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::mask51
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.mask51.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.mask51.)
  (= curve25519_dalek!specs.field_specs_u64.mask51.? 2251799813685247)
))
(assert
 (uInv 64 curve25519_dalek!specs.field_specs_u64.mask51.?)
)

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::spec_reduce
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.)
)
(declare-fun %%array%%0 (Poly Poly Poly Poly Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   )
  ) (!
   (let
    ((%%x%% (%%array%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)))
    (and
     (= (%%apply%%2 %%x%% 0) %%hole%%0)
     (= (%%apply%%2 %%x%% 1) %%hole%%1)
     (= (%%apply%%2 %%x%% 2) %%hole%%2)
     (= (%%apply%%2 %%x%% 3) %%hole%%3)
     (= (%%apply%%2 %%x%% 4) %%hole%%4)
   ))
   :pattern ((%%array%%0 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4))
   :qid __AIR_ARRAY_QID__
   :skolemid skolem___AIR_ARRAY_QID__
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!) (let
      ((r$ (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Add (uClip 64 (bitand
                (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                     (CONST_INT 5)
                    ) limbs!
                   ) (I 0)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (Mul (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                    ) (I 4)
                  ))
                 ) (I 51)
                )
               ) 19
            )))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 1)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 0)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 2)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 1)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 3)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 2)
                 ))
                ) (I 51)
            ))))
           ) (I (uClip 64 (Add (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 4)
                 ))
                ) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
               )
              ) (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
                     ARRAY $ (UINT 64) $ (CONST_INT 5)
                    ) limbs!
                   ) (I 3)
                 ))
                ) (I 51)
      ))))))))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.spec_reduce.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_reduce.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::sixteen_p_vec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.)
  (= curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.? (%Poly%array%. (array_new
     $ (UINT 64) 5 (%%array%%0 (I 36028797018963664) (I 36028797018963952) (I 36028797018963952)
      (I 36028797018963952) (I 36028797018963952)
))))))
(assert
 (has_type (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?) (ARRAY
   $ (UINT 64) $ (CONST_INT 5)
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::pre_reduce_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!) (let
      ((r$ (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.?
                $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
                  curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?
                 )
                ) (I 0)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 0)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 1)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 1)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 2)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 2)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 3)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 3)
            ))))
           ) (I (uClip 64 (Sub (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. curve25519_dalek!specs.field_specs_u64.sixteen_p_vec.?)
                ) (I 4)
               )
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) limbs!
                ) (I 4)
      ))))))))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs_u64::spec_negate
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs_u64.spec_negate.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs_u64.spec_negate.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!) (let
      ((r$ (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. (curve25519_dalek!specs.field_specs_u64.pre_reduce_limbs.?
           limbs!
      )))))
      r$
    ))
    :pattern ((curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
    :qid internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
     (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!specs.field_specs_u64.spec_negate.? limbs!))
   :qid internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs_u64.spec_negate.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::negate_projective_niels
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.negate_projective_niels.)
  (forall ((p! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
      (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_negate.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
                 (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. p!)
    )))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!))
    :qid internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_definition
))))
(assert
 (forall ((p! Poly)) (!
   (=>
    (has_type p! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!)
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.negate_projective_niels.? p!))
   :qid internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.negate_projective_niels.?_pre_post_definition
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

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::group_order
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.group_order.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.group_order.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.group_order.? no%param) (nClip (Add (vstd!arithmetic.power2.pow2.?
        (I 252)
       ) 27742317777372353535851937790883648493
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.group_order.? no%param))
    :qid internal_curve25519_dalek!specs.scalar52_specs.group_order.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.group_order.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.scalar52_specs.group_order.? no%param))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.group_order.? no%param))
   :qid internal_curve25519_dalek!specs.scalar52_specs.group_order.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.group_order.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::is_canonical_scalar
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.is_canonical_scalar.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.is_canonical_scalar.)
  (forall ((s! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.is_canonical_scalar.? s!) (and
      (< (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. (curve25519_dalek!scalar.Scalar./Scalar/bytes
          (%Poly%curve25519_dalek!scalar.Scalar. s!)
        ))
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
      )
      (<= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $
           (CONST_INT 32)
          ) (Poly%array%. (curve25519_dalek!scalar.Scalar./Scalar/bytes (%Poly%curve25519_dalek!scalar.Scalar.
             s!
          )))
         ) (I 31)
        )
       ) 127
    )))
    :pattern ((curve25519_dalek!specs.scalar_specs.is_canonical_scalar.? s!))
    :qid internal_curve25519_dalek!specs.scalar_specs.is_canonical_scalar.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.is_canonical_scalar.?_definition
))))

;; Function-Specs curve25519_dalek::specs::iterator_specs::collect_scalars_from_iter
(declare-fun ens%curve25519_dalek!specs.iterator_specs.collect_scalars_from_iter.
 (Dcr Type Dcr Type Poly alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.)
 Bool
)
(assert
 (forall ((S&. Dcr) (S& Type) (I&. Dcr) (I& Type) (iter! Poly) (result! alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.))
  (!
   (= (ens%curve25519_dalek!specs.iterator_specs.collect_scalars_from_iter. S&. S& I&.
     I& iter! result!
    ) (and
     (= (%Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
         $ TYPE%curve25519_dalek!scalar.Scalar. $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>. result!)
       )
      ) (curve25519_dalek!specs.iterator_specs.spec_scalars_from_iter.? S&. S& I&. I& iter!)
     )
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. (vstd!view.View.view.?
              $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!scalar.Scalar. $ ALLOCATOR_GLOBAL)
              (Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>. result!)
         )))))
         (curve25519_dalek!specs.scalar_specs.is_canonical_scalar.? (vstd!seq.Seq.index.? $
           TYPE%curve25519_dalek!scalar.Scalar. (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
             $ TYPE%curve25519_dalek!scalar.Scalar. $ ALLOCATOR_GLOBAL
            ) (Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>. result!)
           ) i$
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!scalar.Scalar. (vstd!view.View.view.?
          $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!scalar.Scalar. $ ALLOCATOR_GLOBAL)
          (Poly%alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>. result!)
         ) i$
       ))
       :qid user_curve25519_dalek__specs__iterator_specs__collect_scalars_from_iter_32
       :skolemid skolem_user_curve25519_dalek__specs__iterator_specs__collect_scalars_from_iter_32
   ))))
   :pattern ((ens%curve25519_dalek!specs.iterator_specs.collect_scalars_from_iter. S&.
     S& I&. I& iter! result!
   ))
   :qid internal_ens__curve25519_dalek!specs.iterator_specs.collect_scalars_from_iter._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.iterator_specs.collect_scalars_from_iter._definition
)))

;; Function-Specs curve25519_dalek::specs::iterator_specs::collect_optional_points_from_iter
(declare-fun ens%curve25519_dalek!specs.iterator_specs.collect_optional_points_from_iter.
 (Dcr Type Poly alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.)
 Bool
)
(assert
 (forall ((J&. Dcr) (J& Type) (iter! Poly) (result! alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.))
  (!
   (= (ens%curve25519_dalek!specs.iterator_specs.collect_optional_points_from_iter. J&.
     J& iter! result!
    ) (= (%Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
      (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
        $ ALLOCATOR_GLOBAL
       ) (Poly%alloc!vec.Vec<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>./allocator_global%.>.
        result!
      ))
     ) (curve25519_dalek!specs.iterator_specs.spec_optional_points_from_iter.? J&. J& iter!)
   ))
   :pattern ((ens%curve25519_dalek!specs.iterator_specs.collect_optional_points_from_iter.
     J&. J& iter! result!
   ))
   :qid internal_ens__curve25519_dalek!specs.iterator_specs.collect_optional_points_from_iter._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.iterator_specs.collect_optional_points_from_iter._definition
)))

;; Function-Specs curve25519_dalek::specs::iterator_specs::collect_points_from_iter
(declare-fun ens%curve25519_dalek!specs.iterator_specs.collect_points_from_iter. (
  Dcr Type Dcr Type Poly alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
 ) Bool
)
(assert
 (forall ((P&. Dcr) (P& Type) (J&. Dcr) (J& Type) (iter! Poly) (result! alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.))
  (!
   (= (ens%curve25519_dalek!specs.iterator_specs.collect_points_from_iter. P&. P& J&.
     J& iter! result!
    ) (= (%Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. (vstd!view.View.view.?
       $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL)
       (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. result!)
      )
     ) (curve25519_dalek!specs.iterator_specs.spec_points_from_iter.? P&. P& J&. J& iter!)
   ))
   :pattern ((ens%curve25519_dalek!specs.iterator_specs.collect_points_from_iter. P&.
     P& J&. J& iter! result!
   ))
   :qid internal_ens__curve25519_dalek!specs.iterator_specs.collect_points_from_iter._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.iterator_specs.collect_points_from_iter._definition
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::EDWARDS_D
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.)
  (= curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.? (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 929955233495203) (I 466365720129213)
       (I 1662059464998953) (I 2033849074728123) (I 1442794654840575)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_square
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_square.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_square.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_square.? a!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Mul (%I a!) (%I a!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_square.? a!))
    :qid internal_curve25519_dalek!specs.field_specs.field_square.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_square.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! NAT)
    (<= 0 (curve25519_dalek!specs.field_specs.field_square.? a!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_square.? a!))
   :qid internal_curve25519_dalek!specs.field_specs.field_square.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_square.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_sub
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_sub.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_sub.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_sub.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Sub (nClip (Add (curve25519_dalek!specs.field_specs_u64.field_canonical.? a!)
           (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
          )
         ) (curve25519_dalek!specs.field_specs_u64.field_canonical.? b!)
    )))))
    :pattern ((curve25519_dalek!specs.field_specs.field_sub.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_sub.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sub.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_sub.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_sub.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_sub.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_sub.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::field_add
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_add.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_add.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_add.? a! b!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (nClip (Add (%I a!) (%I b!))))
    ))
    :pattern ((curve25519_dalek!specs.field_specs.field_add.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.field_add.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_add.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! NAT)
     (has_type b! NAT)
    )
    (<= 0 (curve25519_dalek!specs.field_specs.field_add.? a! b!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_add.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.field_add.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_add.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_on_edwards_curve_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.)
  (forall ((x! Poly) (y! Poly) (z! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x! y! z!)
     (let
      ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
      ))))
      (let
       ((x2$ (curve25519_dalek!specs.field_specs.field_square.? x!)))
       (let
        ((y2$ (curve25519_dalek!specs.field_specs.field_square.? y!)))
        (let
         ((z2$ (curve25519_dalek!specs.field_specs.field_square.? z!)))
         (let
          ((z4$ (curve25519_dalek!specs.field_specs.field_square.? (I z2$))))
          (let
           ((lhs$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
                (I y2$) (I x2$)
               )
              ) (I z2$)
           )))
           (let
            ((rhs$ (curve25519_dalek!specs.field_specs.field_add.? (I z4$) (I (curve25519_dalek!specs.field_specs.field_mul.?
                 (I d$) (I (curve25519_dalek!specs.field_specs.field_mul.? (I x2$) (I y2$)))
            )))))
            (= lhs$ rhs$)
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x!
      y! z!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_extended_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.)
  (forall ((x! Poly) (y! Poly) (z! Poly) (t! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? x! y! z!
      t!
     ) (and
      (and
       (not (= (curve25519_dalek!specs.field_specs_u64.field_canonical.? z!) 0))
       (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? x! y! z!)
      )
      (= (curve25519_dalek!specs.field_specs.field_mul.? x! y!) (curve25519_dalek!specs.field_specs.field_mul.?
        z! t!
    ))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? x!
      y! z! t!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!) (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
      ))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ))))
        (let
         ((t$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
         ))))
         (curve25519_dalek!specs.edwards_specs.is_valid_extended_edwards_point.? (I x$) (I y$)
          (I z$) (I t$)
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_point_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!) (and
      (and
       (and
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
         ) (I 52)
        )
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
         ) (I 52)
       ))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
         (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ) (I 52)
      ))
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!specs.edwards_specs.edwards_t.? point!)
       ) (I 52)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::sum_of_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.)
  (forall ((fe1! Poly) (fe2! Poly) (bound! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? fe1! fe2! bound!) (forall
      ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (< (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe1!)
              ))
             ) i$
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe2!)
              ))
             ) i$
           ))
          ) (%I bound!)
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe1!)
          ))
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe2!)
          ))
         ) i$
       ))
       :qid user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_33
       :skolemid skolem_user_curve25519_dalek__specs__field_specs__sum_of_limbs_bounded_33
    )))
    :pattern ((curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? fe1! fe2! bound!))
    :qid internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_well_formed_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? point!) (and
      (and
       (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point!)
       (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point!)
      )
      (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_x.?
         point!
        )
       ) (I 18446744073709551615)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_identity
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_identity.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_identity.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param) (tuple%2./tuple%2
      (I 0) (I 1)
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_identity.? no%param))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_identity.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_add
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_add.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_add.)
  (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!) (let
      ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
      ))))
      (let
       ((x1x2$ (curve25519_dalek!specs.field_specs.field_mul.? x1! x2!)))
       (let
        ((y1y2$ (curve25519_dalek!specs.field_specs.field_mul.? y1! y2!)))
        (let
         ((x1y2$ (curve25519_dalek!specs.field_specs.field_mul.? x1! y2!)))
         (let
          ((y1x2$ (curve25519_dalek!specs.field_specs.field_mul.? y1! x2!)))
          (let
           ((t$ (curve25519_dalek!specs.field_specs.field_mul.? (I d$) (I (curve25519_dalek!specs.field_specs.field_mul.?
                (I x1x2$) (I y1y2$)
           )))))
           (let
            ((denom_x$ (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I t$))))
            (let
             ((denom_y$ (curve25519_dalek!specs.field_specs.field_sub.? (I 1) (I t$))))
             (let
              ((x3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                   (I x1y2$) (I y1x2$)
                  )
                 ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I denom_x$)))
              )))
              (let
               ((y3$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
                    (I y1y2$) (I x1x2$)
                   )
                  ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I denom_y$)))
               )))
               (tuple%2./tuple%2 (I x3$) (I y3$))
    )))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_definition
))))
(assert
 (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
   (=>
    (and
     (has_type x1! NAT)
     (has_type y1! NAT)
     (has_type x2! NAT)
     (has_type y2! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1!
       x2! y2!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_add.? x1! y1! x2! y2!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_add.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_double
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_double.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_double.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!) (curve25519_dalek!specs.edwards_specs.edwards_add.?
      x! y! x! y!
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_definition
))))
(assert
 (forall ((x! Poly) (y! Poly)) (!
   (=>
    (and
     (has_type x! NAT)
     (has_type y! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_double.? x! y!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_double.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_scalar_mul
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
)
(declare-const fuel_nat%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul. Fuel)
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
     fuel%
    ) (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
     zero
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_zero_definition
)))
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (= (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine! n!
      (succ fuel%)
     ) (ite
      (= (%I n!) 0)
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (ite
       (= (%I n!) 1)
       (%Poly%tuple%2. point_affine!)
       (ite
        (= (EucMod (%I n!) 2) 0)
        (let
         ((half$ (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
            (I (EucDiv (%I n!) 2)) fuel%
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. half$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. half$)))
        ))
        (let
         ((prev$ (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
            (I (nClip (Sub (%I n!) 1))) fuel%
         )))
         (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
            (Poly%tuple%2. prev$)
           )
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
           (%Poly%tuple%2. point_affine!)
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. point_affine!))
   )))))))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
  (forall ((point_affine! Poly) (n! Poly)) (!
    (=>
     (and
      (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
      (has_type n! NAT)
     )
     (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine! n!) (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.?
       point_affine! n! (succ fuel_nat%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine!
      n!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_definition
))))
(assert
 (forall ((point_affine! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?
       point_affine! n!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine!
     n!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.?_pre_post_definition
)))
(assert
 (forall ((point_affine! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.?
       point_affine! n! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%edwards_scalar_mul.? point_affine!
     n! fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.rec__edwards_scalar_mul.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.rec__edwards_scalar_mul.?_pre_post_rec_definition
)))

;; Function-Specs curve25519_dalek::traits::Identity::identity
(declare-fun ens%curve25519_dalek!traits.Identity.identity. (Dcr Type Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (%return! Poly)) (!
   (= (ens%curve25519_dalek!traits.Identity.identity. Self%&. Self%& %return!) (has_type
     %return! Self%&
   ))
   :pattern ((ens%curve25519_dalek!traits.Identity.identity. Self%&. Self%& %return!))
   :qid internal_ens__curve25519_dalek!traits.Identity.identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!traits.Identity.identity._definition
)))

;; Function-Axioms vstd::std_specs::num::u8_specs::impl&%2::obeys_cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.u8_specs.impl&%2.obeys_cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.u8_specs.impl&%2.obeys_cmp_spec.)
  (= (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::num::u8_specs::impl&%2::cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.u8_specs.impl&%2.cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.u8_specs.impl&%2.cmp_spec.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (UINT 8) self! other!) (Poly%core!cmp.Ordering.
      (ite
       (< (%I self!) (%I other!))
       core!cmp.Ordering./Less
       (ite
        (> (%I self!) (%I other!))
        core!cmp.Ordering./Greater
        core!cmp.Ordering./Equal
    ))))
    :pattern ((vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (UINT 8) self! other!))
    :qid internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::num::i8_specs::impl&%2::obeys_cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.i8_specs.impl&%2.obeys_cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.i8_specs.impl&%2.obeys_cmp_spec.)
  (= (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? $ (SINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::num::i8_specs::impl&%2::cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.i8_specs.impl&%2.cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.i8_specs.impl&%2.cmp_spec.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (SINT 8) self! other!) (Poly%core!cmp.Ordering.
      (ite
       (< (%I self!) (%I other!))
       core!cmp.Ordering./Less
       (ite
        (> (%I self!) (%I other!))
        core!cmp.Ordering./Greater
        core!cmp.Ordering./Equal
    ))))
    :pattern ((vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (SINT 8) self! other!))
    :qid internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::num::u16_specs::impl&%2::obeys_cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.u16_specs.impl&%2.obeys_cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.u16_specs.impl&%2.obeys_cmp_spec.)
  (= (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? $ (UINT 16)) (B true))
))

;; Function-Axioms vstd::std_specs::num::u16_specs::impl&%2::cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.u16_specs.impl&%2.cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.u16_specs.impl&%2.cmp_spec.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (UINT 16) self! other!) (Poly%core!cmp.Ordering.
      (ite
       (< (%I self!) (%I other!))
       core!cmp.Ordering./Less
       (ite
        (> (%I self!) (%I other!))
        core!cmp.Ordering./Greater
        core!cmp.Ordering./Equal
    ))))
    :pattern ((vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (UINT 16) self! other!))
    :qid internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::num::u32_specs::impl&%2::obeys_cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.u32_specs.impl&%2.obeys_cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.u32_specs.impl&%2.obeys_cmp_spec.)
  (= (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? $ (UINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::num::u32_specs::impl&%2::cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.u32_specs.impl&%2.cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.u32_specs.impl&%2.cmp_spec.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (UINT 32) self! other!) (Poly%core!cmp.Ordering.
      (ite
       (< (%I self!) (%I other!))
       core!cmp.Ordering./Less
       (ite
        (> (%I self!) (%I other!))
        core!cmp.Ordering./Greater
        core!cmp.Ordering./Equal
    ))))
    :pattern ((vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (UINT 32) self! other!))
    :qid internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::num::i32_specs::impl&%2::obeys_cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.i32_specs.impl&%2.obeys_cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.i32_specs.impl&%2.obeys_cmp_spec.)
  (= (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? $ (SINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::num::i32_specs::impl&%2::cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.i32_specs.impl&%2.cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.i32_specs.impl&%2.cmp_spec.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (SINT 32) self! other!) (Poly%core!cmp.Ordering.
      (ite
       (< (%I self!) (%I other!))
       core!cmp.Ordering./Less
       (ite
        (> (%I self!) (%I other!))
        core!cmp.Ordering./Greater
        core!cmp.Ordering./Equal
    ))))
    :pattern ((vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (SINT 32) self! other!))
    :qid internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::num::u64_specs::impl&%2::obeys_cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.u64_specs.impl&%2.obeys_cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.u64_specs.impl&%2.obeys_cmp_spec.)
  (= (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? $ (UINT 64)) (B true))
))

;; Function-Axioms vstd::std_specs::num::u64_specs::impl&%2::cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.u64_specs.impl&%2.cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.u64_specs.impl&%2.cmp_spec.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (UINT 64) self! other!) (Poly%core!cmp.Ordering.
      (ite
       (< (%I self!) (%I other!))
       core!cmp.Ordering./Less
       (ite
        (> (%I self!) (%I other!))
        core!cmp.Ordering./Greater
        core!cmp.Ordering./Equal
    ))))
    :pattern ((vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (UINT 64) self! other!))
    :qid internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::num::u128_specs::impl&%2::obeys_cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.u128_specs.impl&%2.obeys_cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.u128_specs.impl&%2.obeys_cmp_spec.)
  (= (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? $ (UINT 128)) (B true))
))

;; Function-Axioms vstd::std_specs::num::u128_specs::impl&%2::cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.u128_specs.impl&%2.cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.u128_specs.impl&%2.cmp_spec.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (UINT 128) self! other!) (Poly%core!cmp.Ordering.
      (ite
       (< (%I self!) (%I other!))
       core!cmp.Ordering./Less
       (ite
        (> (%I self!) (%I other!))
        core!cmp.Ordering./Greater
        core!cmp.Ordering./Equal
    ))))
    :pattern ((vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (UINT 128) self! other!))
    :qid internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::num::usize_specs::impl&%2::obeys_cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.usize_specs.impl&%2.obeys_cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.usize_specs.impl&%2.obeys_cmp_spec.)
  (= (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? $ USIZE) (B true))
))

;; Function-Axioms vstd::std_specs::num::usize_specs::impl&%2::cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.usize_specs.impl&%2.cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.usize_specs.impl&%2.cmp_spec.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ USIZE self! other!) (Poly%core!cmp.Ordering.
      (ite
       (< (%I self!) (%I other!))
       core!cmp.Ordering./Less
       (ite
        (> (%I self!) (%I other!))
        core!cmp.Ordering./Greater
        core!cmp.Ordering./Equal
    ))))
    :pattern ((vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ USIZE self! other!))
    :qid internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized VERUS_SPEC__A&.)
     (tr_bound%core!convert.From. VERUS_SPEC__A&. VERUS_SPEC__A& T&. T&)
    )
    (tr_bound%vstd!std_specs.convert.FromSpec. VERUS_SPEC__A&. VERUS_SPEC__A& T&. T&)
   )
   :pattern ((tr_bound%vstd!std_specs.convert.FromSpec. VERUS_SPEC__A&. VERUS_SPEC__A&
     T&. T&
   ))
   :qid internal_vstd__std_specs__convert__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__convert__impl&__2_trait_impl_definition
)))

;; Function-Axioms vstd::std_specs::convert::impl&%6::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%6.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%6.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 16) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%6::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%6.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%6.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 16) $ (UINT 8) v!) (I (uClip
       16 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 16) $ (UINT 8) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%7::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%7.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%7.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 32) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%7::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%7.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%7.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 32) $ (UINT 8) v!) (I (uClip
       32 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 32) $ (UINT 8) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%8::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%8.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%8.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 64) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%8::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%8.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%8.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 8) v!) (I (uClip
       64 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 8) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%9::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%9.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%9.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ USIZE $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%9::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%9.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%9.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ USIZE $ (UINT 8) v!) (I (uClip SZ
       (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ USIZE $ (UINT 8) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%10::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%10.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%10.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 128) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%10::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%10.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%10.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 128) $ (UINT 8) v!) (I (uClip
       128 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 128) $ (UINT 8) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%11::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%11.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%11.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 32) $ (UINT 16)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%11::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%11.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%11.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 32) $ (UINT 16) v!) (I (uClip
       32 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 32) $ (UINT 16) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%12::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%12.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%12.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 64) $ (UINT 16)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%12::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%12.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%12.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 16) v!) (I (uClip
       64 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 16) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%13::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%13.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%13.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ USIZE $ (UINT 16)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%13::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%13.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%13.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ USIZE $ (UINT 16) v!) (I (uClip SZ
       (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ USIZE $ (UINT 16) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%14::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%14.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%14.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 128) $ (UINT 16)) (B
    true
))))

;; Function-Axioms vstd::std_specs::convert::impl&%14::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%14.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%14.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 128) $ (UINT 16) v!) (I (uClip
       128 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 128) $ (UINT 16) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%15::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%15.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%15.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 64) $ (UINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::convert::impl&%15::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%15.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%15.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 32) v!) (I (uClip
       64 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 64) $ (UINT 32) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%16::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%16.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%16.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 128) $ (UINT 32)) (B
    true
))))

;; Function-Axioms vstd::std_specs::convert::impl&%16::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%16.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%16.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 128) $ (UINT 32) v!) (I (uClip
       128 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 128) $ (UINT 32) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::convert::impl&%17::obeys_from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%17.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%17.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (UINT 128) $ (UINT 64)) (B
    true
))))

;; Function-Axioms vstd::std_specs::convert::impl&%17::from_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.convert.impl&%17.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.convert.impl&%17.from_spec.)
  (forall ((v! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 128) $ (UINT 64) v!) (I (uClip
       128 (%I v!)
    )))
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (UINT 128) $ (UINT 64) v!))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%31::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ USIZE $ USIZE) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%31::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ USIZE $ USIZE self! rhs!) (B (= (uClip SZ
        (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%31::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%31.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%31.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ USIZE $ USIZE self! rhs!) (I (uClip SZ (
        Add (%I self!) (%I rhs!)
    ))))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%32::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 8) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%32::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 8) $ (UINT 8) self! rhs!) (B (= (uClip
        8 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%32::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%32.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%32.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 8) $ (UINT 8) self! rhs!) (I (uClip
       8 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%33::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%33.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%33.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 16) $ (UINT 16)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%33::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%33.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%33.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 16) $ (UINT 16) self! rhs!) (B (= (
        uClip 16 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 16) $ (UINT 16) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%33::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%33.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%33.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 16) $ (UINT 16) self! rhs!) (I (uClip
       16 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 16) $ (UINT 16) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%34::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%34.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 32) $ (UINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%34::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%34.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%34.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 32) $ (UINT 32) self! rhs!) (B (= (
        uClip 32 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%34::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%34.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%34.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 32) $ (UINT 32) self! rhs!) (I (uClip
       32 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%35::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 64) $ (UINT 64)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%35::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 64) $ (UINT 64) self! rhs!) (B (= (
        uClip 64 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%35::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%35.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%35.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 64) $ (UINT 64) self! rhs!) (I (uClip
       64 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%36::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%36.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%36.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (UINT 128) $ (UINT 128)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%36::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%36.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%36.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 128) $ (UINT 128) self! rhs!) (B (
       = (uClip 128 (Add (%I self!) (%I rhs!))) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (UINT 128) $ (UINT 128) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%36::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%36.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%36.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 128) $ (UINT 128) self! rhs!) (I
      (uClip 128 (Add (%I self!) (%I rhs!)))
    ))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (UINT 128) $ (UINT 128) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%38::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%38.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%38.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (SINT 8) $ (SINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%38::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%38.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%38.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 8) $ (SINT 8) self! rhs!) (B (= (iClip
        8 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 8) $ (SINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%38::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%38.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%38.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 8) $ (SINT 8) self! rhs!) (I (iClip
       8 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 8) $ (SINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%40::obeys_add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? $ (SINT 32) $ (SINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%40::add_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 32) $ (SINT 32) self! rhs!) (B (= (
        iClip 32 (Add (%I self!) (%I rhs!))
       ) (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%40::add_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%40.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%40.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 32) $ (SINT 32) self! rhs!) (I (iClip
       32 (Add (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%43::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%43.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ USIZE $ USIZE) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%43::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%43.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%43.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ USIZE $ USIZE self! rhs!) (B (= (uClip SZ
        (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%43::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%43.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%43.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ USIZE $ USIZE self! rhs!) (I (uClip SZ (
        Sub (%I self!) (%I rhs!)
    ))))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ USIZE $ USIZE self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%44::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%44.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (UINT 8) $ (UINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%44::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%44.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%44.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 8) $ (UINT 8) self! rhs!) (B (= (uClip
        8 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%44::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%44.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%44.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 8) $ (UINT 8) self! rhs!) (I (uClip
       8 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 8) $ (UINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%45::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%45.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%45.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (UINT 16) $ (UINT 16)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%45::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%45.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%45.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 16) $ (UINT 16) self! rhs!) (B (= (
        uClip 16 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 16) $ (UINT 16) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%45::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%45.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%45.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 16) $ (UINT 16) self! rhs!) (I (uClip
       16 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 16) $ (UINT 16) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%46::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%46.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%46.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (UINT 32) $ (UINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%46::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%46.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%46.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 32) $ (UINT 32) self! rhs!) (B (= (
        uClip 32 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%46::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%46.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%46.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 32) $ (UINT 32) self! rhs!) (I (uClip
       32 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 32) $ (UINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%47::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%47.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (UINT 64) $ (UINT 64)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%47::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%47.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%47.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 64) $ (UINT 64) self! rhs!) (B (= (
        uClip 64 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%47::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%47.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%47.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 64) $ (UINT 64) self! rhs!) (I (uClip
       64 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 64) $ (UINT 64) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%48::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%48.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%48.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (UINT 128) $ (UINT 128)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%48::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%48.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%48.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 128) $ (UINT 128) self! rhs!) (B (
       = (uClip 128 (Sub (%I self!) (%I rhs!))) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (UINT 128) $ (UINT 128) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%48::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%48.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%48.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 128) $ (UINT 128) self! rhs!) (I
      (uClip 128 (Sub (%I self!) (%I rhs!)))
    ))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (UINT 128) $ (UINT 128) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%50::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%50.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%50.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (SINT 8) $ (SINT 8)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%50::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%50.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%50.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (SINT 8) $ (SINT 8) self! rhs!) (B (= (iClip
        8 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (SINT 8) $ (SINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%50::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%50.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%50.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (SINT 8) $ (SINT 8) self! rhs!) (I (iClip
       8 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (SINT 8) $ (SINT 8) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%52::obeys_sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%52.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? $ (SINT 32) $ (SINT 32)) (B true))
))

;; Function-Axioms vstd::std_specs::ops::impl&%52::sub_req
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%52.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%52.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? $ (SINT 32) $ (SINT 32) self! rhs!) (B (= (
        iClip 32 (Sub (%I self!) (%I rhs!))
       ) (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms vstd::std_specs::ops::impl&%52::sub_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.ops.impl&%52.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.ops.impl&%52.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? $ (SINT 32) $ (SINT 32) self! rhs!) (I (iClip
       32 (Sub (%I self!) (%I rhs!))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? $ (SINT 32) $ (SINT 32) self! rhs!))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::option::impl&%3::obeys_cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.impl&%3.obeys_cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.impl&%3.obeys_cmp_spec.)
  (forall ((T&. Dcr) (T& Type)) (!
    (=>
     (and
      (sized T&.)
      (tr_bound%vstd!std_specs.cmp.OrdSpec. T&. T&)
     )
     (= (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? $ (TYPE%core!option.Option. T&. T&))
      (vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? T&. T&)
    ))
    :pattern ((vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.? $ (TYPE%core!option.Option. T&.
       T&
    )))
    :qid internal_vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.obeys_cmp_spec.?_definition
))))

;; Function-Axioms vstd::std_specs::option::impl&%3::cmp_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.impl&%3.cmp_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.impl&%3.cmp_spec.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (other! Poly)) (!
    (=>
     (and
      (sized T&.)
      (tr_bound%vstd!std_specs.cmp.OrdSpec. T&. T&)
     )
     (= (vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (TYPE%core!option.Option. T&. T&) self!
       other!
      ) (Poly%core!cmp.Ordering. (let
        ((tmp%%$ (tuple%2./tuple%2 self! other!)))
        (ite
         (and
          (and
           (is-tuple%2./tuple%2 tmp%%$)
           (is-core!option.Option./None (%Poly%core!option.Option. (tuple%2./tuple%2/0 (%Poly%tuple%2.
               (Poly%tuple%2. tmp%%$)
          )))))
          (is-core!option.Option./None (%Poly%core!option.Option. (tuple%2./tuple%2/1 (%Poly%tuple%2.
              (Poly%tuple%2. tmp%%$)
         )))))
         core!cmp.Ordering./Equal
         (ite
          (and
           (and
            (is-tuple%2./tuple%2 tmp%%$)
            (is-core!option.Option./None (%Poly%core!option.Option. (tuple%2./tuple%2/0 (%Poly%tuple%2.
                (Poly%tuple%2. tmp%%$)
           )))))
           (is-core!option.Option./Some (%Poly%core!option.Option. (tuple%2./tuple%2/1 (%Poly%tuple%2.
               (Poly%tuple%2. tmp%%$)
          )))))
          core!cmp.Ordering./Less
          (ite
           (and
            (and
             (is-tuple%2./tuple%2 tmp%%$)
             (is-core!option.Option./Some (%Poly%core!option.Option. (tuple%2./tuple%2/0 (%Poly%tuple%2.
                 (Poly%tuple%2. tmp%%$)
            )))))
            (is-core!option.Option./None (%Poly%core!option.Option. (tuple%2./tuple%2/1 (%Poly%tuple%2.
                (Poly%tuple%2. tmp%%$)
           )))))
           core!cmp.Ordering./Greater
           (%Poly%core!cmp.Ordering. (let
             ((x$ (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. (tuple%2./tuple%2/0
                  (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))
             )))))
             (let
              ((y$ (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. (tuple%2./tuple%2/1
                   (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))
              )))))
              (vstd!std_specs.cmp.OrdSpec.cmp_spec.? T&. T& x$ y$)
    ))))))))))
    :pattern ((vstd!std_specs.cmp.OrdSpec.cmp_spec.? $ (TYPE%core!option.Option. T&. T&)
      self! other!
    ))
    :qid internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.cmp.OrdSpec.cmp_spec.?_definition
))))

;; Function-Axioms vstd::seq::impl&%0::skip
(assert
 (fuel_bool_default fuel%vstd!seq.impl&%0.skip.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!seq.impl&%0.skip.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (n! Poly)) (!
    (= (vstd!seq.impl&%0.skip.? A&. A& self! n!) (vstd!seq.Seq.subrange.? A&. A& self!
      n! (I (vstd!seq.Seq.len.? A&. A& self!))
    ))
    :pattern ((vstd!seq.impl&%0.skip.? A&. A& self! n!))
    :qid internal_vstd!seq.impl&__0.skip.?_definition
    :skolemid skolem_internal_vstd!seq.impl&__0.skip.?_definition
))))
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type n! INT)
    )
    (has_type (vstd!seq.impl&%0.skip.? A&. A& self! n!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.impl&%0.skip.? A&. A& self! n!))
   :qid internal_vstd!seq.impl&__0.skip.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.impl&__0.skip.?_pre_post_definition
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

;; Function-Axioms vstd::view::impl&%10::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%10.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%10.view.)
  (forall ((T&. Dcr) (T& Type) (self! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!view.View.view.? $ (TYPE%core!option.Option. T&. T&) self!) self!)
    )
    :pattern ((vstd!view.View.view.? $ (TYPE%core!option.Option. T&. T&) self!))
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

;; Function-Axioms vstd::view::impl&%18::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%18.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%18.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 16) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 16) self!))
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

;; Function-Axioms vstd::view::impl&%24::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%24.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%24.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (UINT 128) self!) self!)
    :pattern ((vstd!view.View.view.? $ (UINT 128) self!))
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

;; Function-Axioms vstd::view::impl&%28::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%28.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%28.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ (SINT 8) self!) self!)
    :pattern ((vstd!view.View.view.? $ (SINT 8) self!))
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

;; Function-Axioms vstd::view::impl&%42::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%42.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%42.view.)
  (forall ((A0&. Dcr) (A0& Type) (self! Poly)) (!
    (=>
     (and
      (sized A0&.)
      (tr_bound%vstd!view.View. A0&. A0&)
     )
     (= (vstd!view.View.view.? (DST A0&.) (TYPE%tuple%1. A0&. A0&) self!) (Poly%tuple%1.
       (tuple%1./tuple%1 (vstd!view.View.view.? A0&. A0& (tuple%1./tuple%1/0 (%Poly%tuple%1.
           self!
    )))))))
    :pattern ((vstd!view.View.view.? (DST A0&.) (TYPE%tuple%1. A0&. A0&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%44::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%44.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%44.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (self! Poly)) (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
     )
     (= (vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!) (Poly%tuple%2.
       (tuple%2./tuple%2 (vstd!view.View.view.? A0&. A0& (tuple%2./tuple%2/0 (%Poly%tuple%2.
           self!
         ))
        ) (vstd!view.View.view.? A1&. A1& (tuple%2./tuple%2/1 (%Poly%tuple%2. self!)))
    ))))
    :pattern ((vstd!view.View.view.? (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&) self!))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%46::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%46.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%46.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (self! Poly))
   (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (sized A2&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
      (tr_bound%vstd!view.View. A2&. A2&)
     )
     (= (vstd!view.View.view.? (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&) self!)
      (Poly%tuple%3. (tuple%3./tuple%3 (vstd!view.View.view.? A0&. A0& (tuple%3./tuple%3/0
          (%Poly%tuple%3. self!)
         )
        ) (vstd!view.View.view.? A1&. A1& (tuple%3./tuple%3/1 (%Poly%tuple%3. self!))) (vstd!view.View.view.?
         A2&. A2& (tuple%3./tuple%3/2 (%Poly%tuple%3. self!))
    )))))
    :pattern ((vstd!view.View.view.? (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&)
      self!
    ))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::view::impl&%48::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%48.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%48.view.)
  (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
    (A3& Type) (self! Poly)
   ) (!
    (=>
     (and
      (sized A0&.)
      (sized A1&.)
      (sized A2&.)
      (sized A3&.)
      (tr_bound%vstd!view.View. A0&. A0&)
      (tr_bound%vstd!view.View. A1&. A1&)
      (tr_bound%vstd!view.View. A2&. A2&)
      (tr_bound%vstd!view.View. A3&. A3&)
     )
     (= (vstd!view.View.view.? (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
        A3&
       ) self!
      ) (Poly%tuple%4. (tuple%4./tuple%4 (vstd!view.View.view.? A0&. A0& (tuple%4./tuple%4/0
          (%Poly%tuple%4. self!)
         )
        ) (vstd!view.View.view.? A1&. A1& (tuple%4./tuple%4/1 (%Poly%tuple%4. self!))) (vstd!view.View.view.?
         A2&. A2& (tuple%4./tuple%4/2 (%Poly%tuple%4. self!))
        ) (vstd!view.View.view.? A3&. A3& (tuple%4./tuple%4/3 (%Poly%tuple%4. self!)))
    ))))
    :pattern ((vstd!view.View.view.? (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2&
       A3&. A3&
      ) self!
    ))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::obeys_add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (B true)
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::add_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (B (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? self! rhs! (I 18446744073709551615)))
    )
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_add_fe51_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
      (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Add (%I (vstd!seq.Seq.index.?
              $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
                (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                  a!
               )))
              ) (I 0)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 0)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 1)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 1)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 2)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 2)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 3)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 3)
          ))))
         ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
               ))
              ) (I 4)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
               ))
              ) (I 4)
    ))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type b! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       a! b!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%5::add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%5.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       self! rhs!
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%8::obeys_sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
    (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ) (B true)
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%8::sub_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (B (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 54))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? rhs! (I 54))
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_sub_limbs
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_sub_limbs.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_sub_limbs.? a! b!) (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
      (%Poly%array%. (Poly%array%. (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (
          array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (
                  UINT 64
                 ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 0)
                )
               ) 36028797018963664
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 0)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 1)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 1)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 2)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 2)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 3)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 3)
            ))))
           ) (I (uClip 64 (Sub (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                  (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. a!)
                  ))
                 ) (I 4)
                )
               ) 36028797018963952
              ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. b!)
                 ))
                ) (I 4)
    ))))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_sub_limbs.? a! b!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
     (has_type b! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    )
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_sub_limbs.?
       a! b!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.field_specs.spec_sub_limbs.? a! b!))
   :qid internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_sub_limbs.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::backend::serial::u64::field::impl&%8::sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.field.impl&%8.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
     ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_sub_limbs.?
       self! rhs!
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_scalar_mul_signed
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.)
  (forall ((point_affine! Poly) (n! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? point_affine!
      n!
     ) (ite
      (>= (%I n!) 0)
      (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine! (I (nClip (
          %I n!
      ))))
      (let
       ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? point_affine! (I
           (nClip (Sub 0 (%I n!)))
       ))))
       (let
        ((x$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
        (let
         ((y$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
         (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_neg.? (I x$))) (I y$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? point_affine!
      n!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_definition
))))
(assert
 (forall ((point_affine! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type point_affine! (TYPE%tuple%2. $ NAT $ NAT))
     (has_type n! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
       point_affine! n!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? point_affine!
     n!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_niels_point_as_affine_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      niels!
     ) (let
      ((y_plus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
           (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
      )))))
      (let
       ((y_minus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
            (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
       )))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
             (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
        )))))
        (let
         ((x_proj$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
              (I y_plus_x$) (I y_minus_x$)
             )
            ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
         )))
         (let
          ((y_proj$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
               (I y_plus_x$) (I y_minus_x$)
              )
             ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
          )))
          (let
           ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z$))))
           (let
            ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I x_proj$) (I z_inv$))))
            (let
             ((y$ (curve25519_dalek!specs.field_specs.field_mul.? (I y_proj$) (I z_inv$))))
             (tuple%2./tuple%2 (I x$) (I y$))
    )))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      niels!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_definition
))))
(assert
 (forall ((niels! Poly)) (!
   (=>
    (has_type niels! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
       niels!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
     niels!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::is_valid_radix_2w
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.)
  (forall ((digits! Poly) (w! Poly) (digits_count! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.? digits! w! digits_count!)
     (and
      (and
       (let
        ((tmp%%$ (%I w!)))
        (and
         (<= 4 tmp%%$)
         (<= tmp%%$ 8)
       ))
       (<= (%I digits_count!) 64)
      )
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (%I digits_count!))
          ))
          (let
           ((bound$ (vstd!arithmetic.power2.pow2.? (I (nClip (Sub (%I w!) 1))))))
           (ite
            (< (%I i$) (Sub (%I digits_count!) 1))
            (and
             (<= (Sub 0 bound$) (%I (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY
                  $ (SINT 8) $ (CONST_INT 64)
                 ) digits!
                ) i$
             )))
             (< (%I (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8) $ (
                   CONST_INT 64
                  )
                 ) digits!
                ) i$
               )
              ) bound$
            ))
            (and
             (<= (Sub 0 bound$) (%I (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY
                  $ (SINT 8) $ (CONST_INT 64)
                 ) digits!
                ) i$
             )))
             (<= (%I (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8) $
                  (CONST_INT 64)
                 ) digits!
                ) i$
               )
              ) bound$
        ))))))
        :pattern ((vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8)
            $ (CONST_INT 64)
           ) digits!
          ) i$
         ) (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8) $ (CONST_INT
             64
            )
           ) digits!
          ) i$
         ) (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8) $ (CONST_INT
             64
            )
           ) digits!
          ) i$
         ) (vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8) $ (CONST_INT
             64
            )
           ) digits!
          ) i$
        ))
        :qid user_curve25519_dalek__specs__scalar_specs__is_valid_radix_2w_34
        :skolemid skolem_user_curve25519_dalek__specs__scalar_specs__is_valid_radix_2w_34
    ))))
    :pattern ((curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.? digits! w! digits_count!))
    :qid internal_curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_niels_corresponds_to_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.)
  (forall ((niels! Poly) (point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
      niels! point!
     ) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
           ))))
           (let
            ((y_plus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
                 (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
            )))))
            (let
             ((y_minus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                 (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
                  (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
             )))))
             (let
              ((niels_z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                  (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
                   (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
              )))))
              (let
               ((t2d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                   (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
                    (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. niels!)
               )))))
               (and
                (and
                 (and
                  (= y_plus_x$ (curve25519_dalek!specs.field_specs.field_add.? (I y$) (I x$)))
                  (= y_minus_x$ (curve25519_dalek!specs.field_specs.field_sub.? (I y$) (I x$)))
                 )
                 (= niels_z$ z$)
                )
                (= t2d$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                    (I 2) (I d$)
                   )
                  ) (I t$)
    ))))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
      niels! point!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_projective_niels_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? niels!)
     (exists ((point$ Poly)) (!
       (and
        (has_type point$ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
        (and
         (and
          (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point$)
          (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point$)
         )
         (curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.? niels!
          point$
       )))
       :pattern ((curve25519_dalek!specs.edwards_specs.projective_niels_corresponds_to_edwards.?
         niels! point$
       ))
       :qid user_curve25519_dalek__specs__edwards_specs__is_valid_projective_niels_point_35
       :skolemid skolem_user_curve25519_dalek__specs__edwards_specs__is_valid_projective_niels_point_35
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? niels!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_sub
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_sub.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_sub.)
  (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_sub.? x1! y1! x2! y2!) (curve25519_dalek!specs.edwards_specs.edwards_add.?
      x1! y1! (I (curve25519_dalek!specs.field_specs.field_neg.? x2!)) y2!
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_sub.? x1! y1! x2! y2!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_sub.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_sub.?_definition
))))
(assert
 (forall ((x1! Poly) (y1! Poly) (x2! Poly) (y2! Poly)) (!
   (=>
    (and
     (has_type x1! NAT)
     (has_type y1! NAT)
     (has_type x2! NAT)
     (has_type y2! NAT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_sub.? x1! y1!
       x2! y2!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_sub.? x1! y1! x2! y2!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_sub.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_sub.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_column_sum
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.
 Fuel
)
(assert
 (forall ((points_affine! Poly) (digits! Poly) (j! Poly) (n! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.? points_affine!
     digits! j! n! fuel%
    ) (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.? points_affine!
     digits! j! n! zero
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
     points_affine! digits! j! n! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum._fuel_to_zero_definition
)))
(assert
 (forall ((points_affine! Poly) (digits! Poly) (j! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type j! INT)
     (has_type n! INT)
    )
    (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.? points_affine!
      digits! j! n! (succ fuel%)
     ) (ite
      (<= (%I n!) 0)
      (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
      (let
       ((prev$ (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
          points_affine! digits! j! (I (Sub (%I n!) 1)) fuel%
       )))
       (let
        ((term$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (vstd!seq.Seq.index.?
            (DST $) (TYPE%tuple%2. $ NAT $ NAT) points_affine! (I (Sub (%I n!) 1))
           ) (vstd!seq.Seq.index.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT
               8
              )
             ) digits! (I (Sub (%I n!) 1))
            ) j!
        ))))
        (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
           (Poly%tuple%2. prev$)
          )
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. term$))
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. term$)))
   ))))))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
     points_affine! digits! j! n! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.)
  (forall ((points_affine! Poly) (digits! Poly) (j! Poly) (n! Poly)) (!
    (=>
     (and
      (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
      (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
      (has_type j! INT)
      (has_type n! INT)
     )
     (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? points_affine!
       digits! j! n!
      ) (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.? points_affine!
       digits! j! n! (succ fuel_nat%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.)
    )))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
      points_affine! digits! j! n!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?_definition
))))
(assert
 (forall ((points_affine! Poly) (digits! Poly) (j! Poly) (n! Poly)) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type j! INT)
     (has_type n! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
       points_affine! digits! j! n!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
     points_affine! digits! j! n!
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?_pre_post_definition
)))
(assert
 (forall ((points_affine! Poly) (digits! Poly) (j! Poly) (n! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type j! INT)
     (has_type n! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
       points_affine! digits! j! n! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec%straus_column_sum.?
     points_affine! digits! j! n! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec__straus_column_sum.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.rec__straus_column_sum.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_ct_partial
(assert
 (forall ((points_affine! Poly) (digits! Poly) (from_j! Poly)) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type digits! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type from_j! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_partial.?
       points_affine! digits! from_j!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_partial.?
     points_affine! digits! from_j!
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_partial.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_partial.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_vt_partial
(assert
 (forall ((points_affine! Poly) (nafs! Poly) (from_i! Poly)) (!
   (=>
    (and
     (has_type points_affine! (TYPE%vstd!seq.Seq. (DST $) (TYPE%tuple%2. $ NAT $ NAT)))
     (has_type nafs! (TYPE%vstd!seq.Seq. $ (TYPE%vstd!seq.Seq. $ (SINT 8))))
     (has_type from_i! INT)
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_partial.?
       points_affine! nafs! from_i!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_partial.?
     points_affine! nafs! from_i!
   ))
   :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_partial.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_partial.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::radix_16_all_bounded_seq
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.radix_16_all_bounded_seq.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.radix_16_all_bounded_seq.)
  (forall ((digits! Poly)) (!
    (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.radix_16_all_bounded_seq.?
      digits!
     ) (forall ((k$ Poly)) (!
       (=>
        (has_type k$ INT)
        (=>
         (let
          ((tmp%%$ (%I k$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!seq.Seq.len.? $ (SINT 8) digits!))
         ))
         (let
          ((tmp%%$ (%I (vstd!seq.Seq.index.? $ (SINT 8) digits! k$))))
          (and
           (<= (Sub 0 8) tmp%%$)
           (<= tmp%%$ 8)
       ))))
       :pattern ((vstd!seq.Seq.index.? $ (SINT 8) digits! k$))
       :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__radix_16_all_bounded_seq_36
       :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__radix_16_all_bounded_seq_36
    )))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.radix_16_all_bounded_seq.?
      digits!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.radix_16_all_bounded_seq.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.radix_16_all_bounded_seq.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::is_valid_naf
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.is_valid_naf.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.is_valid_naf.)
  (forall ((naf! Poly) (w! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.is_valid_naf.? naf! w!) (forall ((i$ Poly))
      (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!seq.Seq.len.? $ (SINT 8) naf!))
         ))
         (let
          ((digit$ (%I (vstd!seq.Seq.index.? $ (SINT 8) naf! i$))))
          (and
           (or
            (= digit$ 0)
            (and
             (and
              (not (= (EucMod digit$ 2) 0))
              (< (Sub 0 (vstd!arithmetic.power2.pow2.? (I (nClip (Sub (%I w!) 1))))) digit$)
             )
             (< digit$ (vstd!arithmetic.power2.pow2.? (I (nClip (Sub (%I w!) 1)))))
           ))
           (forall ((j$ Int)) (!
             (=>
              (and
               (let
                ((tmp%%$ j$))
                (and
                 (<= 1 tmp%%$)
                 (< tmp%%$ (%I w!))
               ))
               (< (Add (%I i$) j$) (vstd!seq.Seq.len.? $ (SINT 8) naf!))
              )
              (not (and
                (not (= digit$ 0))
                (not (= (%I (vstd!seq.Seq.index.? $ (SINT 8) naf! (I (Add (%I i$) j$)))) 0))
             )))
             :pattern ((Add (%I i$) j$) (Add (%I i$) j$))
             :qid user_curve25519_dalek__specs__scalar_specs__is_valid_naf_37
             :skolemid skolem_user_curve25519_dalek__specs__scalar_specs__is_valid_naf_37
       ))))))
       :pattern ((vstd!seq.Seq.index.? $ (SINT 8) naf! i$))
       :qid user_curve25519_dalek__specs__scalar_specs__is_valid_naf_38
       :skolemid skolem_user_curve25519_dalek__specs__scalar_specs__is_valid_naf_38
    )))
    :pattern ((curve25519_dalek!specs.scalar_specs.is_valid_naf.? naf! w!))
    :qid internal_curve25519_dalek!specs.scalar_specs.is_valid_naf.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.is_valid_naf.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table5_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.)
  (forall ((table! Poly) (A! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.? table!
      A!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
           (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              $ (CONST_INT 8)
             ) table!
            ) j$
           )
          ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
             A!
            )
           ) (I (nClip (Add (Mul 2 (%I j$)) 1)))
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table5_projective_39
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table5_projective_39
    )))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.?
      table! A!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::naf_lookup_table5_projective_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.)
  (forall ((table! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
      table!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (let
          ((entry$ (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (
              vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                $ (CONST_INT 8)
               ) table!
              ) j$
          ))))
          (and
           (and
            (and
             (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
                (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  entry$
               )))
              ) (I 54)
             )
             (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
                (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  entry$
               )))
              ) (I 54)
            ))
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
               (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                 entry$
              )))
             ) (I 54)
           ))
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
              (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                entry$
             )))
            ) (I 54)
       )))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__naf_lookup_table5_projective_limbs_bounded_40
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__naf_lookup_table5_projective_limbs_bounded_40
    )))
    :pattern ((curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
      table!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_vt_input_valid
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_input_valid.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_input_valid.)
  (forall ((nafs_view! Poly) (lookup_tables_view! Poly) (nafs_seqs! Poly) (pts_affine!
     Poly
    ) (spec_scalars! Poly) (spec_points! Poly) (unwrapped_points! Poly) (n! Poly)
   ) (!
    (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_input_valid.? nafs_view!
      lookup_tables_view! nafs_seqs! pts_affine! spec_scalars! spec_points! unwrapped_points!
      n!
     ) (let
      ((n_int$ (%I n!)))
      (and
       (and
        (and
         (and
          (and
           (and
            (and
             (and
              (and
               (and
                (and
                 (= (vstd!seq.Seq.len.? $ (ARRAY $ (SINT 8) $ (CONST_INT 256)) nafs_view!) n_int$)
                 (= (vstd!seq.Seq.len.? $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                   lookup_tables_view!
                  ) n_int$
                ))
                (= (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) nafs_seqs!) n_int$)
               )
               (= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) pts_affine!) n_int$)
              )
              (= n_int$ (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. spec_scalars!))
             )
             (= n_int$ (vstd!seq.Seq.len.? $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
               spec_points!
            )))
            (forall ((k$ Poly)) (!
              (=>
               (has_type k$ INT)
               (=>
                (let
                 ((tmp%%$ (%I k$)))
                 (and
                  (<= 0 tmp%%$)
                  (< tmp%%$ n_int$)
                ))
                (curve25519_dalek!specs.scalar_specs.is_valid_naf.? (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq.
                   $ (SINT 8)
                  ) nafs_seqs! k$
                 ) (I 5)
              )))
              :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) nafs_seqs! k$))
              :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_41
              :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_41
           )))
           (forall ((k$ Poly)) (!
             (=>
              (has_type k$ INT)
              (=>
               (let
                ((tmp%%$ (%I k$)))
                (and
                 (<= 0 tmp%%$)
                 (< tmp%%$ n_int$)
               ))
               (and
                (and
                 (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.? (Poly%array%.
                   (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
                     (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                      lookup_tables_view! k$
                   )))
                  ) (core!option.Option./Some/0 $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (%Poly%core!option.Option.
                    (vstd!seq.Seq.index.? $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
                     spec_points! k$
                 ))))
                 (curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
                  (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
                     (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                      lookup_tables_view! k$
                ))))))
                (forall ((j$ Poly)) (!
                  (=>
                   (has_type j$ INT)
                   (=>
                    (let
                     ((tmp%%$ (%I j$)))
                     (and
                      (<= 0 tmp%%$)
                      (< tmp%%$ 8)
                    ))
                    (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
                      $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
                       $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                        $ (CONST_INT 8)
                       ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
                          (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                           lookup_tables_view! k$
                       ))))
                      ) j$
                  ))))
                  :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                    (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                      $ (CONST_INT 8)
                     ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
                        (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                         lookup_tables_view! k$
                     ))))
                    ) j$
                  ))
                  :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_42
                  :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_42
             )))))
             :pattern ((vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
               lookup_tables_view! k$
             ))
             :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_43
             :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_43
          )))
          (forall ((k$ Poly)) (!
            (=>
             (has_type k$ INT)
             (=>
              (let
               ((tmp%%$ (%I k$)))
               (and
                (<= 0 tmp%%$)
                (< tmp%%$ n_int$)
              ))
              (= (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) pts_affine!
                 k$
                )
               ) (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (vstd!seq.Seq.index.?
                 $ TYPE%curve25519_dalek!edwards.EdwardsPoint. unwrapped_points! k$
            )))))
            :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) pts_affine! k$))
            :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_44
            :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_44
         )))
         (forall ((k$ Poly)) (!
           (=>
            (has_type k$ INT)
            (=>
             (let
              ((tmp%%$ (%I k$)))
              (and
               (<= 0 tmp%%$)
               (< tmp%%$ n_int$)
             ))
             (= (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. unwrapped_points!
               k$
              ) (core!option.Option./Some/0 $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (%Poly%core!option.Option.
                (vstd!seq.Seq.index.? $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
                 spec_points! k$
           ))))))
           :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. unwrapped_points!
             k$
           ))
           :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_45
           :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_45
        )))
        (forall ((k$ Poly)) (!
          (=>
           (has_type k$ INT)
           (=>
            (let
             ((tmp%%$ (%I k$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ n_int$)
            ))
            (= (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) nafs_seqs! k$) (vstd!view.View.view.?
              $ (ARRAY $ (SINT 8) $ (CONST_INT 256)) (vstd!seq.Seq.index.? $ (ARRAY $ (SINT 8) $
                (CONST_INT 256)
               ) nafs_view! k$
          )))))
          :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) nafs_seqs! k$))
          :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_46
          :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_46
       )))
       (forall ((k$ Poly)) (!
         (=>
          (has_type k$ INT)
          (=>
           (let
            ((tmp%%$ (%I k$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ n_int$)
           ))
           (and
            (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                  $ NAT $ NAT
                 ) pts_affine! k$
              )))
             ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
            )
            (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                  $ NAT $ NAT
                 ) pts_affine! k$
              )))
             ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
         ))))
         :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) pts_affine! k$))
         :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_47
         :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_vt_input_valid_47
    )))))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_input_valid.?
      nafs_view! lookup_tables_view! nafs_seqs! pts_affine! spec_scalars! spec_points!
      unwrapped_points! n!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_input_valid.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_input_valid.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_lookup_table_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.)
  (forall ((N&. Dcr) (N& Type) (table! Poly) (P! Poly) (size! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.? N&. N& table!
      P! size!
     ) (and
      (= (vstd!slice.spec_slice_len.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
        (vstd!array.spec_array_as_slice.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         N&. N& table!
        )
       ) (%I size!)
      )
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (%I size!))
          ))
          (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
            (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
               N&. N&
              ) table!
             ) j$
            )
           ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
              P!
             )
            ) (I (nClip (Add (%I j$) 1)))
        ))))
        :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            N&. N&
           ) table!
          ) j$
        ))
        :qid user_curve25519_dalek__specs__window_specs__is_valid_lookup_table_projective_48
        :skolemid skolem_user_curve25519_dalek__specs__window_specs__is_valid_lookup_table_projective_48
    ))))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.? N&.
      N& table! P! size!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::lookup_table_projective_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.)
  (forall ((N&. Dcr) (N& Type) (table! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.? N&.
      N& table!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!slice.spec_slice_len.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             (vstd!array.spec_array_as_slice.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              N&. N& table!
         )))))
         (let
          ((entry$ (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (
              vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                N&. N&
               ) table!
              ) j$
          ))))
          (and
           (and
            (and
             (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
                (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  entry$
               )))
              ) (I 54)
             )
             (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
                (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  entry$
               )))
              ) (I 54)
            ))
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
               (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                 entry$
              )))
             ) (I 54)
           ))
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
              (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                entry$
             )))
            ) (I 54)
       )))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           N&. N&
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__lookup_table_projective_limbs_bounded_49
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__lookup_table_projective_limbs_bounded_49
    )))
    :pattern ((curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.?
      N&. N& table!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::radix_16_digit_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.radix_16_digit_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.radix_16_digit_bounded.)
  (forall ((digit! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.radix_16_digit_bounded.? digit!) (and
      (<= (Sub 0 8) (%I digit!))
      (<= (%I digit!) 8)
    ))
    :pattern ((curve25519_dalek!specs.scalar_specs.radix_16_digit_bounded.? digit!))
    :qid internal_curve25519_dalek!specs.scalar_specs.radix_16_digit_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.radix_16_digit_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::radix_16_all_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.radix_16_all_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.radix_16_all_bounded.)
  (forall ((digits! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.radix_16_all_bounded.? digits!) (forall ((i$
        Poly
       )
      ) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 64)
         ))
         (curve25519_dalek!specs.scalar_specs.radix_16_digit_bounded.? (vstd!seq.Seq.index.?
           $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8) $ (CONST_INT 64)) digits!)
           i$
       ))))
       :pattern ((vstd!seq.Seq.index.? $ (SINT 8) (vstd!view.View.view.? $ (ARRAY $ (SINT 8)
           $ (CONST_INT 64)
          ) digits!
         ) i$
       ))
       :qid user_curve25519_dalek__specs__scalar_specs__radix_16_all_bounded_50
       :skolemid skolem_user_curve25519_dalek__specs__scalar_specs__radix_16_all_bounded_50
    )))
    :pattern ((curve25519_dalek!specs.scalar_specs.radix_16_all_bounded.? digits!))
    :qid internal_curve25519_dalek!specs.scalar_specs.radix_16_all_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.radix_16_all_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::straus_ct_input_valid
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_input_valid.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_input_valid.)
  (forall ((scalar_digits_view! Poly) (lookup_tables_view! Poly) (digits_seqs! Poly)
    (pts_affine! Poly) (spec_scalars! Poly) (spec_points! Poly) (n! Poly)
   ) (!
    (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_input_valid.? scalar_digits_view!
      lookup_tables_view! digits_seqs! pts_affine! spec_scalars! spec_points! n!
     ) (let
      ((n_int$ (%I n!)))
      (and
       (and
        (and
         (and
          (and
           (and
            (and
             (and
              (and
               (= (vstd!seq.Seq.len.? $ (ARRAY $ (SINT 8) $ (CONST_INT 64)) scalar_digits_view!)
                n_int$
               )
               (= (vstd!seq.Seq.len.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                 lookup_tables_view!
                ) n_int$
              ))
              (= (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) digits_seqs!) n_int$)
             )
             (= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) pts_affine!) n_int$)
            )
            (= n_int$ (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. spec_scalars!))
           )
           (= n_int$ (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. spec_points!))
          )
          (forall ((k$ Poly)) (!
            (=>
             (has_type k$ INT)
             (=>
              (let
               ((tmp%%$ (%I k$)))
               (and
                (<= 0 tmp%%$)
                (< tmp%%$ n_int$)
              ))
              (and
               (and
                (curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.? $ (CONST_INT
                  8
                 ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                    (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                     lookup_tables_view! k$
                  )))
                 ) (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. spec_points!
                  k$
                 ) (I 8)
                )
                (curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.? $ (CONST_INT
                  8
                 ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                    (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                     lookup_tables_view! k$
               ))))))
               (forall ((j$ Poly)) (!
                 (=>
                  (has_type j$ INT)
                  (=>
                   (let
                    ((tmp%%$ (%I j$)))
                    (and
                     (<= 0 tmp%%$)
                     (< tmp%%$ 8)
                   ))
                   (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
                     $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
                      $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                       $ (CONST_INT 8)
                      ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                         (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                          lookup_tables_view! k$
                      ))))
                     ) j$
                 ))))
                 :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                   (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                     $ (CONST_INT 8)
                    ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                       (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                        lookup_tables_view! k$
                    ))))
                   ) j$
                 ))
                 :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_ct_input_valid_51
                 :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_ct_input_valid_51
            )))))
            :pattern ((vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
              lookup_tables_view! k$
            ))
            :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_ct_input_valid_52
            :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_ct_input_valid_52
         )))
         (forall ((k$ Poly)) (!
           (=>
            (has_type k$ INT)
            (=>
             (let
              ((tmp%%$ (%I k$)))
              (and
               (<= 0 tmp%%$)
               (< tmp%%$ n_int$)
             ))
             (curve25519_dalek!specs.scalar_specs.radix_16_all_bounded.? (vstd!seq.Seq.index.? $
               (ARRAY $ (SINT 8) $ (CONST_INT 64)) scalar_digits_view! k$
           ))))
           :pattern ((vstd!seq.Seq.index.? $ (ARRAY $ (SINT 8) $ (CONST_INT 64)) scalar_digits_view!
             k$
           ))
           :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_ct_input_valid_53
           :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_ct_input_valid_53
        )))
        (forall ((k$ Poly)) (!
          (=>
           (has_type k$ INT)
           (=>
            (let
             ((tmp%%$ (%I k$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ n_int$)
            ))
            (= (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) pts_affine!
               k$
              )
             ) (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (vstd!seq.Seq.index.?
               $ TYPE%curve25519_dalek!edwards.EdwardsPoint. spec_points! k$
          )))))
          :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) pts_affine! k$))
          :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_ct_input_valid_54
          :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_ct_input_valid_54
       )))
       (forall ((k$ Poly)) (!
         (=>
          (has_type k$ INT)
          (=>
           (let
            ((tmp%%$ (%I k$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ n_int$)
           ))
           (= (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) digits_seqs! k$) (vstd!view.View.view.?
             $ (ARRAY $ (SINT 8) $ (CONST_INT 64)) (vstd!seq.Seq.index.? $ (ARRAY $ (SINT 8) $ (
                CONST_INT 64
               )
              ) scalar_digits_view! k$
         )))))
         :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) digits_seqs! k$))
         :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_ct_input_valid_55
         :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__straus_ct_input_valid_55
    )))))
    :pattern ((curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_input_valid.?
      scalar_digits_view! lookup_tables_view! digits_seqs! pts_affine! spec_scalars! spec_points!
      n!
    ))
    :qid internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_input_valid.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_input_valid.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%28::obeys_add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
    (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%28::add_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
     ) (B (and
       (and
        (and
         (and
          (and
           (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? self!)
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
              (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
             )
            ) (I 54)
          ))
          (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
             (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
            )
           ) (I 54)
         ))
         (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
            (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
           )
          ) (I 54)
        ))
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
           (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
          )
         ) (I 54)
       ))
       (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? rhs!)
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%28::add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%28.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    )
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%30::obeys_sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
    (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%30::sub_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
     ) (B (and
       (and
        (and
         (and
          (and
           (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? self!)
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
              (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
             )
            ) (I 54)
          ))
          (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
             (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
            )
           ) (I 54)
         ))
         (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
            (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
           )
          ) (I 54)
        ))
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
           (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. rhs!)
          )
         ) (I 54)
       ))
       (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? rhs!)
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%30::sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%30.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    )
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%32::obeys_add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
    (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_z_sum_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.? point!) (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.?
      (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_z.?
        point!
       )
      ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_z.?
        point!
       )
      ) (I 18446744073709551615)
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::affine_niels_corresponds_to_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.)
  (forall ((niels! Poly) (point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.? niels!
      point!
     ) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? point!)))
      (let
       ((x_proj$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y_proj$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z_proj$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((_t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
               curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
           ))))
           (let
            ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z_proj$))))
            (let
             ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I x_proj$) (I z_inv$))))
             (let
              ((y$ (curve25519_dalek!specs.field_specs.field_mul.? (I y_proj$) (I z_inv$))))
              (let
               ((y_plus_x_niels$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                   (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
                    (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
               )))))
               (let
                ((y_minus_x_niels$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                    (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
                     (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
                )))))
                (let
                 ((xy2d_niels$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
                     (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
                      (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
                 )))))
                 (and
                  (and
                   (= y_plus_x_niels$ (curve25519_dalek!specs.field_specs.field_add.? (I y$) (I x$)))
                   (= y_minus_x_niels$ (curve25519_dalek!specs.field_specs.field_sub.? (I y$) (I x$)))
                  )
                  (= xy2d_niels$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_mul.?
                      (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I y$))) (I 2)
                     )
                    ) (I d$)
    ))))))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?
      niels! point!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_affine_niels_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? niels!) (exists
      ((point$ Poly)) (!
       (and
        (has_type point$ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
        (and
         (and
          (and
           (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? point$)
           (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? point$)
          )
          (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_y.? point$)
           ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.edwards_specs.edwards_x.?
             point$
            )
           ) (I 18446744073709551615)
         ))
         (curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.? niels!
          point$
       )))
       :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_corresponds_to_edwards.?
         niels! point$
       ))
       :qid user_curve25519_dalek__specs__edwards_specs__is_valid_affine_niels_point_56
       :skolemid skolem_user_curve25519_dalek__specs__edwards_specs__is_valid_affine_niels_point_56
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? niels!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%32::add_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
     ) (B (and
       (and
        (and
         (and
          (and
           (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? self!)
           (curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.? self!)
          )
          (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
             (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. rhs!)
            )
           ) (I 54)
         ))
         (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
            (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. rhs!)
           )
          ) (I 54)
        ))
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
           (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. rhs!)
          )
         ) (I 54)
       ))
       (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? rhs!)
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%32::add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%32.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    )
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%34::obeys_sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
    (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%34::sub_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
     ) (B (and
       (and
        (and
         (and
          (and
           (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? self!)
           (curve25519_dalek!specs.edwards_specs.edwards_z_sum_bounded.? self!)
          )
          (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
             (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. rhs!)
            )
           ) (I 54)
         ))
         (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
            (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. rhs!)
           )
          ) (I 54)
        ))
        (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
           (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. rhs!)
          )
         ) (I 54)
       ))
       (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? rhs!)
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms curve25519_dalek::backend::serial::curve_models::impl&%34::sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.curve_models.impl&%34.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    )
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self!
      rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::affine_niels_point_as_affine_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.)
  (forall ((niels! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.? niels!)
     (let
      ((y_plus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
           (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
      )))))
      (let
       ((y_minus_x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
            (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. niels!)
       )))))
       (let
        ((x$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_sub.?
             (I y_plus_x$) (I y_minus_x$)
            )
           ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
        )))
        (let
         ((y$ (curve25519_dalek!specs.field_specs.field_mul.? (I (curve25519_dalek!specs.field_specs.field_add.?
              (I y_plus_x$) (I y_minus_x$)
             )
            ) (I (curve25519_dalek!specs.field_specs.field_inv.? (I 2)))
         )))
         (tuple%2./tuple%2 (I x$) (I y$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
      niels!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_definition
))))
(assert
 (forall ((niels! Poly)) (!
   (=>
    (has_type niels! TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
       niels!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
     niels!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_lookup_table_affine_coords
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.)
  (forall ((N&. Dcr) (N& Type) (table! Poly) (basepoint! Poly) (size! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.? N&. N&
      table! basepoint! size!
     ) (and
      (= (vstd!slice.spec_slice_len.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
        (vstd!array.spec_array_as_slice.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         N&. N& table!
        )
       ) (%I size!)
      )
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (%I size!))
          ))
          (= (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
              $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. N&.
               N&
              ) table!
             ) j$
            )
           ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? basepoint! (I (nClip (Add
               (%I j$) 1
        )))))))
        :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
          (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
            N&. N&
           ) table!
          ) j$
        ))
        :qid user_curve25519_dalek__specs__window_specs__is_valid_lookup_table_affine_coords_57
        :skolemid skolem_user_curve25519_dalek__specs__window_specs__is_valid_lookup_table_affine_coords_57
    ))))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.?
      N&. N& table! basepoint! size!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::lookup_table_affine_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.)
  (forall ((N&. Dcr) (N& Type) (table! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.? N&. N&
      table!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!slice.spec_slice_len.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
             (vstd!array.spec_array_as_slice.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
              N&. N& table!
         )))))
         (let
          ((entry$ (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!seq.Seq.index.?
              $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
               $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. N&.
                N&
               ) table!
              ) j$
          ))))
          (and
           (and
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
               (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                 entry$
              )))
             ) (I 54)
            )
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
               (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                 entry$
              )))
             ) (I 54)
           ))
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
              (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                entry$
             )))
            ) (I 54)
       )))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           N&. N&
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__lookup_table_affine_limbs_bounded_58
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__lookup_table_affine_limbs_bounded_58
    )))
    :pattern ((curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.?
      N&. N& table!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_on_edwards_curve
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? x! y!) (let
      ((p$ (curve25519_dalek!specs.field_specs_u64.p.? (I 0))))
      (let
       ((d$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           curve25519_dalek!backend.serial.u64.constants.EDWARDS_D.?
       ))))
       (let
        ((x2$ (curve25519_dalek!specs.field_specs.field_square.? x!)))
        (let
         ((y2$ (curve25519_dalek!specs.field_specs.field_square.? y!)))
         (let
          ((x2y2$ (curve25519_dalek!specs.field_specs.field_mul.? (I x2$) (I y2$))))
          (let
           ((lhs$ (curve25519_dalek!specs.field_specs.field_sub.? (I y2$) (I x2$))))
           (let
            ((rhs$ (curve25519_dalek!specs.field_specs.field_add.? (I 1) (I (curve25519_dalek!specs.field_specs.field_mul.?
                 (I d$) (I x2y2$)
            )))))
            (= lhs$ rhs$)
    ))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? x! y!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_identity_edwards_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.? point!) (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.edwards_specs.edwards_x.? point!)
      ))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!specs.edwards_specs.edwards_y.? point!)
       ))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!specs.edwards_specs.edwards_z.? point!)
        ))))
        (and
         (and
          (not (= z$ 0))
          (= x$ 0)
         )
         (= y$ z$)
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::completed_point_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_nat.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!) (let
      ((x_abs$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
            point!
      ))))))
      (let
       ((y_abs$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
             point!
       ))))))
       (let
        ((z_abs$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
              point!
        ))))))
        (let
         ((t_abs$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
               point!
         ))))))
         (tuple%4./tuple%4 (I x_abs$) (I y_abs$) (I z_abs$) (I t_abs$))
    )))))
    :pattern ((curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.completed_point_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_point_as_nat.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%tuple%4. (curve25519_dalek!specs.edwards_specs.completed_point_as_nat.?
       point!
      )
     ) (TYPE%tuple%4. $ NAT $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.completed_point_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_point_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::completed_point_as_affine_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? point!)
     (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!)))
      (let
       ((x_abs$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y_abs$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z_abs$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((t_abs$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (let
           ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z_abs$))))
           (let
            ((t_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I t_abs$))))
            (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x_abs$) (I z_inv$)))
             (I (curve25519_dalek!specs.field_specs.field_mul.? (I y_abs$) (I t_inv$)))
    )))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?
      point!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?
       point!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?
     point!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_point_edwards_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? point!)
     (let
      ((x$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X (
            %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. point!
      ))))))
      (let
       ((y$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
           (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y (
             %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. point!
       ))))))
       (let
        ((z$ (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
            (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z (
              %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. point!
        ))))))
        (tuple%3./tuple%3 (I x$) (I y$) (I z$))
    ))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (has_type (Poly%tuple%3. (curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?
       point!
      )
     ) (TYPE%tuple%3. $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::identity_projective_point_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.? no%param)
     (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51
         (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0))))
       ))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?
      no%param
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?
       no%param
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?
     no%param
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_point_as_affine_edwards
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.? point!)
     (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((y$ (%I (tuple%3./tuple%3/1 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
        (let
         ((z$ (%I (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
         (let
          ((z_inv$ (curve25519_dalek!specs.field_specs.field_inv.? (I z$))))
          (tuple%2./tuple%2 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I z_inv$)))
           (I (curve25519_dalek!specs.field_specs.field_mul.? (I y$) (I z_inv$)))
    )))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?
      point!
    ))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?
       point!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?
     point!
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::identity_affine_niels
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.identity_affine_niels.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.identity_affine_niels.? no%param) (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint
      (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0)))
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.identity_affine_niels.? no%param))
    :qid internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (curve25519_dalek!specs.edwards_specs.identity_affine_niels.?
       no%param
      )
     ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.identity_affine_niels.? no%param))
   :qid internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_affine_niels.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::identity_projective_niels
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.identity_projective_niels.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param) (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint
      (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 1) (I 0) (I 0) (I 0) (I 0)))
       )))
      ) (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
          (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0)))
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param))
    :qid internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param)
     ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.identity_projective_niels.? no%param))
   :qid internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.identity_projective_niels.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::edwards_neg
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.edwards_neg.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.edwards_neg.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.edwards_neg.? point!) (tuple%2./tuple%2 (I
       (curve25519_dalek!specs.field_specs.field_neg.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
          point!
       )))
      ) (tuple%2./tuple%2/1 (%Poly%tuple%2. point!))
    ))
    :pattern ((curve25519_dalek!specs.edwards_specs.edwards_neg.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! (TYPE%tuple%2. $ NAT $ NAT))
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_neg.? point!))
     (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.edwards_neg.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.edwards_neg.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_completed_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_completed_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_completed_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!)))
      (let
       ((x_abs$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y_abs$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z_abs$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((t_abs$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (and
           (and
            (not (= z_abs$ 0))
            (not (= t_abs$ 0))
           )
           (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve.? (I (curve25519_dalek!specs.field_specs.field_mul.?
              (I x_abs$) (I (curve25519_dalek!specs.field_specs.field_inv.? (I z_abs$)))
             )
            ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I y_abs$) (I (curve25519_dalek!specs.field_specs.field_inv.?
                (I t_abs$)
    ))))))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_completed_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_completed_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::is_valid_projective_point
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_point.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.is_valid_projective_point.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.is_valid_projective_point.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((y$ (%I (tuple%3./tuple%3/1 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
        (let
         ((z$ (%I (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
         (and
          (not (= z$ 0))
          (curve25519_dalek!specs.edwards_specs.is_on_edwards_curve_projective.? (I x$) (I y$)
           (I z$)
    )))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.is_valid_projective_point.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_point.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.is_valid_projective_point.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::completed_to_projective
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.completed_to_projective.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.completed_to_projective.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.completed_to_projective.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (tuple%3./tuple%3 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I t$)))
           (I (curve25519_dalek!specs.field_specs.field_mul.? (I y$) (I z$))) (I (curve25519_dalek!specs.field_specs.field_mul.?
             (I z$) (I t$)
    )))))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.completed_to_projective.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.completed_to_projective.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_to_projective.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%tuple%3. (curve25519_dalek!specs.edwards_specs.completed_to_projective.?
       point!
      )
     ) (TYPE%tuple%3. $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.completed_to_projective.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.completed_to_projective.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_to_projective.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::completed_to_extended
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.completed_to_extended.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.completed_to_extended.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.completed_to_extended.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.completed_point_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%4./tuple%4/0 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
       (let
        ((y$ (%I (tuple%4./tuple%4/1 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
        (let
         ((z$ (%I (tuple%4./tuple%4/2 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
         (let
          ((t$ (%I (tuple%4./tuple%4/3 (%Poly%tuple%4. (Poly%tuple%4. tmp%%$))))))
          (tuple%4./tuple%4 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I t$)))
           (I (curve25519_dalek!specs.field_specs.field_mul.? (I y$) (I z$))) (I (curve25519_dalek!specs.field_specs.field_mul.?
             (I z$) (I t$)
            )
           ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I y$)))
    )))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.completed_to_extended.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.completed_to_extended.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_to_extended.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
    (has_type (Poly%tuple%4. (curve25519_dalek!specs.edwards_specs.completed_to_extended.?
       point!
      )
     ) (TYPE%tuple%4. $ NAT $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.completed_to_extended.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.completed_to_extended.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.completed_to_extended.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::projective_to_extended
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.projective_to_extended.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.projective_to_extended.)
  (forall ((point! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.projective_to_extended.? point!) (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? point!)))
      (let
       ((x$ (%I (tuple%3./tuple%3/0 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
       (let
        ((y$ (%I (tuple%3./tuple%3/1 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
        (let
         ((z$ (%I (tuple%3./tuple%3/2 (%Poly%tuple%3. (Poly%tuple%3. tmp%%$))))))
         (tuple%4./tuple%4 (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I z$)))
          (I (curve25519_dalek!specs.field_specs.field_mul.? (I y$) (I z$))) (I (curve25519_dalek!specs.field_specs.field_square.?
            (I z$)
           )
          ) (I (curve25519_dalek!specs.field_specs.field_mul.? (I x$) (I y$)))
    ))))))
    :pattern ((curve25519_dalek!specs.edwards_specs.projective_to_extended.? point!))
    :qid internal_curve25519_dalek!specs.edwards_specs.projective_to_extended.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_to_extended.?_definition
))))
(assert
 (forall ((point! Poly)) (!
   (=>
    (has_type point! TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
    (has_type (Poly%tuple%4. (curve25519_dalek!specs.edwards_specs.projective_to_extended.?
       point!
      )
     ) (TYPE%tuple%4. $ NAT $ NAT $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.projective_to_extended.? point!))
   :qid internal_curve25519_dalek!specs.edwards_specs.projective_to_extended.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.projective_to_extended.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::scalar_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.scalar_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.scalar_as_nat.)
  (forall ((s! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? s!) (curve25519_dalek!specs.core_specs.u8_32_as_nat.?
      (Poly%array%. (curve25519_dalek!scalar.Scalar./Scalar/bytes (%Poly%curve25519_dalek!scalar.Scalar.
         s!
    )))))
    :pattern ((curve25519_dalek!specs.scalar_specs.scalar_as_nat.? s!))
    :qid internal_curve25519_dalek!specs.scalar_specs.scalar_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.scalar_as_nat.?_definition
))))
(assert
 (forall ((s! Poly)) (!
   (=>
    (has_type s! TYPE%curve25519_dalek!scalar.Scalar.)
    (<= 0 (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? s!))
   )
   :pattern ((curve25519_dalek!specs.scalar_specs.scalar_as_nat.? s!))
   :qid internal_curve25519_dalek!specs.scalar_specs.scalar_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.scalar_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::sum_of_scalar_muls
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.)
)
(declare-const fuel_nat%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls. Fuel)
(assert
 (forall ((scalars! Poly) (points! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
     fuel%
    ) (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
     zero
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
     fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls._fuel_to_zero_definition
)))
(assert
 (forall ((scalars! Poly) (points! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type scalars! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.))
     (has_type points! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
    )
    (= (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
      (succ fuel%)
     ) (let
      ((len$ (ite
         (<= (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. scalars!) (vstd!seq.Seq.len.?
           $ TYPE%curve25519_dalek!edwards.EdwardsPoint. points!
         ))
         (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. scalars!)
         (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. points!)
      )))
      (ite
       (= len$ 0)
       (tuple%2./tuple%2 (I 0) (I 1))
       (let
        ((last$ (Sub len$ 1)))
        (let
         ((prev$ (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? (vstd!seq.Seq.subrange.?
             $ TYPE%curve25519_dalek!scalar.Scalar. scalars! (I 0) (I last$)
            ) (vstd!seq.Seq.subrange.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. points! (
              I 0
             ) (I last$)
            ) fuel%
         )))
         (let
          ((point_affine$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (vstd!seq.Seq.index.?
              $ TYPE%curve25519_dalek!edwards.EdwardsPoint. points! (I last$)
          ))))
          (let
           ((scalar_nat$ (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? (vstd!seq.Seq.index.?
               $ TYPE%curve25519_dalek!scalar.Scalar. scalars! (I last$)
           ))))
           (let
            ((scaled$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. point_affine$)
               (I scalar_nat$)
            )))
            (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
               (Poly%tuple%2. prev$)
              )
             ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$))) (tuple%2./tuple%2/0
              (%Poly%tuple%2. (Poly%tuple%2. scaled$))
             ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. scaled$)))
   ))))))))))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
     (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.)
  (forall ((scalars! Poly) (points! Poly)) (!
    (=>
     (and
      (has_type scalars! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.))
      (has_type points! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     )
     (= (curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? scalars! points!) (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.?
       scalars! points! (succ fuel_nat%curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.)
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? scalars! points!))
    :qid internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.?_definition
))))
(assert
 (forall ((scalars! Poly) (points! Poly)) (!
   (=>
    (and
     (has_type scalars! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.))
     (has_type points! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.?
       scalars! points!
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? scalars! points!))
   :qid internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.?_pre_post_definition
)))
(assert
 (forall ((scalars! Poly) (points! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type scalars! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!scalar.Scalar.))
     (has_type points! (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
    )
    (has_type (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.?
       scalars! points! fuel%
      )
     ) (TYPE%tuple%2. $ NAT $ NAT)
   ))
   :pattern ((curve25519_dalek!specs.edwards_specs.rec%sum_of_scalar_muls.? scalars! points!
     fuel%
   ))
   :qid internal_curve25519_dalek!specs.edwards_specs.rec__sum_of_scalar_muls.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.rec__sum_of_scalar_muls.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::edwards_specs::points_to_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.edwards_specs.points_to_affine.)
)
(declare-fun %%lambda%%2 () %%Function%%)
(assert
 (forall ((_i$ Poly) (p$ Poly)) (!
   (= (%%apply%%1 %%lambda%%2 _i$ p$) (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
      p$
   )))
   :pattern ((%%apply%%1 %%lambda%%2 _i$ p$))
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.edwards_specs.points_to_affine.)
  (forall ((points! Poly)) (!
    (= (curve25519_dalek!specs.edwards_specs.points_to_affine.? points!) (%Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
      (vstd!seq_lib.impl&%0.map.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (DST $)
       (TYPE%tuple%2. $ NAT $ NAT) points! (Poly%fun%2. (mk_fun %%lambda%%2))
    )))
    :pattern ((curve25519_dalek!specs.edwards_specs.points_to_affine.? points!))
    :qid internal_curve25519_dalek!specs.edwards_specs.points_to_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.edwards_specs.points_to_affine.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::field_specs::fe51_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.fe51_as_nat.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!) (curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.?
      (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
    ))))
    :pattern ((curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_definition
))))
(assert
 (forall ((fe! Poly)) (!
   (=>
    (has_type fe! TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
    (<= 0 (curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.fe51_as_nat.? fe!))
   :qid internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.fe51_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::iterator_specs::all_points_some
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.iterator_specs.all_points_some.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.iterator_specs.all_points_some.)
  (forall ((points! Poly)) (!
    (= (curve25519_dalek!specs.iterator_specs.all_points_some.? points!) (forall ((i$ Poly))
      (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!seq.Seq.len.? $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
             points!
         ))))
         (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!seq.Seq.index.? $ (TYPE%core!option.Option.
             $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
            ) points! i$
       )))))
       :pattern ((vstd!seq.Seq.index.? $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
         points! i$
       ))
       :qid user_curve25519_dalek__specs__iterator_specs__all_points_some_59
       :skolemid skolem_user_curve25519_dalek__specs__iterator_specs__all_points_some_59
    )))
    :pattern ((curve25519_dalek!specs.iterator_specs.all_points_some.? points!))
    :qid internal_curve25519_dalek!specs.iterator_specs.all_points_some.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.iterator_specs.all_points_some.?_definition
))))

;; Function-Specs curve25519_dalek::specs::iterator_specs::unwrap_points
(declare-fun req%curve25519_dalek!specs.iterator_specs.unwrap_points. (Poly) Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((points! Poly)) (!
   (= (req%curve25519_dalek!specs.iterator_specs.unwrap_points. points!) (=>
     %%global_location_label%%12
     (curve25519_dalek!specs.iterator_specs.all_points_some.? points!)
   ))
   :pattern ((req%curve25519_dalek!specs.iterator_specs.unwrap_points. points!))
   :qid internal_req__curve25519_dalek!specs.iterator_specs.unwrap_points._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.iterator_specs.unwrap_points._definition
)))

;; Function-Axioms curve25519_dalek::specs::iterator_specs::unwrap_points
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.iterator_specs.unwrap_points.)
)
(declare-fun %%lambda%%3 (Dcr Type) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (_i$ Poly) (opt$ Poly)) (!
   (= (%%apply%%1 (%%lambda%%3 %%hole%%0 %%hole%%1) _i$ opt$) (core!option.Option./Some/0
     %%hole%%0 %%hole%%1 (%Poly%core!option.Option. opt$)
   ))
   :pattern ((%%apply%%1 (%%lambda%%3 %%hole%%0 %%hole%%1) _i$ opt$))
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.iterator_specs.unwrap_points.)
  (forall ((points! Poly)) (!
    (= (curve25519_dalek!specs.iterator_specs.unwrap_points.? points!) (%Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
      (vstd!seq_lib.impl&%0.map.? $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
       $ TYPE%curve25519_dalek!edwards.EdwardsPoint. points! (Poly%fun%2. (mk_fun (%%lambda%%3
          $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
    ))))))
    :pattern ((curve25519_dalek!specs.iterator_specs.unwrap_points.? points!))
    :qid internal_curve25519_dalek!specs.iterator_specs.unwrap_points.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.iterator_specs.unwrap_points.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::group_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.group_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.group_canonical.)
  (forall ((n! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.group_canonical.? n!) (EucMod (%I n!) (curve25519_dalek!specs.scalar52_specs.group_order.?
       (I 0)
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.group_canonical.? n!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.group_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.group_canonical.?_definition
))))
(assert
 (forall ((n! Poly)) (!
   (=>
    (has_type n! NAT)
    (<= 0 (curve25519_dalek!specs.scalar52_specs.group_canonical.? n!))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.group_canonical.? n!))
   :qid internal_curve25519_dalek!specs.scalar52_specs.group_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.group_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::u8_32_as_group_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.)
  (forall ((bytes! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.? bytes!) (curve25519_dalek!specs.scalar52_specs.group_canonical.?
      (I (curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!))
    ))
    :pattern ((curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.? bytes!))
    :qid internal_curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.?_definition
))))
(assert
 (forall ((bytes! Poly)) (!
   (=>
    (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (<= 0 (curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.? bytes!))
   )
   :pattern ((curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.? bytes!))
   :qid internal_curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::scalar_as_canonical
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.scalar_as_canonical.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.scalar_as_canonical.)
  (forall ((s! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.scalar_as_canonical.? s!) (curve25519_dalek!specs.scalar_specs.u8_32_as_group_canonical.?
      (Poly%array%. (curve25519_dalek!scalar.Scalar./Scalar/bytes (%Poly%curve25519_dalek!scalar.Scalar.
         s!
    )))))
    :pattern ((curve25519_dalek!specs.scalar_specs.scalar_as_canonical.? s!))
    :qid internal_curve25519_dalek!specs.scalar_specs.scalar_as_canonical.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.scalar_as_canonical.?_definition
))))
(assert
 (forall ((s! Poly)) (!
   (=>
    (has_type s! TYPE%curve25519_dalek!scalar.Scalar.)
    (<= 0 (curve25519_dalek!specs.scalar_specs.scalar_as_canonical.? s!))
   )
   :pattern ((curve25519_dalek!specs.scalar_specs.scalar_as_canonical.? s!))
   :qid internal_curve25519_dalek!specs.scalar_specs.scalar_as_canonical.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.scalar_as_canonical.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::reconstruct
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.reconstruct.)
)
(declare-const fuel_nat%curve25519_dalek!specs.scalar_specs.reconstruct. Fuel)
(assert
 (forall ((naf! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.scalar_specs.rec%reconstruct.? naf! fuel%) (curve25519_dalek!specs.scalar_specs.rec%reconstruct.?
     naf! zero
   ))
   :pattern ((curve25519_dalek!specs.scalar_specs.rec%reconstruct.? naf! fuel%))
   :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct._fuel_to_zero_definition
)))
(assert
 (forall ((naf! Poly) (fuel% Fuel)) (!
   (=>
    (has_type naf! (TYPE%vstd!seq.Seq. $ (SINT 8)))
    (= (curve25519_dalek!specs.scalar_specs.rec%reconstruct.? naf! (succ fuel%)) (ite
      (= (vstd!seq.Seq.len.? $ (SINT 8) naf!) 0)
      0
      (Add (%I (vstd!seq.Seq.index.? $ (SINT 8) naf! (I 0))) (Mul 2 (curve25519_dalek!specs.scalar_specs.rec%reconstruct.?
         (vstd!seq.Seq.subrange.? $ (SINT 8) naf! (I 1) (I (vstd!seq.Seq.len.? $ (SINT 8) naf!)))
         fuel%
   ))))))
   :pattern ((curve25519_dalek!specs.scalar_specs.rec%reconstruct.? naf! (succ fuel%)))
   :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.reconstruct.)
  (forall ((naf! Poly)) (!
    (=>
     (has_type naf! (TYPE%vstd!seq.Seq. $ (SINT 8)))
     (= (curve25519_dalek!specs.scalar_specs.reconstruct.? naf!) (curve25519_dalek!specs.scalar_specs.rec%reconstruct.?
       naf! (succ fuel_nat%curve25519_dalek!specs.scalar_specs.reconstruct.)
    )))
    :pattern ((curve25519_dalek!specs.scalar_specs.reconstruct.? naf!))
    :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::reconstruct_radix_2w
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.)
)
(declare-const fuel_nat%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.
 Fuel
)
(assert
 (forall ((digits! Poly) (w! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? digits! w! fuel%)
    (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? digits! w! zero)
   )
   :pattern ((curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? digits! w!
     fuel%
   ))
   :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w._fuel_to_zero_definition
)))
(assert
 (forall ((digits! Poly) (w! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type digits! (TYPE%vstd!seq.Seq. $ (SINT 8)))
     (has_type w! NAT)
    )
    (= (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? digits! w! (succ
       fuel%
      )
     ) (ite
      (= (vstd!seq.Seq.len.? $ (SINT 8) digits!) 0)
      0
      (Add (%I (vstd!seq.Seq.index.? $ (SINT 8) digits! (I 0))) (Mul (vstd!arithmetic.power2.pow2.?
         w!
        ) (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? (vstd!seq.Seq.subrange.?
          $ (SINT 8) digits! (I 1) (I (vstd!seq.Seq.len.? $ (SINT 8) digits!))
         ) w! fuel%
   ))))))
   :pattern ((curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.? digits! w!
     (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.)
  (forall ((digits! Poly) (w! Poly)) (!
    (=>
     (and
      (has_type digits! (TYPE%vstd!seq.Seq. $ (SINT 8)))
      (has_type w! NAT)
     )
     (= (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.? digits! w!) (curve25519_dalek!specs.scalar_specs.rec%reconstruct_radix_2w.?
       digits! w! (succ fuel_nat%curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.)
    )))
    :pattern ((curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.? digits! w!))
    :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::reconstruct_radix_16
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_16.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.reconstruct_radix_16.)
  (forall ((digits! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.reconstruct_radix_16.? digits!) (curve25519_dalek!specs.scalar_specs.reconstruct_radix_2w.?
      digits! (I 4)
    ))
    :pattern ((curve25519_dalek!specs.scalar_specs.reconstruct_radix_16.? digits!))
    :qid internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_16.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.reconstruct_radix_16.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::scalar_specs::is_valid_radix_16
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_16.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar_specs.is_valid_radix_16.)
  (forall ((digits! Poly)) (!
    (= (curve25519_dalek!specs.scalar_specs.is_valid_radix_16.? digits!) (curve25519_dalek!specs.scalar_specs.is_valid_radix_2w.?
      digits! (I 4) (I 64)
    ))
    :pattern ((curve25519_dalek!specs.scalar_specs.is_valid_radix_16.? digits!))
    :qid internal_curve25519_dalek!specs.scalar_specs.is_valid_radix_16.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar_specs.is_valid_radix_16.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_lookup_table_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.)
  (forall ((N&. Dcr) (N& Type) (table! Poly) (P! Poly) (size! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.? N&. N& table!
      P! size!
     ) (curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine_coords.? N&. N&
      table! (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
        P!
       )
      ) size!
    ))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.? N&. N&
      table! P! size!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::naf_lookup_table5_affine_limbs_bounded
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.)
  (forall ((table! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.? table!)
     (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (let
          ((entry$ (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!seq.Seq.index.?
              $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
               $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
                 CONST_INT 8
                )
               ) table!
              ) j$
          ))))
          (and
           (and
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_plus_x
               (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                 entry$
              )))
             ) (I 54)
            )
            (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
              (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/y_minus_x
               (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                 entry$
              )))
             ) (I 54)
           ))
           (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
             (curve25519_dalek!backend.serial.curve_models.AffineNielsPoint./AffineNielsPoint/xy2d
              (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
                entry$
             )))
            ) (I 54)
       )))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           $ (CONST_INT 8)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__naf_lookup_table5_affine_limbs_bounded_60
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__naf_lookup_table5_affine_limbs_bounded_60
    )))
    :pattern ((curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.?
      table!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::window_specs::is_valid_naf_lookup_table5_affine
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.)
  (forall ((table! Poly) (A! Poly)) (!
    (= (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.? table!
      A!
     ) (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (= (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.? (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
             $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
               CONST_INT 8
              )
             ) table!
            ) j$
           )
          ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
             A!
            )
           ) (I (nClip (Add (Mul 2 (%I j$)) 1)))
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           $ (CONST_INT 8)
          ) table!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table5_affine_61
       :skolemid skolem_user_curve25519_dalek__specs__window_specs__is_valid_naf_lookup_table5_affine_61
    )))
    :pattern ((curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.?
      table! A!
    ))
    :qid internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.?_definition
))))

;; Function-Axioms curve25519_dalek::window::LookupTable::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%0.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%0.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
     $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
    ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::window::LookupTable::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%0.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%0.from_spec.)
  (forall ((P! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P!
     ) (vstd!pervasive.arbitrary.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::window::LookupTable::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%1.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%1.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
     $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
    ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::window::LookupTable::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%1.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%1.from_spec.)
  (forall ((P! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P!
     ) (vstd!pervasive.arbitrary.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::window::NafLookupTable5::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%2.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%2.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
     $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
    ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::window::NafLookupTable5::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%2.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%2.from_spec.)
  (forall ((A! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
     ) (vstd!pervasive.arbitrary.? $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::window::NafLookupTable5::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%3.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%3.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
     $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
    ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::window::NafLookupTable5::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.window_specs.impl&%3.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.window_specs.impl&%3.from_spec.)
  (forall ((A! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
     ) (vstd!pervasive.arbitrary.? $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::scalar::impl&%17::obeys_add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%17.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%17.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? (REF $) TYPE%curve25519_dalek!scalar.Scalar.
    (REF $) TYPE%curve25519_dalek!scalar.Scalar.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::scalar::impl&%17::add_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%17.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%17.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!scalar.Scalar.
      (REF $) TYPE%curve25519_dalek!scalar.Scalar. self! rhs!
     ) (B (and
       (curve25519_dalek!specs.scalar_specs.is_canonical_scalar.? self!)
       (curve25519_dalek!specs.scalar_specs.is_canonical_scalar.? rhs!)
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!scalar.Scalar.
      (REF $) TYPE%curve25519_dalek!scalar.Scalar. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms curve25519_dalek::scalar::impl&%17::add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%17.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%17.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!scalar.Scalar.
      (REF $) TYPE%curve25519_dalek!scalar.Scalar. self! rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!scalar.Scalar.
      (REF $) TYPE%curve25519_dalek!scalar.Scalar. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::scalar::impl&%24::obeys_sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%24.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%24.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? (REF $) TYPE%curve25519_dalek!scalar.Scalar.
    (REF $) TYPE%curve25519_dalek!scalar.Scalar.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::scalar::impl&%24::sub_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%24.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%24.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!scalar.Scalar.
      (REF $) TYPE%curve25519_dalek!scalar.Scalar. self! rhs!
     ) (B (and
       (curve25519_dalek!specs.scalar_specs.is_canonical_scalar.? self!)
       (curve25519_dalek!specs.scalar_specs.is_canonical_scalar.? rhs!)
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!scalar.Scalar.
      (REF $) TYPE%curve25519_dalek!scalar.Scalar. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms curve25519_dalek::scalar::impl&%24::sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%24.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%24.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!scalar.Scalar.
      (REF $) TYPE%curve25519_dalek!scalar.Scalar. self! rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!scalar.Scalar.
      (REF $) TYPE%curve25519_dalek!scalar.Scalar. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::scalar::Scalar::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%39.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%39.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
    $ (UINT 8)
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::scalar::Scalar::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%39.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%39.from_spec.)
  (forall ((x! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 8) x!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 8) x!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::scalar::Scalar::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%40.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%40.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
    $ (UINT 16)
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::scalar::Scalar::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%40.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%40.from_spec.)
  (forall ((x! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 16) x!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 16) x!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::scalar::Scalar::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%41.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%41.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
    $ (UINT 32)
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::scalar::Scalar::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%41.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%41.from_spec.)
  (forall ((x! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 32) x!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 32) x!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::scalar::Scalar::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%42.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%42.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
    $ (UINT 64)
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::scalar::Scalar::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%42.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%42.from_spec.)
  (forall ((x! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 64) x!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 64) x!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::scalar::Scalar::obeys_from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%43.obeys_from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%43.obeys_from_spec.)
  (= (vstd!std_specs.convert.FromSpec.obeys_from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
    $ (UINT 128)
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::scalar::Scalar::from_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!scalar.impl&%43.from_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!scalar.impl&%43.from_spec.)
  (forall ((x! Poly)) (!
    (= (vstd!std_specs.convert.FromSpec.from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 128) x!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    :pattern ((vstd!std_specs.convert.FromSpec.from_spec.? $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 128) x!
    ))
    :qid internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.convert.FromSpec.from_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::edwards::impl&%31::obeys_add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!edwards.impl&%31.obeys_add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!edwards.impl&%31.obeys_add_spec.)
  (= (vstd!std_specs.ops.AddSpec.obeys_add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
    (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::edwards::impl&%31::add_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!edwards.impl&%31.add_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!edwards.impl&%31.add_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
     ) (B (and
       (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? self!)
       (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? rhs!)
    )))
    :pattern ((vstd!std_specs.ops.AddSpec.add_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_req.?_definition
))))

;; Function-Axioms curve25519_dalek::edwards::impl&%31::add_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!edwards.impl&%31.add_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!edwards.impl&%31.add_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    )
    :pattern ((vstd!std_specs.ops.AddSpec.add_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.AddSpec.add_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::edwards::impl&%38::obeys_sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!edwards.impl&%38.obeys_sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!edwards.impl&%38.obeys_sub_spec.)
  (= (vstd!std_specs.ops.SubSpec.obeys_sub_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
    (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
   ) (B false)
)))

;; Function-Axioms curve25519_dalek::edwards::impl&%38::sub_req
(assert
 (fuel_bool_default fuel%curve25519_dalek!edwards.impl&%38.sub_req.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!edwards.impl&%38.sub_req.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
     ) (B (and
       (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? self!)
       (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? rhs!)
    )))
    :pattern ((vstd!std_specs.ops.SubSpec.sub_req.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_req.?_definition
))))

;; Function-Axioms curve25519_dalek::edwards::impl&%38::sub_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!edwards.impl&%38.sub_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!edwards.impl&%38.sub_spec.)
  (forall ((self! Poly) (rhs! Poly)) (!
    (= (vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
     ) (vstd!pervasive.arbitrary.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
    )
    :pattern ((vstd!std_specs.ops.SubSpec.sub_spec.? (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! rhs!
    ))
    :qid internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.ops.SubSpec.sub_spec.?_definition
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
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!view.View. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_vstd__view__impl&__10_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__10_trait_impl_definition
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
 (tr_bound%vstd!view.View. $ (UINT 16))
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
 (tr_bound%vstd!view.View. $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type)) (!
   (=>
    (and
     (sized A0&.)
     (tr_bound%vstd!view.View. A0&. A0&)
    )
    (tr_bound%vstd!view.View. (DST A0&.) (TYPE%tuple%1. A0&. A0&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A0&.) (TYPE%tuple%1. A0&. A0&)))
   :qid internal_vstd__view__impl&__42_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__42_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type)) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
    )
    (tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A1&.) (TYPE%tuple%2. A0&. A0& A1&. A1&)))
   :qid internal_vstd__view__impl&__44_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__44_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (sized A2&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
     (tr_bound%vstd!view.View. A2&. A2&)
    )
    (tr_bound%vstd!view.View. (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&. A2&))
   )
   :pattern ((tr_bound%vstd!view.View. (DST A2&.) (TYPE%tuple%3. A0&. A0& A1&. A1& A2&.
      A2&
   )))
   :qid internal_vstd__view__impl&__46_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__46_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A0&. Dcr) (A0& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type) (A3&. Dcr)
   (A3& Type)
  ) (!
   (=>
    (and
     (sized A0&.)
     (sized A1&.)
     (sized A2&.)
     (sized A3&.)
     (tr_bound%vstd!view.View. A0&. A0&)
     (tr_bound%vstd!view.View. A1&. A1&)
     (tr_bound%vstd!view.View. A2&. A2&)
     (tr_bound%vstd!view.View. A3&. A3&)
    )
    (tr_bound%vstd!view.View. (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&. A2& A3&.
      A3&
   )))
   :pattern ((tr_bound%vstd!view.View. (DST A3&.) (TYPE%tuple%4. A0&. A0& A1&. A1& A2&.
      A2& A3&. A3&
   )))
   :qid internal_vstd__view__impl&__48_trait_impl_definition
   :skolemid skolem_internal_vstd__view__impl&__48_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ BOOL $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 16) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 16) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 32) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 32) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 64) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 64) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ USIZE $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ USIZE $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 128) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 128) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 32) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 32) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 64) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 64) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ USIZE $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ USIZE $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 128) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 128) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 64) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 64) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 128) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 128) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 128) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (UINT 128) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Ord. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.cmp.OrdSpec. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Ord. $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.cmp.OrdSpec. $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Ord. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.cmp.OrdSpec. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Ord. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.cmp.OrdSpec. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Ord. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.cmp.OrdSpec. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Ord. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.cmp.OrdSpec. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Ord. $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.cmp.OrdSpec. $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Ord. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.cmp.OrdSpec. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :qid internal_core__option__impl&__15_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__15_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.Eq. T&. T&)
    )
    (tr_bound%core!cmp.Eq. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Eq. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_core__option__impl&__48_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__48_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (TYPE%core!option.Option. T&. T&) $ (TYPE%core!option.Option.
      T&. T&
   )))
   :qid internal_core__option__impl&__16_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__16_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.Ord. T&. T&)
    )
    (tr_bound%core!cmp.Ord. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Ord. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_core__option__impl&__17_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__17_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%vstd!std_specs.cmp.OrdSpec. T&. T&)
    )
    (tr_bound%vstd!std_specs.cmp.OrdSpec. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%vstd!std_specs.cmp.OrdSpec. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_vstd__std_specs__option__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__option__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (
    A2& Type
   )
  ) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (sized A1&.)
     (sized A2&.)
     (tr_bound%core!alloc.Allocator. A1&. A1&)
     (tr_bound%core!alloc.Allocator. A2&. A2&)
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%alloc!vec.Vec. T&. T& A1&. A1&) $ (TYPE%alloc!vec.Vec.
      U&. U& A2&. A2&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%alloc!vec.Vec. T&. T& A1&. A1&) $ (
      TYPE%alloc!vec.Vec. U&. U& A2&. A2&
   )))
   :qid internal_alloc__vec__partial_eq__impl&__0_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__partial_eq__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!borrow.Borrow. T&. T& T&. T&)
   :pattern ((tr_bound%core!borrow.Borrow. T&. T& T&. T&))
   :qid internal_core__borrow__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__borrow__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!borrow.Borrow. (REF T&.) T& T&. T&)
   :pattern ((tr_bound%core!borrow.Borrow. (REF T&.) T& T&. T&))
   :qid internal_core__borrow__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__borrow__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%core!borrow.Borrow. $ (ARRAY T&. T& N&. N&) $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!borrow.Borrow. $ (ARRAY T&. T& N&. N&) $slice (SLICE T&. T&)))
   :qid internal_core__array__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized A&.)
     (tr_bound%core!alloc.Allocator. A&. A&)
    )
    (tr_bound%core!borrow.Borrow. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) $slice (SLICE T&.
      T&
   )))
   :pattern ((tr_bound%core!borrow.Borrow. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) $slice
     (SLICE T&. T&)
   ))
   :qid internal_alloc__slice__impl&__5_trait_impl_definition
   :skolemid skolem_internal_alloc__slice__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!clone.Clone. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_core__clone__impls__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. $ (PTR T&. T&))
   :pattern ((tr_bound%core!clone.Clone. $ (PTR T&. T&)))
   :qid internal_core__clone__impls__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!clone.Clone. (REF T&.) T&)
   :pattern ((tr_bound%core!clone.Clone. (REF T&.) T&))
   :qid internal_core__clone__impls__impl&__3_trait_impl_definition
   :skolemid skolem_internal_core__clone__impls__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%core!cmp.Ordering.)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!clone.Clone. T&. T&)
    )
    (tr_bound%core!clone.Clone. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (ARRAY T&. T& N&. N&)))
   :qid internal_core__array__impl&__20_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__20_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ ALLOCATOR_GLOBAL)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized A&.)
     (tr_bound%core!clone.Clone. T&. T&)
     (tr_bound%core!alloc.Allocator. A&. A&)
     (tr_bound%core!clone.Clone. A&. A&)
    )
    (tr_bound%core!clone.Clone. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)))
   :qid internal_alloc__vec__impl&__11_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__impl&__11_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type) (B&. Dcr) (B& Type)) (!
   (=>
    (tr_bound%core!cmp.PartialEq. A&. A& B&. B&)
    (tr_bound%core!cmp.PartialEq. (REF A&.) A& (REF B&.) B&)
   )
   :pattern ((tr_bound%core!cmp.PartialEq. (REF A&.) A& (REF B&.) B&))
   :qid internal_core__cmp__impls__impl&__9_trait_impl_definition
   :skolemid skolem_internal_core__cmp__impls__impl&__9_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. (REF $slice) (SLICE T&. T&) $ (ARRAY U&. U& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. (REF $slice) (SLICE T&. T&) $ (ARRAY U&. U&
      N&. N&
   )))
   :qid internal_core__array__equality__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (sized A&.)
     (tr_bound%core!alloc.Allocator. A&. A&)
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. (REF $slice) (SLICE T&. T&) $ (TYPE%alloc!vec.Vec. U&.
      U& A&. A&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. (REF $slice) (SLICE T&. T&) $ (TYPE%alloc!vec.Vec.
      U&. U& A&. A&
   )))
   :qid internal_alloc__vec__partial_eq__impl&__3_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__partial_eq__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialEq. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialEq. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (PTR
      T&. T&
   )))
   :qid internal_core__ptr__const_ptr__impl&__6_trait_impl_definition
   :skolemid skolem_internal_core__ptr__const_ptr__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialEq. $ (PTR T&. T&) $ (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (PTR T&. T&) $ (PTR T&. T&)))
   :qid internal_core__ptr__mut_ptr__impl&__6_trait_impl_definition
   :skolemid skolem_internal_core__ptr__mut_ptr__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%core!cmp.Ordering. $ TYPE%core!cmp.Ordering.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%tuple%0. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $ (ARRAY U&. U& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $ (ARRAY U&. U& N&.
      N&
   )))
   :qid internal_core__array__equality__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $slice (SLICE U&. U&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) $slice (SLICE U&. U&)))
   :qid internal_core__array__equality__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) (REF $slice) (SLICE U&. U&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $ (ARRAY T&. T& N&. N&) (REF $slice) (SLICE
      U&. U&
   )))
   :qid internal_core__array__equality__impl&__3_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $ (ARRAY U&. U& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $ (ARRAY U&. U& N&. N&)))
   :qid internal_core__array__equality__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $slice (SLICE U&. U&))
   )
   :pattern ((tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $slice (SLICE U&. U&)))
   :qid internal_core__slice__cmp__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__slice__cmp__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (sized A&.)
     (tr_bound%core!alloc.Allocator. A&. A&)
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $ (TYPE%alloc!vec.Vec. U&. U& A&.
      A&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $slice (SLICE T&. T&) $ (TYPE%alloc!vec.Vec.
      U&. U& A&. A&
   )))
   :qid internal_alloc__vec__partial_eq__impl&__6_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__partial_eq__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.) (TYPE%tuple%1.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.)
     (TYPE%tuple%1. T&. T&)
   ))
   :qid internal_core__tuple__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST T&.) (TYPE%tuple%2.
      U&. U& T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST
      T&.
     ) (TYPE%tuple%2. U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__10_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__10_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. V&. V& V&. V&)
     (tr_bound%core!cmp.PartialEq. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%3. V&. V& U&. U& T&. T&) (DST T&.)
     (TYPE%tuple%3. V&. V& U&. U& T&. T&)
   ))
   :pattern ((tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%3. V&. V& U&. U& T&. T&)
     (DST T&.) (TYPE%tuple%3. V&. V& U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__20_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__20_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((W&. Dcr) (W& Type) (V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type))
  (!
   (=>
    (and
     (sized W&.)
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialEq. W&. W& W&. W&)
     (tr_bound%core!cmp.PartialEq. V&. V& V&. V&)
     (tr_bound%core!cmp.PartialEq. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialEq. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
     (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
   ))
   :pattern ((tr_bound%core!cmp.PartialEq. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U&
      T&. T&
     ) (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__30_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__30_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (sized A&.)
     (tr_bound%core!alloc.Allocator. A&. A&)
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) (REF $slice) (
      SLICE U&. U&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) (REF $slice)
     (SLICE U&. U&)
   ))
   :qid internal_alloc__vec__partial_eq__impl&__1_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__partial_eq__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (sized A&.)
     (tr_bound%core!alloc.Allocator. A&. A&)
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) $slice (SLICE U&.
      U&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) $slice
     (SLICE U&. U&)
   ))
   :qid internal_alloc__vec__partial_eq__impl&__5_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__partial_eq__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (A&. Dcr) (A& Type) (N&. Dcr) (N& Type))
  (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (sized A&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!alloc.Allocator. A&. A&)
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) $ (ARRAY U&. U&
      N&. N&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) $ (ARRAY
      U&. U& N&. N&
   )))
   :qid internal_alloc__vec__partial_eq__impl&__10_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__partial_eq__impl&__10_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (U&. Dcr) (U& Type) (A&. Dcr) (A& Type) (N&. Dcr) (N& Type))
  (!
   (=>
    (and
     (sized T&.)
     (sized U&.)
     (sized A&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!alloc.Allocator. A&. A&)
     (tr_bound%core!cmp.PartialEq. T&. T& U&. U&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) (REF $) (ARRAY
      U&. U& N&. N&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&) (REF $)
     (ARRAY U&. U& N&. N&)
   ))
   :qid internal_alloc__vec__partial_eq__impl&__11_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__partial_eq__impl&__11_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.Eq. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.Eq. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_core__ptr__const_ptr__impl&__7_trait_impl_definition
   :skolemid skolem_internal_core__ptr__const_ptr__impl&__7_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.Eq. $ (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.Eq. $ (PTR T&. T&)))
   :qid internal_core__ptr__mut_ptr__impl&__7_trait_impl_definition
   :skolemid skolem_internal_core__ptr__mut_ptr__impl&__7_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ TYPE%core!cmp.Ordering.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%core!cmp.Eq. A&. A&)
    (tr_bound%core!cmp.Eq. (REF A&.) A&)
   )
   :pattern ((tr_bound%core!cmp.Eq. (REF A&.) A&))
   :qid internal_core__cmp__impls__impl&__12_trait_impl_definition
   :skolemid skolem_internal_core__cmp__impls__impl&__12_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.Eq. T&. T&)
    )
    (tr_bound%core!cmp.Eq. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.Eq. $ (ARRAY T&. T& N&. N&)))
   :qid internal_core__array__equality__impl&__7_trait_impl_definition
   :skolemid skolem_internal_core__array__equality__impl&__7_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.Eq. T&. T&)
    )
    (tr_bound%core!cmp.Eq. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Eq. $slice (SLICE T&. T&)))
   :qid internal_core__slice__cmp__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__slice__cmp__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.Eq. T&. T&)
    )
    (tr_bound%core!cmp.Eq. (DST T&.) (TYPE%tuple%1. T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Eq. (DST T&.) (TYPE%tuple%1. T&. T&)))
   :qid internal_core__tuple__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.Eq. U&. U&)
     (tr_bound%core!cmp.Eq. T&. T&)
    )
    (tr_bound%core!cmp.Eq. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Eq. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&)))
   :qid internal_core__tuple__impl&__11_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__11_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.Eq. V&. V&)
     (tr_bound%core!cmp.Eq. U&. U&)
     (tr_bound%core!cmp.Eq. T&. T&)
    )
    (tr_bound%core!cmp.Eq. (DST T&.) (TYPE%tuple%3. V&. V& U&. U& T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Eq. (DST T&.) (TYPE%tuple%3. V&. V& U&. U& T&. T&)))
   :qid internal_core__tuple__impl&__21_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__21_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((W&. Dcr) (W& Type) (V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type))
  (!
   (=>
    (and
     (sized W&.)
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.Eq. W&. W&)
     (tr_bound%core!cmp.Eq. V&. V&)
     (tr_bound%core!cmp.Eq. U&. U&)
     (tr_bound%core!cmp.Eq. T&. T&)
    )
    (tr_bound%core!cmp.Eq. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Eq. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)))
   :qid internal_core__tuple__impl&__31_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__31_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized A&.)
     (tr_bound%core!cmp.Eq. T&. T&)
     (tr_bound%core!alloc.Allocator. A&. A&)
    )
    (tr_bound%core!cmp.Eq. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&))
   )
   :pattern ((tr_bound%core!cmp.Eq. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)))
   :qid internal_alloc__vec__impl&__23_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__impl&__23_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialOrd. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialOrd. (CONST_PTR $) (PTR T&. T&) (CONST_PTR $) (
      PTR T&. T&
   )))
   :qid internal_core__ptr__const_ptr__impl&__9_trait_impl_definition
   :skolemid skolem_internal_core__ptr__const_ptr__impl&__9_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.Ord. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.Ord. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_core__ptr__const_ptr__impl&__8_trait_impl_definition
   :skolemid skolem_internal_core__ptr__const_ptr__impl&__8_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.PartialOrd. $ (PTR T&. T&) $ (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (PTR T&. T&) $ (PTR T&. T&)))
   :qid internal_core__ptr__mut_ptr__impl&__9_trait_impl_definition
   :skolemid skolem_internal_core__ptr__mut_ptr__impl&__9_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!cmp.Ord. $ (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.Ord. $ (PTR T&. T&)))
   :qid internal_core__ptr__mut_ptr__impl&__8_trait_impl_definition
   :skolemid skolem_internal_core__ptr__mut_ptr__impl&__8_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ TYPE%core!cmp.Ordering. $ TYPE%core!cmp.Ordering.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Ord. $ TYPE%core!cmp.Ordering.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ TYPE%tuple%0. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Ord. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ BOOL $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Ord. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type) (B&. Dcr) (B& Type)) (!
   (=>
    (tr_bound%core!cmp.PartialOrd. A&. A& B&. B&)
    (tr_bound%core!cmp.PartialOrd. (REF A&.) A& (REF B&.) B&)
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. (REF A&.) A& (REF B&.) B&))
   :qid internal_core__cmp__impls__impl&__10_trait_impl_definition
   :skolemid skolem_internal_core__cmp__impls__impl&__10_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%core!cmp.Ord. A&. A&)
    (tr_bound%core!cmp.Ord. (REF A&.) A&)
   )
   :pattern ((tr_bound%core!cmp.Ord. (REF A&.) A&))
   :qid internal_core__cmp__impls__impl&__11_trait_impl_definition
   :skolemid skolem_internal_core__cmp__impls__impl&__11_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. $ (ARRAY T&. T& N&. N&) $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (ARRAY T&. T& N&. N&) $ (ARRAY T&. T& N&.
      N&
   )))
   :qid internal_core__array__impl&__17_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__17_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!cmp.Ord. T&. T&)
    )
    (tr_bound%core!cmp.Ord. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!cmp.Ord. $ (ARRAY T&. T& N&. N&)))
   :qid internal_core__array__impl&__18_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__18_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. $slice (SLICE T&. T&) $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!cmp.PartialOrd. $slice (SLICE T&. T&) $slice (SLICE T&. T&)))
   :qid internal_core__slice__cmp__impl&__3_trait_impl_definition
   :skolemid skolem_internal_core__slice__cmp__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.Ord. T&. T&)
    )
    (tr_bound%core!cmp.Ord. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Ord. $slice (SLICE T&. T&)))
   :qid internal_core__slice__cmp__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__slice__cmp__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.) (TYPE%tuple%1.
      T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%1. T&. T&) (DST T&.)
     (TYPE%tuple%1. T&. T&)
   ))
   :qid internal_core__tuple__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!cmp.Ord. T&. T&)
    )
    (tr_bound%core!cmp.Ord. (DST T&.) (TYPE%tuple%1. T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Ord. (DST T&.) (TYPE%tuple%1. T&. T&)))
   :qid internal_core__tuple__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST T&.) (
      TYPE%tuple%2. U&. U& T&. T&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&) (DST
      T&.
     ) (TYPE%tuple%2. U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__14_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__14_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.Ord. U&. U&)
     (tr_bound%core!cmp.Ord. T&. T&)
    )
    (tr_bound%core!cmp.Ord. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Ord. (DST T&.) (TYPE%tuple%2. U&. U& T&. T&)))
   :qid internal_core__tuple__impl&__15_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__15_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. V&. V& V&. V&)
     (tr_bound%core!cmp.PartialOrd. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%3. V&. V& U&. U& T&. T&) (DST
      T&.
     ) (TYPE%tuple%3. V&. V& U&. U& T&. T&)
   ))
   :pattern ((tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%3. V&. V& U&. U& T&.
      T&
     ) (DST T&.) (TYPE%tuple%3. V&. V& U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__24_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__24_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.Ord. V&. V&)
     (tr_bound%core!cmp.Ord. U&. U&)
     (tr_bound%core!cmp.Ord. T&. T&)
    )
    (tr_bound%core!cmp.Ord. (DST T&.) (TYPE%tuple%3. V&. V& U&. U& T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Ord. (DST T&.) (TYPE%tuple%3. V&. V& U&. U& T&. T&)))
   :qid internal_core__tuple__impl&__25_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__25_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((W&. Dcr) (W& Type) (V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type))
  (!
   (=>
    (and
     (sized W&.)
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.PartialOrd. W&. W& W&. W&)
     (tr_bound%core!cmp.PartialOrd. V&. V& V&. V&)
     (tr_bound%core!cmp.PartialOrd. U&. U& U&. U&)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
    )
    (tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
     (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
   ))
   :pattern ((tr_bound%core!cmp.PartialOrd. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&.
      U& T&. T&
     ) (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&)
   ))
   :qid internal_core__tuple__impl&__34_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__34_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((W&. Dcr) (W& Type) (V&. Dcr) (V& Type) (U&. Dcr) (U& Type) (T&. Dcr) (T& Type))
  (!
   (=>
    (and
     (sized W&.)
     (sized V&.)
     (sized U&.)
     (sized T&.)
     (tr_bound%core!cmp.Ord. W&. W&)
     (tr_bound%core!cmp.Ord. V&. V&)
     (tr_bound%core!cmp.Ord. U&. U&)
     (tr_bound%core!cmp.Ord. T&. T&)
    )
    (tr_bound%core!cmp.Ord. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&. T&))
   )
   :pattern ((tr_bound%core!cmp.Ord. (DST T&.) (TYPE%tuple%4. W&. W& V&. V& U&. U& T&.
      T&
   )))
   :qid internal_core__tuple__impl&__35_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__35_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (A1&. Dcr) (A1& Type) (A2&. Dcr) (A2& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized A1&.)
     (sized A2&.)
     (tr_bound%core!cmp.PartialOrd. T&. T& T&. T&)
     (tr_bound%core!alloc.Allocator. A1&. A1&)
     (tr_bound%core!alloc.Allocator. A2&. A2&)
    )
    (tr_bound%core!cmp.PartialOrd. $ (TYPE%alloc!vec.Vec. T&. T& A1&. A1&) $ (TYPE%alloc!vec.Vec.
      T&. T& A2&. A2&
   )))
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (TYPE%alloc!vec.Vec. T&. T& A1&. A1&) $
     (TYPE%alloc!vec.Vec. T&. T& A2&. A2&)
   ))
   :qid internal_alloc__vec__impl&__22_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__impl&__22_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized A&.)
     (tr_bound%core!cmp.Ord. T&. T&)
     (tr_bound%core!alloc.Allocator. A&. A&)
    )
    (tr_bound%core!cmp.Ord. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&))
   )
   :pattern ((tr_bound%core!cmp.Ord. $ (TYPE%alloc!vec.Vec. T&. T& A&. A&)))
   :qid internal_alloc__vec__impl&__24_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__impl&__24_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. T&. T& T&. T&)
   )
   :pattern ((tr_bound%core!convert.From. T&. T& T&. T&))
   :qid internal_core__convert__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__convert__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ USIZE $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 8) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 16) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 32) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 64) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 128) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 8) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 32) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 32) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 32) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 32) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. $ (TYPE%core!option.Option. T&. T&) T&. T&)
   )
   :pattern ((tr_bound%core!convert.From. $ (TYPE%core!option.Option. T&. T&) T&. T&))
   :qid internal_core__option__impl&__11_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__11_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. $ (TYPE%core!option.Option. (REF T&.) T&) (REF $) (TYPE%core!option.Option.
      T&. T&
   )))
   :pattern ((tr_bound%core!convert.From. $ (TYPE%core!option.Option. (REF T&.) T&) (REF
      $
     ) (TYPE%core!option.Option. T&. T&)
   ))
   :qid internal_core__option__impl&__12_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__12_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%1. T&. T&) $ (ARRAY T&. T& $ (CONST_INT
       1
   ))))
   :pattern ((tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%1. T&. T&) $ (ARRAY T&.
      T& $ (CONST_INT 1)
   )))
   :qid internal_core__tuple__impl&__7_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__7_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 1)) (DST T&.) (TYPE%tuple%1.
      T&. T&
   )))
   :pattern ((tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 1)) (DST T&.) (
      TYPE%tuple%1. T&. T&
   )))
   :qid internal_core__tuple__impl&__8_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__8_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 2)) (DST T&.) (TYPE%tuple%2.
      T&. T& T&. T&
   )))
   :pattern ((tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 2)) (DST T&.) (
      TYPE%tuple%2. T&. T& T&. T&
   )))
   :qid internal_core__tuple__impl&__18_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__18_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 3)) (DST T&.) (TYPE%tuple%3.
      T&. T& T&. T& T&. T&
   )))
   :pattern ((tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 3)) (DST T&.) (
      TYPE%tuple%3. T&. T& T&. T& T&. T&
   )))
   :qid internal_core__tuple__impl&__28_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__28_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 4)) (DST T&.) (TYPE%tuple%4.
      T&. T& T&. T& T&. T& T&. T&
   )))
   :pattern ((tr_bound%core!convert.From. $ (ARRAY T&. T& $ (CONST_INT 4)) (DST T&.) (
      TYPE%tuple%4. T&. T& T&. T& T&. T& T&. T&
   )))
   :qid internal_core__tuple__impl&__38_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__38_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%2. T&. T& T&. T&) $ (ARRAY T&. T&
      $ (CONST_INT 2)
   )))
   :pattern ((tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%2. T&. T& T&. T&) $ (ARRAY
      T&. T& $ (CONST_INT 2)
   )))
   :qid internal_core__tuple__impl&__17_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__17_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%3. T&. T& T&. T& T&. T&) $ (ARRAY
      T&. T& $ (CONST_INT 3)
   )))
   :pattern ((tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%3. T&. T& T&. T& T&. T&)
     $ (ARRAY T&. T& $ (CONST_INT 3))
   ))
   :qid internal_core__tuple__impl&__27_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__27_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%4. T&. T& T&. T& T&. T& T&. T&)
     $ (ARRAY T&. T& $ (CONST_INT 4))
   ))
   :pattern ((tr_bound%core!convert.From. (DST T&.) (TYPE%tuple%4. T&. T& T&. T& T&. T&
      T&. T&
     ) $ (ARRAY T&. T& $ (CONST_INT 4))
   ))
   :qid internal_core__tuple__impl&__37_trait_impl_definition
   :skolemid skolem_internal_core__tuple__impl&__37_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!clone.Clone. T&. T&)
    )
    (tr_bound%core!convert.From. $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL) (REF
      $slice
     ) (SLICE T&. T&)
   ))
   :pattern ((tr_bound%core!convert.From. $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL)
     (REF $slice) (SLICE T&. T&)
   ))
   :qid internal_alloc__vec__impl&__32_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__impl&__32_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!clone.Clone. T&. T&)
    )
    (tr_bound%core!convert.From. $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL) (REF
      $
     ) (ARRAY T&. T& N&. N&)
   ))
   :pattern ((tr_bound%core!convert.From. $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL)
     (REF $) (ARRAY T&. T& N&. N&)
   ))
   :qid internal_alloc__vec__impl&__34_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__impl&__34_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%core!convert.From. $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL) $ (
      ARRAY T&. T& N&. N&
   )))
   :pattern ((tr_bound%core!convert.From. $ (TYPE%alloc!vec.Vec. T&. T& $ ALLOCATOR_GLOBAL)
     $ (ARRAY T&. T& N&. N&)
   ))
   :qid internal_alloc__vec__impl&__36_trait_impl_definition
   :skolemid skolem_internal_alloc__vec__impl&__36_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 16) (REF $) (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (UINT 128) (REF $) (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 8) (REF $) (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 16) (REF $) (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (UINT 128) (REF $) (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 8) (REF $) (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 16) (REF $) (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (UINT 128) (REF $) (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (SINT 8) $ (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (SINT 8) (REF $) (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ USIZE (REF $) USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 8) (REF $) (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 16) (REF $) (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 32) (REF $) (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 64) (REF $) (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (UINT 128) (REF $) (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (SINT 8) (REF $) (SINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ (SINT 32) (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (tr_bound%core!alloc.Allocator. A&. A&)
    (tr_bound%core!alloc.Allocator. (REF A&.) A&)
   )
   :pattern ((tr_bound%core!alloc.Allocator. (REF A&.) A&))
   :qid internal_core__alloc__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__alloc__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (sized A&.)
    (tr_bound%core!clone.Clone. (TRACKED A&.) A&)
   )
   :pattern ((tr_bound%core!clone.Clone. (TRACKED A&.) A&))
   :qid internal_verus_builtin__impl&__5_trait_impl_definition
   :skolemid skolem_internal_verus_builtin__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (sized A&.)
    (tr_bound%core!clone.Clone. (GHOST A&.) A&)
   )
   :pattern ((tr_bound%core!clone.Clone. (GHOST A&.) A&))
   :qid internal_verus_builtin__impl&__3_trait_impl_definition
   :skolemid skolem_internal_verus_builtin__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!clone.Clone. T&. T&)
    )
    (tr_bound%core!clone.Clone. $ (TYPE%core!option.Option. T&. T&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%core!option.Option. T&. T&)))
   :qid internal_core__option__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__option__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized A&.)
     (tr_bound%core!clone.Clone. T&. T&)
     (tr_bound%core!alloc.Allocator. A&. A&)
     (tr_bound%core!clone.Clone. A&. A&)
    )
    (tr_bound%core!clone.Clone. (BOX A&. A& T&.) T&)
   )
   :pattern ((tr_bound%core!clone.Clone. (BOX A&. A& T&.) T&))
   :qid internal_alloc__boxed__impl&__13_trait_impl_definition
   :skolemid skolem_internal_alloc__boxed__impl&__13_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!scalar.Scalar.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%curve25519_dalek!scalar.Scalar. $ TYPE%curve25519_dalek!scalar.Scalar.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ TYPE%curve25519_dalek!scalar.Scalar.)
)

;; Function-Specs curve25519_dalek::scalar::impl&%18::add
(declare-fun ens%curve25519_dalek!scalar.impl&%18.add. (Poly Poly Poly) Bool)
(assert
 (forall ((self! Poly) (_rhs! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!scalar.impl&%18.add. self! _rhs! result!) (and
     (ens%core!ops.arith.Add.add. (REF $) TYPE%curve25519_dalek!scalar.Scalar. (REF $)
      TYPE%curve25519_dalek!scalar.Scalar. self! _rhs! result!
     )
     (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? result!) (curve25519_dalek!specs.scalar52_specs.group_canonical.?
       (I (nClip (Add (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? self!) (curve25519_dalek!specs.scalar_specs.scalar_as_nat.?
           _rhs!
     ))))))
     (curve25519_dalek!specs.scalar_specs.is_canonical_scalar.? result!)
   ))
   :pattern ((ens%curve25519_dalek!scalar.impl&%18.add. self! _rhs! result!))
   :qid internal_ens__curve25519_dalek!scalar.impl&__18.add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!scalar.impl&__18.add._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!scalar.Scalar. (REF $)
  TYPE%curve25519_dalek!scalar.Scalar.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. (REF $) TYPE%curve25519_dalek!scalar.Scalar.
  (REF $) TYPE%curve25519_dalek!scalar.Scalar.
))

;; Function-Specs curve25519_dalek::scalar::impl&%25::sub
(declare-fun ens%curve25519_dalek!scalar.impl&%25.sub. (Poly Poly Poly) Bool)
(assert
 (forall ((self! Poly) (_rhs! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!scalar.impl&%25.sub. self! _rhs! result!) (and
     (ens%core!ops.arith.Sub.sub. (REF $) TYPE%curve25519_dalek!scalar.Scalar. (REF $)
      TYPE%curve25519_dalek!scalar.Scalar. self! _rhs! result!
     )
     (= (curve25519_dalek!specs.scalar_specs.scalar_as_canonical.? result!) (EucMod (Sub
        (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? self!) (curve25519_dalek!specs.scalar_specs.scalar_as_nat.?
         _rhs!
        )
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   ))))
   :pattern ((ens%curve25519_dalek!scalar.impl&%25.sub. self! _rhs! result!))
   :qid internal_ens__curve25519_dalek!scalar.impl&__25.sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!scalar.impl&__25.sub._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) TYPE%curve25519_dalek!scalar.Scalar. (REF $)
  TYPE%curve25519_dalek!scalar.Scalar.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. (REF $) TYPE%curve25519_dalek!scalar.Scalar.
  (REF $) TYPE%curve25519_dalek!scalar.Scalar.
))

;; Function-Specs curve25519_dalek::scalar::Scalar::from
(declare-fun ens%curve25519_dalek!scalar.impl&%44.from. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!scalar.impl&%44.from. x! result!) (and
     (ens%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar. $ (UINT 8) x!
      result!
     )
     (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? result!) (%I x!))
   ))
   :pattern ((ens%curve25519_dalek!scalar.impl&%44.from. x! result!))
   :qid internal_ens__curve25519_dalek!scalar.impl&__44.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!scalar.impl&__44.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. $ (UINT 8)))
     (has_type result$ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar.
       $ (UINT 8)
      ) (DST $) (TYPE%tuple%1. $ (UINT 8)) (F fndef_singleton) closure%$ result$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? result$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 8)
     ) (DST $) (TYPE%tuple%1. $ (UINT 8)) (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__scalar__Scalar__from_62
   :skolemid skolem_user_curve25519_dalek__scalar__Scalar__from_62
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ TYPE%curve25519_dalek!scalar.Scalar. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ TYPE%curve25519_dalek!scalar.Scalar.
  $ (UINT 8)
))

;; Function-Specs curve25519_dalek::scalar::Scalar::from
(declare-fun ens%curve25519_dalek!scalar.impl&%45.from. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!scalar.impl&%45.from. x! result!) (and
     (ens%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar. $ (UINT 16) x!
      result!
     )
     (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? result!) (%I x!))
   ))
   :pattern ((ens%curve25519_dalek!scalar.impl&%45.from. x! result!))
   :qid internal_ens__curve25519_dalek!scalar.impl&__45.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!scalar.impl&__45.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. $ (UINT 16)))
     (has_type result$ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar.
       $ (UINT 16)
      ) (DST $) (TYPE%tuple%1. $ (UINT 16)) (F fndef_singleton) closure%$ result$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? result$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 16)
     ) (DST $) (TYPE%tuple%1. $ (UINT 16)) (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__scalar__Scalar__from_63
   :skolemid skolem_user_curve25519_dalek__scalar__Scalar__from_63
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ TYPE%curve25519_dalek!scalar.Scalar. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ TYPE%curve25519_dalek!scalar.Scalar.
  $ (UINT 16)
))

;; Function-Specs curve25519_dalek::scalar::Scalar::from
(declare-fun ens%curve25519_dalek!scalar.impl&%46.from. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!scalar.impl&%46.from. x! result!) (and
     (ens%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar. $ (UINT 32) x!
      result!
     )
     (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? result!) (%I x!))
   ))
   :pattern ((ens%curve25519_dalek!scalar.impl&%46.from. x! result!))
   :qid internal_ens__curve25519_dalek!scalar.impl&__46.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!scalar.impl&__46.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. $ (UINT 32)))
     (has_type result$ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar.
       $ (UINT 32)
      ) (DST $) (TYPE%tuple%1. $ (UINT 32)) (F fndef_singleton) closure%$ result$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? result$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 32)
     ) (DST $) (TYPE%tuple%1. $ (UINT 32)) (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__scalar__Scalar__from_64
   :skolemid skolem_user_curve25519_dalek__scalar__Scalar__from_64
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ TYPE%curve25519_dalek!scalar.Scalar. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ TYPE%curve25519_dalek!scalar.Scalar.
  $ (UINT 32)
))

;; Function-Specs curve25519_dalek::scalar::Scalar::from
(declare-fun ens%curve25519_dalek!scalar.impl&%47.from. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!scalar.impl&%47.from. x! result!) (and
     (ens%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar. $ (UINT 64) x!
      result!
     )
     (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? result!) (%I x!))
   ))
   :pattern ((ens%curve25519_dalek!scalar.impl&%47.from. x! result!))
   :qid internal_ens__curve25519_dalek!scalar.impl&__47.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!scalar.impl&__47.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. $ (UINT 64)))
     (has_type result$ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar.
       $ (UINT 64)
      ) (DST $) (TYPE%tuple%1. $ (UINT 64)) (F fndef_singleton) closure%$ result$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? result$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 64)
     ) (DST $) (TYPE%tuple%1. $ (UINT 64)) (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__scalar__Scalar__from_65
   :skolemid skolem_user_curve25519_dalek__scalar__Scalar__from_65
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ TYPE%curve25519_dalek!scalar.Scalar. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ TYPE%curve25519_dalek!scalar.Scalar.
  $ (UINT 64)
))

;; Function-Specs curve25519_dalek::scalar::Scalar::from
(declare-fun ens%curve25519_dalek!scalar.impl&%48.from. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!scalar.impl&%48.from. x! result!) (and
     (ens%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar. $ (UINT 128) x!
      result!
     )
     (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? result!) (%I x!))
   ))
   :pattern ((ens%curve25519_dalek!scalar.impl&%48.from. x! result!))
   :qid internal_ens__curve25519_dalek!scalar.impl&__48.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!scalar.impl&__48.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. $ (UINT 128)))
     (has_type result$ TYPE%curve25519_dalek!scalar.Scalar.)
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar.
       $ (UINT 128)
      ) (DST $) (TYPE%tuple%1. $ (UINT 128)) (F fndef_singleton) closure%$ result$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? result$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ TYPE%curve25519_dalek!scalar.Scalar.
      $ (UINT 128)
     ) (DST $) (TYPE%tuple%1. $ (UINT 128)) (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__scalar__Scalar__from_66
   :skolemid skolem_user_curve25519_dalek__scalar__Scalar__from_66
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ TYPE%curve25519_dalek!scalar.Scalar. $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ TYPE%curve25519_dalek!scalar.Scalar.
  $ (UINT 128)
))

;; Function-Specs curve25519_dalek::specs::field_specs_u64::p_gt_2
(declare-fun ens%curve25519_dalek!specs.field_specs_u64.p_gt_2. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!specs.field_specs_u64.p_gt_2. no%param) (and
     (> (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 2)
     (> (Sub (curve25519_dalek!specs.field_specs_u64.p.? (I 0)) 2) 0)
   ))
   :pattern ((ens%curve25519_dalek!specs.field_specs_u64.p_gt_2. no%param))
   :qid internal_ens__curve25519_dalek!specs.field_specs_u64.p_gt_2._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.field_specs_u64.p_gt_2._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::add_lemmas::lemma_fe51_limbs_bounded_weaken
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. Int Int) Bool
)
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (a! Int) (
    b! Int
   )
  ) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
    ) (and
     (=>
      %%global_location_label%%13
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        fe!
       ) (I a!)
     ))
     (=>
      %%global_location_label%%14
      (< a! b!)
     )
     (=>
      %%global_location_label%%15
      (<= b! 63)
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
 (curve25519_dalek!backend.serial.u64.field.FieldElement51. Int Int) Bool
)
(assert
 (forall ((fe! curve25519_dalek!backend.serial.u64.field.FieldElement51.) (a! Int) (
    b! Int
   )
  ) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
    ) (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      fe!
     ) (I b!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken.
     fe! a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.add_lemmas.lemma_fe51_limbs_bounded_weaken._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::impl&%6::add
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (_rhs! Poly) (output! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. self! _rhs! output!)
    (and
     (ens%core!ops.arith.Add.add. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! _rhs!
      output!
     )
     (= (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. output!) (curve25519_dalek!specs.field_specs.spec_add_fe51_limbs.?
       self! _rhs!
     ))
     (= (curve25519_dalek!specs.field_specs.fe51_as_nat.? output!) (nClip (Add (curve25519_dalek!specs.field_specs.fe51_as_nat.?
         self!
        ) (curve25519_dalek!specs.field_specs.fe51_as_nat.? _rhs!)
     )))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? output!) (curve25519_dalek!specs.field_specs.field_add.?
       (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? self!)) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         _rhs!
     ))))
     (=>
      (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 51))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? _rhs! (I 51))
      )
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 52))
     )
     (=>
      (and
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? self! (I 52))
       (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? _rhs! (I 52))
      )
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 53))
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%6.add. self! _rhs! output!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__6.add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__6.add._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::field::impl&%9::sub
(declare-fun ens%curve25519_dalek!backend.serial.u64.field.impl&%9.sub. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (_rhs! Poly) (output! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.field.impl&%9.sub. self! _rhs! output!)
    (and
     (ens%core!ops.arith.Sub.sub. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
      (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. self! _rhs!
      output!
     )
     (= (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. output!) (curve25519_dalek!specs.field_specs.spec_sub_limbs.?
       self! _rhs!
     ))
     (= (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? output!) (curve25519_dalek!specs.field_specs.field_sub.?
       (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.? self!)) (I (curve25519_dalek!specs.field_specs.fe51_as_canonical_nat.?
         _rhs!
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 52))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? output! (I 54))
   ))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.field.impl&%9.sub. self! _rhs! output!))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__9.sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.field.impl&__9.sub._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_lt_pow2_255
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
 (%%Function%%) Bool
)
(declare-const %%global_location_label%%16 Bool)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
     bytes!
    ) (=>
     %%global_location_label%%16
     (<= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $
          (CONST_INT 32)
         ) (Poly%array%. bytes!)
        ) (I 31)
       )
      ) 127
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
     bytes!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
 (%%Function%%) Bool
)
(assert
 (forall ((bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
     bytes!
    ) (< (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (vstd!arithmetic.power2.pow2.?
      (I 255)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255.
     bytes!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lt_pow2_255._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
)

;; Function-Specs curve25519_dalek::specs::edwards_specs::lemma_identity_affine_coords
(declare-fun req%curve25519_dalek!specs.edwards_specs.lemma_identity_affine_coords.
 (curve25519_dalek!edwards.EdwardsPoint.) Bool
)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((point! curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (req%curve25519_dalek!specs.edwards_specs.lemma_identity_affine_coords. point!)
    (=>
     %%global_location_label%%17
     (curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       point!
   ))))
   :pattern ((req%curve25519_dalek!specs.edwards_specs.lemma_identity_affine_coords. point!))
   :qid internal_req__curve25519_dalek!specs.edwards_specs.lemma_identity_affine_coords._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.edwards_specs.lemma_identity_affine_coords._definition
)))
(declare-fun ens%curve25519_dalek!specs.edwards_specs.lemma_identity_affine_coords.
 (curve25519_dalek!edwards.EdwardsPoint.) Bool
)
(assert
 (forall ((point! curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (ens%curve25519_dalek!specs.edwards_specs.lemma_identity_affine_coords. point!)
    (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       point!
      )
     ) (tuple%2./tuple%2 (I 0) (I 1))
   ))
   :pattern ((ens%curve25519_dalek!specs.edwards_specs.lemma_identity_affine_coords. point!))
   :qid internal_ens__curve25519_dalek!specs.edwards_specs.lemma_identity_affine_coords._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.edwards_specs.lemma_identity_affine_coords._definition
)))

;; Function-Specs curve25519_dalek::edwards::EdwardsPoint::identity
(declare-fun ens%curve25519_dalek!edwards.impl&%19.identity. (Poly) Bool)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!edwards.impl&%19.identity. result!) (and
     (ens%curve25519_dalek!traits.Identity.identity. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
      result!
     )
     (curve25519_dalek!specs.edwards_specs.is_identity_edwards_point.? result!)
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? result!)
     (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? result!) (curve25519_dalek!specs.edwards_specs.edwards_identity.?
       (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!edwards.impl&%19.identity. result!))
   :qid internal_ens__curve25519_dalek!edwards.impl&__19.identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!edwards.impl&__19.identity._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%curve25519_dalek!traits.Identity. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
)

;; Function-Specs curve25519_dalek::backend::serial::curve_models::impl&%29::add
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%29.add. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (other! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%29.add. self! other! result!)
    (and
     (ens%core!ops.arith.Add.add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. (
       REF $
      ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self! other!
      result!
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? result!)
     (= (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? result!)
      (let
       ((self_affine$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? self!)))
       (let
        ((other_affine$ (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
           other!
        )))
        (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
           (Poly%tuple%2. self_affine$)
          )
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. self_affine$))) (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. other_affine$))
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. other_affine$)))
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%29.add. self! other!
     result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__29.add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__29.add._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::CompletedPoint::as_extended
(declare-fun req%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended.
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint.) Bool
)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(declare-const %%global_location_label%%20 Bool)
(declare-const %%global_location_label%%21 Bool)
(declare-const %%global_location_label%%22 Bool)
(assert
 (forall ((self! curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= (req%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended. self!)
    (and
     (=>
      %%global_location_label%%18
      (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
        self!
     )))
     (=>
      %%global_location_label%%19
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%20
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%21
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%22
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended. self!))
   :qid internal_req__curve25519_dalek!backend.serial.curve_models.impl&__26.as_extended._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.curve_models.impl&__26.as_extended._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended.
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint. curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.curve_models.CompletedPoint.) (result!
    curve25519_dalek!edwards.EdwardsPoint.
   )
  ) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended. self! result!)
    (and
     (has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. result!) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        result!
       )
      ) (curve25519_dalek!specs.edwards_specs.completed_to_extended.? (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
        self!
     )))
     (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        result!
       )
      ) (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
        self!
   )))))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%26.as_extended. self!
     result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__26.as_extended._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__26.as_extended._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
))

;; Function-Specs curve25519_dalek::edwards::impl&%32::add
(declare-fun ens%curve25519_dalek!edwards.impl&%32.add. (Poly Poly Poly) Bool)
(assert
 (forall ((self! Poly) (other! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!edwards.impl&%32.add. self! other! result!) (and
     (ens%core!ops.arith.Add.add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. (
       REF $
      ) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! other! result!
     )
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? result!)
     (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? self!)))
      (let
       ((x1$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
       (let
        ((y1$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
        (let
         ((tmp%%$1 (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? other!)))
         (let
          ((x2$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$1))))))
          (let
           ((y2$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$1))))))
           (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? result!) (curve25519_dalek!specs.edwards_specs.edwards_add.?
             (I x1$) (I y1$) (I x2$) (I y2$)
   ))))))))))
   :pattern ((ens%curve25519_dalek!edwards.impl&%32.add. self! other! result!))
   :qid internal_ens__curve25519_dalek!edwards.impl&__32.add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!edwards.impl&__32.add._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::impl&%31::sub
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%31.sub. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (other! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%31.sub. self! other! result!)
    (and
     (ens%core!ops.arith.Sub.sub. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. (
       REF $
      ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. self! other!
      result!
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? result!)
     (= (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? result!)
      (let
       ((self_affine$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? self!)))
       (let
        ((other_affine$ (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
           other!
        )))
        (curve25519_dalek!specs.edwards_specs.edwards_sub.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
           (Poly%tuple%2. self_affine$)
          )
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. self_affine$))) (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. other_affine$))
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. other_affine$)))
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%31.sub. self! other!
     result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__31.sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__31.sub._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
))

;; Function-Specs curve25519_dalek::edwards::impl&%39::sub
(declare-fun ens%curve25519_dalek!edwards.impl&%39.sub. (Poly Poly Poly) Bool)
(assert
 (forall ((self! Poly) (other! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!edwards.impl&%39.sub. self! other! result!) (and
     (ens%core!ops.arith.Sub.sub. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. (
       REF $
      ) TYPE%curve25519_dalek!edwards.EdwardsPoint. self! other! result!
     )
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? result!)
     (let
      ((tmp%%$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? self!)))
      (let
       ((x1$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
       (let
        ((y1$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
        (let
         ((tmp%%$1 (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? other!)))
         (let
          ((x2$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$1))))))
          (let
           ((y2$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$1))))))
           (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? result!) (curve25519_dalek!specs.edwards_specs.edwards_sub.?
             (I x1$) (I y1$) (I x2$) (I y2$)
   ))))))))))
   :pattern ((ens%curve25519_dalek!edwards.impl&%39.sub. self! other! result!))
   :qid internal_ens__curve25519_dalek!edwards.impl&__39.sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!edwards.impl&__39.sub._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::axiom_edwards_add_associative
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative.
 (Int Int Int Int Int Int) Bool
)
(assert
 (forall ((x1! Int) (y1! Int) (x2! Int) (y2! Int) (x3! Int) (y3! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative.
     x1! y1! x2! y2! x3! y3!
    ) (= (let
      ((ab$ (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x1!) (I y1!) (I x2!) (I
          y2!
      ))))
      (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
         (Poly%tuple%2. ab$)
        )
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. ab$))) (I x3!) (I y3!)
      )
     ) (let
      ((bc$ (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x2!) (I y2!) (I x3!) (I
          y3!
      ))))
      (curve25519_dalek!specs.edwards_specs.edwards_add.? (I x1!) (I y1!) (tuple%2./tuple%2/0
        (%Poly%tuple%2. (Poly%tuple%2. bc$))
       ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. bc$)))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative.
     x1! y1! x2! y2! x3! y3!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.axiom_edwards_add_associative._definition
)))

;; Function-Specs curve25519_dalek::window::LookupTable::from
(declare-fun ens%curve25519_dalek!window.impl&%12.from. (Poly Poly) Bool)
(assert
 (forall ((P! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%12.from. P! result!) (and
     (ens%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P! result!
     )
     (curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.? $ (CONST_INT
       8
      ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
         result!
       ))
      ) P! (I 8)
     )
     (curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.? $ (CONST_INT
       8
      ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
         result!
     ))))
     (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
           $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
            $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
               result!
            )))
           ) j$
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             result!
          )))
         ) j$
       ))
       :qid user_curve25519_dalek__window__LookupTable__from_67
       :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_67
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%12.from. P! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__12.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__12.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (has_type result$ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (F fndef_singleton) closure%$ result$
     )
     (let
      ((P$ (%Poly%curve25519_dalek!edwards.EdwardsPoint. (tuple%1./tuple%1/0 (%Poly%tuple%1.
           closure%$
      )))))
      (and
       (and
        (curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.? $ (CONST_INT
          8
         ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
            result$
          ))
         ) (Poly%curve25519_dalek!edwards.EdwardsPoint. P$) (I 8)
        )
        (curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.? $ (CONST_INT
          8
         ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
            result$
       )))))
       (forall ((j$ Poly)) (!
         (=>
          (has_type j$ INT)
          (=>
           (let
            ((tmp%%$ (%I j$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ 8)
           ))
           (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
              $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
               $ (CONST_INT 8)
              ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                 result$
              )))
             ) j$
         ))))
         :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
               result$
            )))
           ) j$
         ))
         :qid user_curve25519_dalek__window__LookupTable__from_68
         :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_68
   ))))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__LookupTable__from_69
   :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_69
)))

;; Function-Specs curve25519_dalek::scalar::Scalar::as_radix_16
(declare-fun req%curve25519_dalek!scalar.impl&%52.as_radix_16. (curve25519_dalek!scalar.Scalar.)
 Bool
)
(declare-const %%global_location_label%%23 Bool)
(assert
 (forall ((self! curve25519_dalek!scalar.Scalar.)) (!
   (= (req%curve25519_dalek!scalar.impl&%52.as_radix_16. self!) (=>
     %%global_location_label%%23
     (<= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $
          (CONST_INT 32)
         ) (Poly%array%. (curve25519_dalek!scalar.Scalar./Scalar/bytes (%Poly%curve25519_dalek!scalar.Scalar.
            (Poly%curve25519_dalek!scalar.Scalar. self!)
         )))
        ) (I 31)
       )
      ) 127
   )))
   :pattern ((req%curve25519_dalek!scalar.impl&%52.as_radix_16. self!))
   :qid internal_req__curve25519_dalek!scalar.impl&__52.as_radix_16._definition
   :skolemid skolem_internal_req__curve25519_dalek!scalar.impl&__52.as_radix_16._definition
)))
(declare-fun ens%curve25519_dalek!scalar.impl&%52.as_radix_16. (curve25519_dalek!scalar.Scalar.
  %%Function%%
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!scalar.Scalar.) (result! %%Function%%)) (!
   (= (ens%curve25519_dalek!scalar.impl&%52.as_radix_16. self! result!) (and
     (has_type (Poly%array%. result!) (ARRAY $ (SINT 8) $ (CONST_INT 64)))
     (curve25519_dalek!specs.scalar_specs.is_valid_radix_16.? (Poly%array%. result!))
     (curve25519_dalek!specs.scalar_specs.radix_16_all_bounded.? (Poly%array%. result!))
     (= (curve25519_dalek!specs.scalar_specs.reconstruct_radix_16.? (vstd!view.View.view.?
        $ (ARRAY $ (SINT 8) $ (CONST_INT 64)) (Poly%array%. result!)
       )
      ) (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? (Poly%curve25519_dalek!scalar.Scalar.
        self!
   )))))
   :pattern ((ens%curve25519_dalek!scalar.impl&%52.as_radix_16. self! result!))
   :qid internal_ens__curve25519_dalek!scalar.impl&__52.as_radix_16._definition
   :skolemid skolem_internal_ens__curve25519_dalek!scalar.impl&__52.as_radix_16._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::ProjectiveNielsPoint::identity
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%18.identity. (
  Poly
 ) Bool
)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%18.identity. result!) (
     and
     (ens%curve25519_dalek!traits.Identity.identity. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      result!
     )
     (= (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. result!)
      (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%18.identity. result!))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__18.identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__18.identity._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%curve25519_dalek!traits.Identity. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
)

;; Function-Specs curve25519_dalek::window::LookupTable::select
(declare-fun req%curve25519_dalek!window.impl&%7.select. (curve25519_dalek!window.LookupTable.
  Int
 ) Bool
)
(declare-const %%global_location_label%%24 Bool)
(declare-const %%global_location_label%%25 Bool)
(declare-const %%global_location_label%%26 Bool)
(declare-const %%global_location_label%%27 Bool)
(assert
 (forall ((self! curve25519_dalek!window.LookupTable.) (x! Int)) (!
   (= (req%curve25519_dalek!window.impl&%7.select. self! x!) (and
     (=>
      %%global_location_label%%24
      (<= (Sub 0 8) x!)
     )
     (=>
      %%global_location_label%%25
      (<= x! 8)
     )
     (=>
      %%global_location_label%%26
      (curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.? $ (CONST_INT
        8
       ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
          (Poly%curve25519_dalek!window.LookupTable. self!)
     )))))
     (=>
      %%global_location_label%%27
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
             $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              $ (CONST_INT 8)
             ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                (Poly%curve25519_dalek!window.LookupTable. self!)
             )))
            ) j$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            $ (CONST_INT 8)
           ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
              (Poly%curve25519_dalek!window.LookupTable. self!)
           )))
          ) j$
        ))
        :qid user_curve25519_dalek__window__LookupTable__select_70
        :skolemid skolem_user_curve25519_dalek__window__LookupTable__select_70
   )))))
   :pattern ((req%curve25519_dalek!window.impl&%7.select. self! x!))
   :qid internal_req__curve25519_dalek!window.impl&__7.select._definition
   :skolemid skolem_internal_req__curve25519_dalek!window.impl&__7.select._definition
)))
(declare-fun ens%curve25519_dalek!window.impl&%7.select. (curve25519_dalek!window.LookupTable.
  Int curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!window.LookupTable.) (x! Int) (result! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
  (!
   (= (ens%curve25519_dalek!window.impl&%7.select. self! x! result!) (and
     (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       result!
      ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
     )
     (=>
      (> x! 0)
      (= result! (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
        (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             (Poly%curve25519_dalek!window.LookupTable. self!)
          )))
         ) (I (Sub x! 1))
     ))))
     (=>
      (= x! 0)
      (= result! (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0)))
     )
     (=>
      (< x! 0)
      (= result! (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? (vstd!seq.Seq.index.?
         $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
          $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             (Poly%curve25519_dalek!window.LookupTable. self!)
          )))
         ) (I (Sub (Sub 0 x!) 1))
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       result!
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%7.select. self! x! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__7.select._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__7.select._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::CompletedPoint::as_projective
(declare-fun req%curve25519_dalek!backend.serial.curve_models.impl&%26.as_projective.
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint.) Bool
)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(declare-const %%global_location_label%%32 Bool)
(assert
 (forall ((self! curve25519_dalek!backend.serial.curve_models.CompletedPoint.)) (!
   (= (req%curve25519_dalek!backend.serial.curve_models.impl&%26.as_projective. self!)
    (and
     (=>
      %%global_location_label%%28
      (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
        self!
     )))
     (=>
      %%global_location_label%%29
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%30
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%31
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%32
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
          (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. self!)
        ))
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!backend.serial.curve_models.impl&%26.as_projective.
     self!
   ))
   :qid internal_req__curve25519_dalek!backend.serial.curve_models.impl&__26.as_projective._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.curve_models.impl&__26.as_projective._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%26.as_projective.
 (curve25519_dalek!backend.serial.curve_models.CompletedPoint. curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
 Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.curve_models.CompletedPoint.) (result!
    curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
   )
  ) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%26.as_projective. self!
     result!
    ) (and
     (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. result!)
      TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_projective_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
       result!
     ))
     (= (curve25519_dalek!specs.edwards_specs.projective_point_edwards_as_nat.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
        result!
       )
      ) (curve25519_dalek!specs.edwards_specs.completed_to_projective.? (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
        self!
     )))
     (= (curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
        result!
       )
      ) (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
        self!
     )))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X (
         %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
          result!
       )))
      ) (I 52)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y (
         %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
          result!
       )))
      ) (I 52)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z (
         %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
          result!
       )))
      ) (I 52)
     )
     (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X (
         %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
          result!
       )))
      ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
          result!
       )))
      ) (I 18446744073709551615)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%26.as_projective.
     self! result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__26.as_projective._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__26.as_projective._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::ProjectivePoint::double
(declare-fun req%curve25519_dalek!backend.serial.curve_models.impl&%27.double. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
 Bool
)
(declare-const %%global_location_label%%33 Bool)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(declare-const %%global_location_label%%36 Bool)
(declare-const %%global_location_label%%37 Bool)
(assert
 (forall ((self! curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)) (!
   (= (req%curve25519_dalek!backend.serial.curve_models.impl&%27.double. self!) (and
     (=>
      %%global_location_label%%33
      (curve25519_dalek!specs.edwards_specs.is_valid_projective_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
        self!
     )))
     (=>
      %%global_location_label%%34
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X (
          %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
           self!
        )))
       ) (I 52)
     ))
     (=>
      %%global_location_label%%35
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y (
          %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
           self!
        )))
       ) (I 52)
     ))
     (=>
      %%global_location_label%%36
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z (
          %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
           self!
        )))
       ) (I 52)
     ))
     (=>
      %%global_location_label%%37
      (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X (
          %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
           self!
        )))
       ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
         (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
           self!
        )))
       ) (I 18446744073709551615)
   ))))
   :pattern ((req%curve25519_dalek!backend.serial.curve_models.impl&%27.double. self!))
   :qid internal_req__curve25519_dalek!backend.serial.curve_models.impl&__27.double._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.curve_models.impl&__27.double._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%27.double. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
  curve25519_dalek!backend.serial.curve_models.CompletedPoint.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.curve_models.ProjectivePoint.) (result!
    curve25519_dalek!backend.serial.curve_models.CompletedPoint.
   )
  ) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%27.double. self! result!)
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. result!)
      TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
       result!
     ))
     (= (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
        result!
       )
      ) (let
       ((tmp%%$ (curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.?
          (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. self!)
       )))
       (let
        ((x$ (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
        (let
         ((y$ (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. tmp%%$))))))
         (curve25519_dalek!specs.edwards_specs.edwards_double.? (I x$) (I y$))
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. result!)
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. result!)
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. result!)
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         (Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint. result!)
       ))
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%27.double. self!
     result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__27.double._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__27.double._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (TYPE%curve25519_dalek!window.LookupTable.
   $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::AffineNielsPoint::identity
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%20.identity. (
  Poly
 ) Bool
)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%20.identity. result!) (
     and
     (ens%curve25519_dalek!traits.Identity.identity. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      result!
     )
     (= (%Poly%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. result!)
      (curve25519_dalek!specs.edwards_specs.identity_affine_niels.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%20.identity. result!))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__20.identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__20.identity._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%curve25519_dalek!traits.Identity. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
)

;; Function-Specs curve25519_dalek::backend::serial::curve_models::impl&%33::add
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%33.add. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (other! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%33.add. self! other! result!)
    (and
     (ens%core!ops.arith.Add.add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. (
       REF $
      ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self! other!
      result!
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? result!)
     (= (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? result!)
      (let
       ((self_affine$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? self!)))
       (let
        ((other_affine$ (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
           other!
        )))
        (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
           (Poly%tuple%2. self_affine$)
          )
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. self_affine$))) (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. other_affine$))
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. other_affine$)))
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%33.add. self! other!
     result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__33.add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__33.add._definition
)))

;; Function-Specs curve25519_dalek::edwards::EdwardsPoint::mul_by_pow_2
(declare-fun req%curve25519_dalek!edwards.impl&%71.mul_by_pow_2. (curve25519_dalek!edwards.EdwardsPoint.
  Int
 ) Bool
)
(declare-const %%global_location_label%%38 Bool)
(declare-const %%global_location_label%%39 Bool)
(assert
 (forall ((self! curve25519_dalek!edwards.EdwardsPoint.) (k! Int)) (!
   (= (req%curve25519_dalek!edwards.impl&%71.mul_by_pow_2. self! k!) (and
     (=>
      %%global_location_label%%38
      (> k! 0)
     )
     (=>
      %%global_location_label%%39
      (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        self!
   )))))
   :pattern ((req%curve25519_dalek!edwards.impl&%71.mul_by_pow_2. self! k!))
   :qid internal_req__curve25519_dalek!edwards.impl&__71.mul_by_pow_2._definition
   :skolemid skolem_internal_req__curve25519_dalek!edwards.impl&__71.mul_by_pow_2._definition
)))
(declare-fun ens%curve25519_dalek!edwards.impl&%71.mul_by_pow_2. (curve25519_dalek!edwards.EdwardsPoint.
  Int curve25519_dalek!edwards.EdwardsPoint.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!edwards.EdwardsPoint.) (k! Int) (result! curve25519_dalek!edwards.EdwardsPoint.))
  (!
   (= (ens%curve25519_dalek!edwards.impl&%71.mul_by_pow_2. self! k! result!) (and
     (has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. result!) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        result!
       )
      ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
         (Poly%curve25519_dalek!edwards.EdwardsPoint. self!)
        )
       ) (I (vstd!arithmetic.power2.pow2.? (I k!)))
   ))))
   :pattern ((ens%curve25519_dalek!edwards.impl&%71.mul_by_pow_2. self! k! result!))
   :qid internal_ens__curve25519_dalek!edwards.impl&__71.mul_by_pow_2._definition
   :skolemid skolem_internal_ens__curve25519_dalek!edwards.impl&__71.mul_by_pow_2._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_edwards_add_identity_right_canonical
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
 (tuple%2.) Bool
)
(declare-const %%global_location_label%%40 Bool)
(declare-const %%global_location_label%%41 Bool)
(assert
 (forall ((P! tuple%2.)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
     P!
    ) (and
     (=>
      %%global_location_label%%40
      (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
     )))
     (=>
      %%global_location_label%%41
      (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
     P!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
 (tuple%2.) Bool
)
(assert
 (forall ((P! tuple%2.)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
     P!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
        (Poly%tuple%2. P!)
       )
      ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. P!))) (I 0) (I 1)
     ) P!
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical.
     P!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_edwards_add_identity_right_canonical._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.AddSpec. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
  $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
)

;; Function-Specs curve25519_dalek::window::LookupTable::from
(declare-fun ens%curve25519_dalek!window.impl&%13.from. (Poly Poly) Bool)
(assert
 (forall ((P! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%13.from. P! result!) (and
     (ens%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. P! result!
     )
     (curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.? $ (CONST_INT 8)
      (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
         result!
       ))
      ) P! (I 8)
     )
     (curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.? $ (CONST_INT
       8
      ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
         result!
     ))))
     (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (vstd!seq.Seq.index.?
           $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
            $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
              CONST_INT 8
             )
            ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
               result!
            )))
           ) j$
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
             result!
          )))
         ) j$
       ))
       :qid user_curve25519_dalek__window__LookupTable__from_71
       :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_71
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%13.from. P! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__13.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__13.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (has_type result$ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (F fndef_singleton) closure%$ result$
     )
     (let
      ((P$ (%Poly%curve25519_dalek!edwards.EdwardsPoint. (tuple%1./tuple%1/0 (%Poly%tuple%1.
           closure%$
      )))))
      (and
       (and
        (curve25519_dalek!specs.window_specs.is_valid_lookup_table_affine.? $ (CONST_INT 8)
         (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
            result$
          ))
         ) (Poly%curve25519_dalek!edwards.EdwardsPoint. P$) (I 8)
        )
        (curve25519_dalek!specs.window_specs.lookup_table_affine_limbs_bounded.? $ (CONST_INT
          8
         ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
            result$
       )))))
       (forall ((j$ Poly)) (!
         (=>
          (has_type j$ INT)
          (=>
           (let
            ((tmp%%$ (%I j$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ 8)
           ))
           (curve25519_dalek!specs.edwards_specs.is_valid_affine_niels_point.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. (vstd!view.View.view.?
              $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. $ (
                CONST_INT 8
               )
              ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                 result$
              )))
             ) j$
         ))))
         :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
           (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
               result$
            )))
           ) j$
         ))
         :qid user_curve25519_dalek__window__LookupTable__from_72
         :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_72
   ))))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__LookupTable__from_73
   :skolemid skolem_user_curve25519_dalek__window__LookupTable__from_73
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (TYPE%curve25519_dalek!window.LookupTable.
   $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::window::NafLookupTable5::from
(declare-fun ens%curve25519_dalek!window.impl&%17.from. (Poly Poly) Bool)
(assert
 (forall ((A! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%17.from. A! result!) (and
     (ens%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A! result!
     )
     (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.? (Poly%array%.
       (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
         result!
       ))
      ) A!
     )
     (curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
      (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
         result!
     ))))
     (forall ((j$ Poly)) (!
       (=>
        (has_type j$ INT)
        (=>
         (let
          ((tmp%%$ (%I j$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 8)
         ))
         (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
           $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
            $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
               result!
            )))
           ) j$
       ))))
       :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           $ (CONST_INT 8)
          ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
             result!
          )))
         ) j$
       ))
       :qid user_curve25519_dalek__window__NafLookupTable5__from_74
       :skolemid skolem_user_curve25519_dalek__window__NafLookupTable5__from_74
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%17.from. A! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__17.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__17.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (has_type result$ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (F fndef_singleton) closure%$ result$
     )
     (let
      ((A$ (%Poly%curve25519_dalek!edwards.EdwardsPoint. (tuple%1./tuple%1/0 (%Poly%tuple%1.
           closure%$
      )))))
      (and
       (and
        (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_projective.? (Poly%array%.
          (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
            result$
          ))
         ) (Poly%curve25519_dalek!edwards.EdwardsPoint. A$)
        )
        (curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
         (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
            result$
       )))))
       (forall ((j$ Poly)) (!
         (=>
          (has_type j$ INT)
          (=>
           (let
            ((tmp%%$ (%I j$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ 8)
           ))
           (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
              $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
               $ (CONST_INT 8)
              ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
                 result$
              )))
             ) j$
         ))))
         :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
               result$
            )))
           ) j$
         ))
         :qid user_curve25519_dalek__window__NafLookupTable5__from_75
         :skolemid skolem_user_curve25519_dalek__window__NafLookupTable5__from_75
   ))))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__NafLookupTable5__from_76
   :skolemid skolem_user_curve25519_dalek__window__NafLookupTable5__from_76
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
   $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Function-Specs curve25519_dalek::window::NafLookupTable5::from
(declare-fun ens%curve25519_dalek!window.impl&%18.from. (Poly Poly) Bool)
(assert
 (forall ((A! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!window.impl&%18.from. A! result!) (and
     (ens%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
      (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. A! result!
     )
     (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.? (Poly%array%.
       (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
         result!
       ))
      ) A!
     )
     (curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.? (Poly%array%.
       (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
         result!
   ))))))
   :pattern ((ens%curve25519_dalek!window.impl&%18.from. A! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__18.from._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__18.from._definition
)))
(assert
 (forall ((closure%$ Poly) (result$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (has_type result$ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.))
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
        $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
       ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
      ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
      (F fndef_singleton) closure%$ result$
     )
     (let
      ((A$ (%Poly%curve25519_dalek!edwards.EdwardsPoint. (tuple%1./tuple%1/0 (%Poly%tuple%1.
           closure%$
      )))))
      (and
       (curve25519_dalek!specs.window_specs.is_valid_naf_lookup_table5_affine.? (Poly%array%.
         (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
           result$
         ))
        ) (Poly%curve25519_dalek!edwards.EdwardsPoint. A$)
       )
       (curve25519_dalek!specs.window_specs.naf_lookup_table5_affine_limbs_bounded.? (Poly%array%.
         (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
           result$
   ))))))))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
       $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
      ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (F fndef_singleton) closure%$ result$
   ))
   :qid user_curve25519_dalek__window__NafLookupTable5__from_77
   :skolemid skolem_user_curve25519_dalek__window__NafLookupTable5__from_77
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (TYPE%curve25519_dalek!window.NafLookupTable5. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
  (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.convert.FromSpec. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
   $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ TYPE%curve25519_dalek!backend.serial.curve_models.CompletedPoint.)
)

;; Function-Specs curve25519_dalek::backend::serial::curve_models::ProjectivePoint::identity
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%17.identity. (
  Poly
 ) Bool
)
(assert
 (forall ((result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%17.identity. result!) (
     and
     (ens%curve25519_dalek!traits.Identity.identity. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
      result!
     )
     (= (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. result!) (
       curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.? (I 0)
   ))))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%17.identity. result!))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__17.identity._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__17.identity._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%curve25519_dalek!traits.Identity. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)
)

;; Function-Specs curve25519_dalek::backend::serial::curve_models::impl&%35::sub
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%35.sub. (Poly Poly
  Poly
 ) Bool
)
(assert
 (forall ((self! Poly) (other! Poly) (result! Poly)) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%35.sub. self! other! result!)
    (and
     (ens%core!ops.arith.Sub.sub. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint. (
       REF $
      ) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint. self! other!
      result!
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_completed_point.? result!)
     (= (curve25519_dalek!specs.edwards_specs.completed_point_as_affine_edwards.? result!)
      (let
       ((self_affine$ (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? self!)))
       (let
        ((other_affine$ (curve25519_dalek!specs.edwards_specs.affine_niels_point_as_affine_edwards.?
           other!
        )))
        (curve25519_dalek!specs.edwards_specs.edwards_sub.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
           (Poly%tuple%2. self_affine$)
          )
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. self_affine$))) (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. other_affine$))
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. other_affine$)))
     ))))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/X (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Y (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/Z (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.CompletedPoint./CompletedPoint/T (%Poly%curve25519_dalek!backend.serial.curve_models.CompletedPoint.
         result!
       ))
      ) (I 54)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%35.sub. self! other!
     result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__35.sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__35.sub._definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.ops.SubSpec. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  (REF $) TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!clone.Clone. $ (TYPE%curve25519_dalek!window.LookupTable. T&. T&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%curve25519_dalek!window.LookupTable. T&.
      T&
   )))
   :qid internal_curve25519_dalek__window__impl&__8_trait_impl_definition
   :skolemid skolem_internal_curve25519_dalek__window__impl&__8_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!clone.Clone. $ (TYPE%curve25519_dalek!window.NafLookupTable5. T&. T&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%curve25519_dalek!window.NafLookupTable5.
      T&. T&
   )))
   :qid internal_curve25519_dalek__window__impl&__1_trait_impl_definition
   :skolemid skolem_internal_curve25519_dalek__window__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
  $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.Eq. $ TYPE%curve25519_dalek!backend.serial.curve_models.AffineNielsPoint.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!scalar.Scalar. $ TYPE%curve25519_dalek!scalar.Scalar.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ TYPE%curve25519_dalek!scalar.Scalar. (REF $) TYPE%curve25519_dalek!scalar.Scalar.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ TYPE%curve25519_dalek!scalar.Scalar. $ TYPE%curve25519_dalek!scalar.Scalar.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (REF $)
  TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Add. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) TYPE%curve25519_dalek!scalar.Scalar. $ TYPE%curve25519_dalek!scalar.Scalar.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
  $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ TYPE%curve25519_dalek!scalar.Scalar. (REF $) TYPE%curve25519_dalek!scalar.Scalar.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ TYPE%curve25519_dalek!scalar.Scalar. $ TYPE%curve25519_dalek!scalar.Scalar.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (REF $)
  TYPE%curve25519_dalek!edwards.EdwardsPoint.
))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Sub. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
)

;; Trait-Impl-Axiom
(assert
 (forall ((VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (tr_bound%core!cmp.Ord. VERUS_SPEC__A&. VERUS_SPEC__A&)
    (tr_bound%vstd!std_specs.cmp.OrdSpec. VERUS_SPEC__A&. VERUS_SPEC__A&)
   )
   :pattern ((tr_bound%vstd!std_specs.cmp.OrdSpec. VERUS_SPEC__A&. VERUS_SPEC__A&))
   :qid internal_vstd__std_specs__cmp__impl&__5_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__cmp__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((Rhs&. Dcr) (Rhs& Type) (VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (and
     (sized Rhs&.)
     (tr_bound%core!ops.arith.Add. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
    )
    (tr_bound%vstd!std_specs.ops.AddSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
   )
   :pattern ((tr_bound%vstd!std_specs.ops.AddSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&.
     Rhs&
   ))
   :qid internal_vstd__std_specs__ops__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__ops__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((Rhs&. Dcr) (Rhs& Type) (VERUS_SPEC__A&. Dcr) (VERUS_SPEC__A& Type)) (!
   (=>
    (and
     (sized Rhs&.)
     (tr_bound%core!ops.arith.Sub. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
    )
    (tr_bound%vstd!std_specs.ops.SubSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&. Rhs&)
   )
   :pattern ((tr_bound%vstd!std_specs.ops.SubSpec. VERUS_SPEC__A&. VERUS_SPEC__A& Rhs&.
     Rhs&
   ))
   :qid internal_vstd__std_specs__ops__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__ops__impl&__3_trait_impl_definition
)))

;; Function-Specs curve25519_dalek::scalar::Scalar::non_adjacent_form
(declare-fun req%curve25519_dalek!scalar.impl&%52.non_adjacent_form. (curve25519_dalek!scalar.Scalar.
  Int
 ) Bool
)
(declare-const %%global_location_label%%42 Bool)
(declare-const %%global_location_label%%43 Bool)
(assert
 (forall ((self! curve25519_dalek!scalar.Scalar.) (w! Int)) (!
   (= (req%curve25519_dalek!scalar.impl&%52.non_adjacent_form. self! w!) (and
     (=>
      %%global_location_label%%42
      (let
       ((tmp%%$ w!))
       (and
        (<= 2 tmp%%$)
        (<= tmp%%$ 8)
     )))
     (=>
      %%global_location_label%%43
      (< (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? (Poly%curve25519_dalek!scalar.Scalar.
         self!
        )
       ) (vstd!arithmetic.power2.pow2.? (I 255))
   ))))
   :pattern ((req%curve25519_dalek!scalar.impl&%52.non_adjacent_form. self! w!))
   :qid internal_req__curve25519_dalek!scalar.impl&__52.non_adjacent_form._definition
   :skolemid skolem_internal_req__curve25519_dalek!scalar.impl&__52.non_adjacent_form._definition
)))
(declare-fun ens%curve25519_dalek!scalar.impl&%52.non_adjacent_form. (curve25519_dalek!scalar.Scalar.
  Int %%Function%%
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!scalar.Scalar.) (w! Int) (result! %%Function%%))
  (!
   (= (ens%curve25519_dalek!scalar.impl&%52.non_adjacent_form. self! w! result!) (and
     (has_type (Poly%array%. result!) (ARRAY $ (SINT 8) $ (CONST_INT 256)))
     (= (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!view.View.view.? $ (ARRAY
         $ (SINT 8) $ (CONST_INT 256)
        ) (Poly%array%. result!)
       )
      ) (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? (Poly%curve25519_dalek!scalar.Scalar.
        self!
     )))
     (curve25519_dalek!specs.scalar_specs.is_valid_naf.? (vstd!view.View.view.? $ (ARRAY
        $ (SINT 8) $ (CONST_INT 256)
       ) (Poly%array%. result!)
      ) (I w!)
   )))
   :pattern ((ens%curve25519_dalek!scalar.impl&%52.non_adjacent_form. self! w! result!))
   :qid internal_ens__curve25519_dalek!scalar.impl&__52.non_adjacent_form._definition
   :skolemid skolem_internal_ens__curve25519_dalek!scalar.impl&__52.non_adjacent_form._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_identity_projective_point_properties
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_point_properties.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_point_properties.
     no%param
    ) (and
     (curve25519_dalek!specs.edwards_specs.is_valid_projective_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
       (curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.? (I 0))
     ))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X (
         %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
          (curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.? (I 0))
       )))
      ) (I 52)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y (
         %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
          (curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.? (I 0))
       )))
      ) (I 52)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z (
         %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
          (curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.? (I 0))
       )))
      ) (I 52)
     )
     (curve25519_dalek!specs.field_specs.sum_of_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X (
         %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
          (curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.? (I 0))
       )))
      ) (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
          (curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.? (I 0))
       )))
      ) (I 18446744073709551615)
     )
     (= (curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
        (curve25519_dalek!specs.edwards_specs.identity_projective_point_edwards.? (I 0))
       )
      ) (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_point_properties.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_point_properties._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_identity_projective_point_properties._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_edwards_point_as_affine_canonical
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_edwards_point_as_affine_canonical.
 (curve25519_dalek!edwards.EdwardsPoint.) Bool
)
(assert
 (forall ((point! curve25519_dalek!edwards.EdwardsPoint.)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_edwards_point_as_affine_canonical.
     point!
    ) (and
     (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
           (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )
     (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.?
           (Poly%curve25519_dalek!edwards.EdwardsPoint. point!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_edwards_point_as_affine_canonical.
     point!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_edwards_point_as_affine_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_edwards_point_as_affine_canonical._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_straus_vt_base
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_base.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>.) Bool
)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (nafs! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.))
  (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_base.
     points_affine! nafs!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_partial.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       points_affine!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. nafs!) (I 256)
     ) (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_base.
     points_affine! nafs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_base._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_base._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_straus_vt_step
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_step.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int) Bool
)
(declare-const %%global_location_label%%44 Bool)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (nafs! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (i! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_step.
     points_affine! nafs! i!
    ) (=>
     %%global_location_label%%44
     (let
      ((tmp%%$ i!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ 256)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_step.
     points_affine! nafs! i!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_step._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_step._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_step.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int) Bool
)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (nafs! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (i! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_step.
     points_affine! nafs! i!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_partial.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       points_affine!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. nafs!) (I i!)
     ) (let
      ((prev$ (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_partial.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
          points_affine!
         ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. nafs!) (I (Add i! 1))
      )))
      (let
       ((doubled$ (curve25519_dalek!specs.edwards_specs.edwards_double.? (tuple%2./tuple%2/0
           (%Poly%tuple%2. (Poly%tuple%2. prev$))
          ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. prev$)))
       )))
       (let
        ((col$ (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
            points_affine!
           ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. nafs!) (I i!) (I (vstd!seq.Seq.len.? (DST
              $
             ) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!)
        )))))
        (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
           (Poly%tuple%2. doubled$)
          )
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. doubled$))) (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. col$))
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. col$)))
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_step.
     points_affine! nafs! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_step._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_step._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_column_sum_canonical
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int) Bool
)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(declare-const %%global_location_label%%49 Bool)
(declare-const %%global_location_label%%50 Bool)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (n! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
     points_affine! digits! j! n!
    ) (and
     (=>
      %%global_location_label%%45
      (>= n! 0)
     )
     (=>
      %%global_location_label%%46
      (<= n! (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         points_affine!
     ))))
     (=>
      %%global_location_label%%47
      (<= n! (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
         digits!
     ))))
     (=>
      %%global_location_label%%48
      (<= 0 j!)
     )
     (=>
      %%global_location_label%%49
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ n!)
          ))
          (< j! (vstd!seq.Seq.len.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT
               8
              )
             ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) k$
        )))))
        :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
           digits!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_canonical_78
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_canonical_78
     )))
     (=>
      %%global_location_label%%50
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ n!)
          ))
          (and
           (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) k$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
           )
           (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2.
                 $ NAT $ NAT
                ) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) k$
             )))
            ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
        ))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           points_affine!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_canonical_79
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_column_sum_canonical_79
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
     points_affine! digits! j! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int) Bool
)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (n! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
     points_affine! digits! j! n!
    ) (and
     (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
           (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
            digits!
           ) (I j!) (I n!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     )
     (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
           (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
            digits!
           ) (I j!) (I n!)
       ))))
      ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical.
     points_affine! digits! j! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_canonical._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_column_sum_step_zero_digit
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_step_zero_digit.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int) Bool
)
(declare-const %%global_location_label%%51 Bool)
(declare-const %%global_location_label%%52 Bool)
(declare-const %%global_location_label%%53 Bool)
(declare-const %%global_location_label%%54 Bool)
(declare-const %%global_location_label%%55 Bool)
(declare-const %%global_location_label%%56 Bool)
(declare-const %%global_location_label%%57 Bool)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (k! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_step_zero_digit.
     points_affine! digits! j! k!
    ) (and
     (=>
      %%global_location_label%%51
      (let
       ((tmp%%$ k!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           points_affine!
     ))))))
     (=>
      %%global_location_label%%52
      (let
       ((tmp%%$ k!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
           digits!
     ))))))
     (=>
      %%global_location_label%%53
      (<= 0 j!)
     )
     (=>
      %%global_location_label%%54
      (< j! (vstd!seq.Seq.len.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT
           8
          )
         ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) (I k!)
     ))))
     (=>
      %%global_location_label%%55
      (= (%I (vstd!seq.Seq.index.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $
           (SINT 8)
          ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) (I k!)
         ) (I j!)
        )
       ) 0
     ))
     (=>
      %%global_location_label%%56
      (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
            (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
             digits!
            ) (I j!) (I k!)
        ))))
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
     ))
     (=>
      %%global_location_label%%57
      (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.?
            (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
             digits!
            ) (I j!) (I k!)
        ))))
       ) (curve25519_dalek!specs.field_specs_u64.p.? (I 0))
   ))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_step_zero_digit.
     points_affine! digits! j! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_step_zero_digit._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_step_zero_digit._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_step_zero_digit.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int Int) Bool
)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int) (k! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_step_zero_digit.
     points_affine! digits! j! k!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       points_affine!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) (I j!) (I (Add k! 1))
     ) (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       points_affine!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) (I j!) (I k!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_step_zero_digit.
     points_affine! digits! j! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_step_zero_digit._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_column_sum_step_zero_digit._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_naf_digit_positive_select_preconditions
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_positive_select_preconditions.
 (Int) Bool
)
(declare-const %%global_location_label%%58 Bool)
(declare-const %%global_location_label%%59 Bool)
(declare-const %%global_location_label%%60 Bool)
(assert
 (forall ((digit! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_positive_select_preconditions.
     digit!
    ) (and
     (=>
      %%global_location_label%%58
      (> digit! 0)
     )
     (=>
      %%global_location_label%%59
      (not (= (EucMod digit! 2) 0))
     )
     (=>
      %%global_location_label%%60
      (< digit! 16)
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_positive_select_preconditions.
     digit!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_positive_select_preconditions._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_positive_select_preconditions._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_positive_select_preconditions.
 (Int) Bool
)
(assert
 (forall ((digit! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_positive_select_preconditions.
     digit!
    ) (and
     (= (uClip SZ (bitand (I (uClip SZ digit!)) (I 1))) 1)
     (< (uClip SZ digit!) 16)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_positive_select_preconditions.
     digit!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_positive_select_preconditions._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_positive_select_preconditions._definition
)))

;; Function-Specs curve25519_dalek::window::NafLookupTable5::select
(declare-fun req%curve25519_dalek!window.impl&%15.select. (curve25519_dalek!window.NafLookupTable5.
  Int
 ) Bool
)
(declare-const %%global_location_label%%61 Bool)
(declare-const %%global_location_label%%62 Bool)
(declare-const %%global_location_label%%63 Bool)
(declare-const %%global_location_label%%64 Bool)
(assert
 (forall ((self! curve25519_dalek!window.NafLookupTable5.) (x! Int)) (!
   (= (req%curve25519_dalek!window.impl&%15.select. self! x!) (and
     (=>
      %%global_location_label%%61
      (= (uClip SZ (bitand (I x!) (I 1))) 1)
     )
     (=>
      %%global_location_label%%62
      (< x! 16)
     )
     (=>
      %%global_location_label%%63
      (curve25519_dalek!specs.window_specs.naf_lookup_table5_projective_limbs_bounded.?
       (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
          (Poly%curve25519_dalek!window.NafLookupTable5. self!)
     )))))
     (=>
      %%global_location_label%%64
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
             $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              $ (CONST_INT 8)
             ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
                (Poly%curve25519_dalek!window.NafLookupTable5. self!)
             )))
            ) j$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            $ (CONST_INT 8)
           ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
              (Poly%curve25519_dalek!window.NafLookupTable5. self!)
           )))
          ) j$
        ))
        :qid user_curve25519_dalek__window__NafLookupTable5__select_80
        :skolemid skolem_user_curve25519_dalek__window__NafLookupTable5__select_80
   )))))
   :pattern ((req%curve25519_dalek!window.impl&%15.select. self! x!))
   :qid internal_req__curve25519_dalek!window.impl&__15.select._definition
   :skolemid skolem_internal_req__curve25519_dalek!window.impl&__15.select._definition
)))
(declare-fun ens%curve25519_dalek!window.impl&%15.select. (curve25519_dalek!window.NafLookupTable5.
  Int curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
 ) Bool
)
(assert
 (forall ((self! curve25519_dalek!window.NafLookupTable5.) (x! Int) (result! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.))
  (!
   (= (ens%curve25519_dalek!window.impl&%15.select. self! x! result!) (and
     (has_type (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       result!
      ) TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
     )
     (= result! (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
        (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          $ (CONST_INT 8)
         ) (Poly%array%. (curve25519_dalek!window.NafLookupTable5./NafLookupTable5/0 (%Poly%curve25519_dalek!window.NafLookupTable5.
            (Poly%curve25519_dalek!window.NafLookupTable5. self!)
         )))
        ) (I (EucDiv x! 2))
     )))
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_plus_X
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Y_minus_X
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/Z
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
       (curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint./ProjectiveNielsPoint/T2d
        (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          result!
       )))
      ) (I 54)
     )
     (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
       result!
   ))))
   :pattern ((ens%curve25519_dalek!window.impl&%15.select. self! x! result!))
   :qid internal_ens__curve25519_dalek!window.impl&__15.select._definition
   :skolemid skolem_internal_ens__curve25519_dalek!window.impl&__15.select._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_naf_select_is_signed_scalar_mul_projective
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_select_is_signed_scalar_mul_projective.
 (%%Function%% Int curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  tuple%2. Bool
 ) Bool
)
(declare-const %%global_location_label%%65 Bool)
(declare-const %%global_location_label%%66 Bool)
(declare-const %%global_location_label%%67 Bool)
(declare-const %%global_location_label%%68 Bool)
(declare-const %%global_location_label%%69 Bool)
(declare-const %%global_location_label%%70 Bool)
(assert
 (forall ((table! %%Function%%) (digit! Int) (result! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   (basepoint! tuple%2.) (is_add! Bool)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_select_is_signed_scalar_mul_projective.
     table! digit! result! basepoint! is_add!
    ) (and
     (=>
      %%global_location_label%%65
      (not (= digit! 0))
     )
     (=>
      %%global_location_label%%66
      (let
       ((tmp%%$ digit!))
       (and
        (< (Sub 0 16) tmp%%$)
        (< tmp%%$ 16)
     )))
     (=>
      %%global_location_label%%67
      (not (= (EucMod digit! 2) 0))
     )
     (=>
      %%global_location_label%%68
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
            (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
               $ (CONST_INT 8)
              ) (Poly%array%. table!)
             ) j$
            )
           ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. basepoint!)
            (I (nClip (Add (Mul 2 (%I j$)) 1)))
        ))))
        :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            $ (CONST_INT 8)
           ) (Poly%array%. table!)
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_naf_select_is_signed_scalar_mul_projective_81
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_naf_select_is_signed_scalar_mul_projective_81
     )))
     (=>
      %%global_location_label%%69
      (=>
       is_add!
       (and
        (> digit! 0)
        (= result! (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
           (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. table!)
           ) (I (EucDiv digit! 2))
     ))))))
     (=>
      %%global_location_label%%70
      (=>
       (not is_add!)
       (and
        (< digit! 0)
        (= result! (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? (vstd!seq.Seq.index.?
           $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
            $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             $ (CONST_INT 8)
            ) (Poly%array%. table!)
           ) (I (EucDiv (Sub 0 digit!) 2))
   ))))))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_select_is_signed_scalar_mul_projective.
     table! digit! result! basepoint! is_add!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_select_is_signed_scalar_mul_projective._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_select_is_signed_scalar_mul_projective._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_select_is_signed_scalar_mul_projective.
 (%%Function%% Int curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  tuple%2. Bool
 ) Bool
)
(assert
 (forall ((table! %%Function%%) (digit! Int) (result! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   (basepoint! tuple%2.) (is_add! Bool)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_select_is_signed_scalar_mul_projective.
     table! digit! result! basepoint! is_add!
    ) (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. result!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
       basepoint!
      ) (I digit!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_select_is_signed_scalar_mul_projective.
     table! digit! result! basepoint! is_add!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_select_is_signed_scalar_mul_projective._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_select_is_signed_scalar_mul_projective._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_naf_digit_negative_select_preconditions
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_negative_select_preconditions.
 (Int) Bool
)
(declare-const %%global_location_label%%71 Bool)
(declare-const %%global_location_label%%72 Bool)
(declare-const %%global_location_label%%73 Bool)
(assert
 (forall ((digit! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_negative_select_preconditions.
     digit!
    ) (and
     (=>
      %%global_location_label%%71
      (< digit! 0)
     )
     (=>
      %%global_location_label%%72
      (not (= (EucMod digit! 2) 0))
     )
     (=>
      %%global_location_label%%73
      (> digit! (Sub 0 16))
   )))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_negative_select_preconditions.
     digit!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_negative_select_preconditions._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_negative_select_preconditions._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_negative_select_preconditions.
 (Int) Bool
)
(assert
 (forall ((digit! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_negative_select_preconditions.
     digit!
    ) (and
     (= (uClip SZ (bitand (I (uClip SZ (Sub 0 digit!))) (I 1))) 1)
     (< (uClip SZ (Sub 0 digit!)) 16)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_negative_select_preconditions.
     digit!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_negative_select_preconditions._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_naf_digit_negative_select_preconditions._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::curve_equation_lemmas::lemma_neg_of_signed_scalar_mul
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_of_signed_scalar_mul.
 (tuple%2. Int) Bool
)
(declare-const %%global_location_label%%74 Bool)
(declare-const %%global_location_label%%75 Bool)
(assert
 (forall ((P! tuple%2.) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_of_signed_scalar_mul.
     P! n!
    ) (and
     (=>
      %%global_location_label%%74
      (< (%I (tuple%2./tuple%2/0 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
     )))
     (=>
      %%global_location_label%%75
      (< (%I (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. P!)))) (curve25519_dalek!specs.field_specs_u64.p.?
        (I 0)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_of_signed_scalar_mul.
     P! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_of_signed_scalar_mul._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_of_signed_scalar_mul._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_of_signed_scalar_mul.
 (tuple%2. Int) Bool
)
(assert
 (forall ((P! tuple%2.) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_of_signed_scalar_mul.
     P! n!
    ) (= (curve25519_dalek!specs.edwards_specs.edwards_neg.? (Poly%tuple%2. (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.?
        (Poly%tuple%2. P!) (I n!)
      ))
     ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
       P!
      ) (I (Sub 0 n!))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_of_signed_scalar_mul.
     P! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_of_signed_scalar_mul._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.curve_equation_lemmas.lemma_neg_of_signed_scalar_mul._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::curve_models::ProjectivePoint::as_extended
(declare-fun req%curve25519_dalek!backend.serial.curve_models.impl&%25.as_extended.
 (curve25519_dalek!backend.serial.curve_models.ProjectivePoint.) Bool
)
(declare-const %%global_location_label%%76 Bool)
(declare-const %%global_location_label%%77 Bool)
(declare-const %%global_location_label%%78 Bool)
(declare-const %%global_location_label%%79 Bool)
(assert
 (forall ((self! curve25519_dalek!backend.serial.curve_models.ProjectivePoint.)) (!
   (= (req%curve25519_dalek!backend.serial.curve_models.impl&%25.as_extended. self!)
    (and
     (=>
      %%global_location_label%%76
      (curve25519_dalek!specs.edwards_specs.is_valid_projective_point.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
        self!
     )))
     (=>
      %%global_location_label%%77
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/X (
          %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
           self!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%78
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Y (
          %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
           self!
        )))
       ) (I 54)
     ))
     (=>
      %%global_location_label%%79
      (curve25519_dalek!specs.field_specs.fe51_limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
        (curve25519_dalek!backend.serial.curve_models.ProjectivePoint./ProjectivePoint/Z (
          %Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint. (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
           self!
        )))
       ) (I 54)
   ))))
   :pattern ((req%curve25519_dalek!backend.serial.curve_models.impl&%25.as_extended. self!))
   :qid internal_req__curve25519_dalek!backend.serial.curve_models.impl&__25.as_extended._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.curve_models.impl&__25.as_extended._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.curve_models.impl&%25.as_extended.
 (curve25519_dalek!backend.serial.curve_models.ProjectivePoint. curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(assert
 (forall ((self! curve25519_dalek!backend.serial.curve_models.ProjectivePoint.) (result!
    curve25519_dalek!edwards.EdwardsPoint.
   )
  ) (!
   (= (ens%curve25519_dalek!backend.serial.curve_models.impl&%25.as_extended. self! result!)
    (and
     (has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. result!) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (curve25519_dalek!specs.edwards_specs.is_valid_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (curve25519_dalek!specs.edwards_specs.edwards_point_limbs_bounded.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_nat.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        result!
       )
      ) (curve25519_dalek!specs.edwards_specs.projective_to_extended.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
        self!
     )))
     (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        result!
       )
      ) (curve25519_dalek!specs.edwards_specs.projective_point_as_affine_edwards.? (Poly%curve25519_dalek!backend.serial.curve_models.ProjectivePoint.
        self!
   )))))
   :pattern ((ens%curve25519_dalek!backend.serial.curve_models.impl&%25.as_extended. self!
     result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__25.as_extended._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.curve_models.impl&__25.as_extended._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_straus_vt_correct
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_correct.
 (vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
  vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
 ) Bool
)
(declare-const %%global_location_label%%80 Bool)
(declare-const %%global_location_label%%81 Bool)
(declare-const %%global_location_label%%82 Bool)
(declare-const %%global_location_label%%83 Bool)
(declare-const %%global_location_label%%84 Bool)
(assert
 (forall ((scalars! vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.) (points_ep! vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)
   (points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (nafs! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_correct.
     scalars! points_ep! points_affine! nafs!
    ) (and
     (=>
      %%global_location_label%%80
      (= (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
         scalars!
        )
       ) (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
         points_ep!
     ))))
     (=>
      %%global_location_label%%81
      (= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         points_affine!
        )
       ) (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
         scalars!
     ))))
     (=>
      %%global_location_label%%82
      (= (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
         nafs!
        )
       ) (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
         scalars!
     ))))
     (=>
      %%global_location_label%%83
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
               points_affine!
          )))))
          (= (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
              points_affine!
             ) k$
            )
           ) (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
              points_ep!
             ) k$
        )))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           points_affine!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_straus_vt_correct_82
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_straus_vt_correct_82
     )))
     (=>
      %%global_location_label%%84
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
               nafs!
          )))))
          (and
           (and
            (= (vstd!seq.Seq.len.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT
                 8
                )
               ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. nafs!) k$
              )
             ) 256
            )
            (curve25519_dalek!specs.scalar_specs.is_valid_naf.? (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq.
               $ (SINT 8)
              ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. nafs!) k$
             ) (I 5)
           ))
           (= (curve25519_dalek!specs.scalar_specs.reconstruct.? (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq.
               $ (SINT 8)
              ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. nafs!) k$
             )
            ) (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!scalar.Scalar.
              (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. scalars!) k$
        ))))))
        :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
           nafs!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_straus_vt_correct_83
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_straus_vt_correct_83
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_correct.
     scalars! points_ep! points_affine! nafs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_correct._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_correct._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_correct.
 (vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
  vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
 ) Bool
)
(assert
 (forall ((scalars! vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.) (points_ep! vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)
   (points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (nafs! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_correct.
     scalars! points_ep! points_affine! nafs!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_vt_partial.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       points_affine!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. nafs!) (I 0)
     ) (curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
       scalars!
      ) (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. points_ep!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_correct.
     scalars! points_ep! points_affine! nafs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_correct._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_vt_correct._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::scalar_mul::straus::Straus::optional_multiscalar_mul_verus
(declare-fun req%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.optional_multiscalar_mul_verus.
 (Dcr Type Dcr Type Dcr Type Poly Poly) Bool
)
(declare-const %%global_location_label%%85 Bool)
(declare-const %%global_location_label%%86 Bool)
(assert
 (forall ((S&. Dcr) (S& Type) (I&. Dcr) (I& Type) (J&. Dcr) (J& Type) (scalars! Poly)
   (points! Poly)
  ) (!
   (= (req%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.optional_multiscalar_mul_verus.
     S&. S& I&. I& J&. J& scalars! points!
    ) (and
     (=>
      %%global_location_label%%85
      (= (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
         (curve25519_dalek!specs.iterator_specs.spec_scalars_from_iter.? S&. S& I&. I& scalars!)
        )
       ) (vstd!seq.Seq.len.? $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
        (Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>. (
          curve25519_dalek!specs.iterator_specs.spec_optional_points_from_iter.? J&. J& points!
     )))))
     (=>
      %%global_location_label%%86
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (and
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ (vstd!seq.Seq.len.? $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
               (Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>. (
                 curve25519_dalek!specs.iterator_specs.spec_optional_points_from_iter.? J&. J& points!
           ))))))
           (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!seq.Seq.index.? $ (TYPE%core!option.Option.
               $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
              ) (Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
               (curve25519_dalek!specs.iterator_specs.spec_optional_points_from_iter.? J&. J& points!)
              ) i$
          ))))
          (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (core!option.Option./Some/0
            $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (%Poly%core!option.Option. (vstd!seq.Seq.index.?
              $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.) (Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>.
               (curve25519_dalek!specs.iterator_specs.spec_optional_points_from_iter.? J&. J& points!)
              ) i$
        ))))))
        :pattern ((vstd!seq.Seq.index.? $ (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
          (Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>. (
            curve25519_dalek!specs.iterator_specs.spec_optional_points_from_iter.? J&. J& points!
           )
          ) i$
        ))
        :qid user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__optional_multiscalar_mul_verus_84
        :skolemid skolem_user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__optional_multiscalar_mul_verus_84
   )))))
   :pattern ((req%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.optional_multiscalar_mul_verus.
     S&. S& I&. I& J&. J& scalars! points!
   ))
   :qid internal_req__curve25519_dalek!backend.serial.scalar_mul.straus.impl&__2.optional_multiscalar_mul_verus._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.scalar_mul.straus.impl&__2.optional_multiscalar_mul_verus._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.optional_multiscalar_mul_verus.
 (Dcr Type Dcr Type Dcr Type Poly Poly core!option.Option.) Bool
)
(assert
 (forall ((S&. Dcr) (S& Type) (I&. Dcr) (I& Type) (J&. Dcr) (J& Type) (scalars! Poly)
   (points! Poly) (result! core!option.Option.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.optional_multiscalar_mul_verus.
     S&. S& I&. I& J&. J& scalars! points! result!
    ) (and
     (has_type (Poly%core!option.Option. result!) (TYPE%core!option.Option. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.))
     (= (is-core!option.Option./Some result!) (curve25519_dalek!specs.iterator_specs.all_points_some.?
       (Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>. (
         curve25519_dalek!specs.iterator_specs.spec_optional_points_from_iter.? J&. J& points!
     ))))
     (=>
      (is-core!option.Option./Some result!)
      (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (core!option.Option./Some/0
        $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (%Poly%core!option.Option. (Poly%core!option.Option.
          result!
     )))))
     (=>
      (is-core!option.Option./Some result!)
      (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (core!option.Option./Some/0
         $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (%Poly%core!option.Option. (Poly%core!option.Option.
           result!
        )))
       ) (curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
         (curve25519_dalek!specs.iterator_specs.spec_scalars_from_iter.? S&. S& I&. I& scalars!)
        ) (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. (curve25519_dalek!specs.iterator_specs.unwrap_points.?
          (Poly%vstd!seq.Seq<core!option.Option<curve25519_dalek!edwards.EdwardsPoint.>.>. (
            curve25519_dalek!specs.iterator_specs.spec_optional_points_from_iter.? J&. J& points!
   )))))))))
   :pattern ((ens%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.optional_multiscalar_mul_verus.
     S&. S& I&. I& J&. J& scalars! points! result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.scalar_mul.straus.impl&__2.optional_multiscalar_mul_verus._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.scalar_mul.straus.impl&__2.optional_multiscalar_mul_verus._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_straus_ct_base
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_base.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>.) Bool
)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.))
  (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_base.
     points_affine! digits!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_partial.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       points_affine!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) (I 64)
     ) (curve25519_dalek!specs.edwards_specs.edwards_identity.? (I 0))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_base.
     points_affine! digits!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_base._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_base._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_select_is_signed_scalar_mul_projective
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_select_is_signed_scalar_mul_projective.
 (%%Function%% Int curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  tuple%2.
 ) Bool
)
(declare-const %%global_location_label%%87 Bool)
(declare-const %%global_location_label%%88 Bool)
(declare-const %%global_location_label%%89 Bool)
(declare-const %%global_location_label%%90 Bool)
(declare-const %%global_location_label%%91 Bool)
(assert
 (forall ((table! %%Function%%) (x! Int) (result! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   (basepoint! tuple%2.)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_select_is_signed_scalar_mul_projective.
     table! x! result! basepoint!
    ) (and
     (=>
      %%global_location_label%%87
      (let
       ((tmp%%$ x!))
       (and
        (<= (Sub 0 8) tmp%%$)
        (<= tmp%%$ 8)
     )))
     (=>
      %%global_location_label%%88
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
            (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
             (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
               $ (CONST_INT 8)
              ) (Poly%array%. table!)
             ) j$
            )
           ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. basepoint!)
            (I (nClip (Add (%I j$) 1)))
        ))))
        :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            $ (CONST_INT 8)
           ) (Poly%array%. table!)
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_select_is_signed_scalar_mul_projective_107
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_select_is_signed_scalar_mul_projective_107
     )))
     (=>
      %%global_location_label%%89
      (=>
       (> x! 0)
       (= result! (%Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
          (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            $ (CONST_INT 8)
           ) (Poly%array%. table!)
          ) (I (Sub x! 1))
     )))))
     (=>
      %%global_location_label%%90
      (=>
       (= x! 0)
       (= result! (curve25519_dalek!specs.edwards_specs.identity_projective_niels.? (I 0)))
     ))
     (=>
      %%global_location_label%%91
      (=>
       (< x! 0)
       (= result! (curve25519_dalek!specs.edwards_specs.negate_projective_niels.? (vstd!seq.Seq.index.?
          $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
           $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
            $ (CONST_INT 8)
           ) (Poly%array%. table!)
          ) (I (Sub (Sub 0 x!) 1))
   )))))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_select_is_signed_scalar_mul_projective.
     table! x! result! basepoint!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_select_is_signed_scalar_mul_projective._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_select_is_signed_scalar_mul_projective._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_select_is_signed_scalar_mul_projective.
 (%%Function%% Int curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
  tuple%2.
 ) Bool
)
(assert
 (forall ((table! %%Function%%) (x! Int) (result! curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
   (basepoint! tuple%2.)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_select_is_signed_scalar_mul_projective.
     table! x! result! basepoint!
    ) (= (curve25519_dalek!specs.edwards_specs.projective_niels_point_as_affine_edwards.?
      (Poly%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. result!)
     ) (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul_signed.? (Poly%tuple%2.
       basepoint!
      ) (I x!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_select_is_signed_scalar_mul_projective.
     table! x! result! basepoint!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_select_is_signed_scalar_mul_projective._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_select_is_signed_scalar_mul_projective._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_straus_ct_step
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_step.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int) Bool
)
(declare-const %%global_location_label%%92 Bool)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_step.
     points_affine! digits! j!
    ) (=>
     %%global_location_label%%92
     (let
      ((tmp%%$ j!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ 64)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_step.
     points_affine! digits! j!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_step._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_step._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_step.
 (vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>. Int) Bool
)
(assert
 (forall ((points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
   (j! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_step.
     points_affine! digits! j!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_partial.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       points_affine!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) (I j!)
     ) (let
      ((prev$ (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_partial.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
          points_affine!
         ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) (I (Add j! 1))
      )))
      (let
       ((scaled$ (curve25519_dalek!specs.edwards_specs.edwards_scalar_mul.? (Poly%tuple%2. prev$)
          (I 16)
       )))
       (let
        ((col$ (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_column_sum.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
            points_affine!
           ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) (I j!) (I (vstd!seq.Seq.len.? (DST
              $
             ) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>. points_affine!)
        )))))
        (curve25519_dalek!specs.edwards_specs.edwards_add.? (tuple%2./tuple%2/0 (%Poly%tuple%2.
           (Poly%tuple%2. scaled$)
          )
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. scaled$))) (tuple%2./tuple%2/0
          (%Poly%tuple%2. (Poly%tuple%2. col$))
         ) (tuple%2./tuple%2/1 (%Poly%tuple%2. (Poly%tuple%2. col$)))
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_step.
     points_affine! digits! j!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_step._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_step._definition
)))

;; Function-Specs curve25519_dalek::lemmas::edwards_lemmas::straus_lemmas::lemma_straus_ct_correct
(declare-fun req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_correct.
 (vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
  vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
 ) Bool
)
(declare-const %%global_location_label%%93 Bool)
(declare-const %%global_location_label%%94 Bool)
(declare-const %%global_location_label%%95 Bool)
(declare-const %%global_location_label%%96 Bool)
(declare-const %%global_location_label%%97 Bool)
(assert
 (forall ((scalars! vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.) (points_ep! vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)
   (points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
  ) (!
   (= (req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_correct.
     scalars! points_ep! points_affine! digits!
    ) (and
     (=>
      %%global_location_label%%93
      (= (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
         scalars!
        )
       ) (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
         points_ep!
     ))))
     (=>
      %%global_location_label%%94
      (= (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
         points_affine!
        )
       ) (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
         scalars!
     ))))
     (=>
      %%global_location_label%%95
      (= (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
         digits!
        )
       ) (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
         scalars!
     ))))
     (=>
      %%global_location_label%%96
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (vstd!seq.Seq.len.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
               points_affine!
          )))))
          (= (%Poly%tuple%2. (vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
              points_affine!
             ) k$
            )
           ) (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
              points_ep!
             ) k$
        )))))
        :pattern ((vstd!seq.Seq.index.? (DST $) (TYPE%tuple%2. $ NAT $ NAT) (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
           points_affine!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_straus_ct_correct_108
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_straus_ct_correct_108
     )))
     (=>
      %%global_location_label%%97
      (forall ((k$ Poly)) (!
        (=>
         (has_type k$ INT)
         (=>
          (let
           ((tmp%%$ (%I k$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (vstd!seq.Seq.len.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
               digits!
          )))))
          (and
           (and
            (= (vstd!seq.Seq.len.? $ (SINT 8) (vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT
                 8
                )
               ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) k$
              )
             ) 64
            )
            (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.radix_16_all_bounded_seq.? (
              vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
               digits!
              ) k$
           )))
           (= (curve25519_dalek!specs.scalar_specs.reconstruct_radix_16.? (vstd!seq.Seq.index.?
              $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!)
              k$
             )
            ) (curve25519_dalek!specs.scalar_specs.scalar_as_nat.? (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!scalar.Scalar.
              (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. scalars!) k$
        ))))))
        :pattern ((vstd!seq.Seq.index.? $ (TYPE%vstd!seq.Seq. $ (SINT 8)) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
           digits!
          ) k$
        ))
        :qid user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_straus_ct_correct_109
        :skolemid skolem_user_curve25519_dalek__lemmas__edwards_lemmas__straus_lemmas__lemma_straus_ct_correct_109
   )))))
   :pattern ((req%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_correct.
     scalars! points_ep! points_affine! digits!
   ))
   :qid internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_correct._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_correct._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_correct.
 (vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>. vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
  vstd!seq.Seq<tuple%2<nat./nat.>.>. vstd!seq.Seq<vstd!seq.Seq<i8.>.>.
 ) Bool
)
(assert
 (forall ((scalars! vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.) (points_ep! vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)
   (points_affine! vstd!seq.Seq<tuple%2<nat./nat.>.>.) (digits! vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
  ) (!
   (= (ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_correct.
     scalars! points_ep! points_affine! digits!
    ) (= (curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.straus_ct_partial.? (Poly%vstd!seq.Seq<tuple%2<nat./nat.>.>.
       points_affine!
      ) (Poly%vstd!seq.Seq<vstd!seq.Seq<i8.>.>. digits!) (I 0)
     ) (curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
       scalars!
      ) (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. points_ep!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_correct.
     scalars! points_ep! points_affine! digits!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_correct._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.edwards_lemmas.straus_lemmas.lemma_straus_ct_correct._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::scalar_mul::straus::Straus::multiscalar_mul_verus
(declare-fun req%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.multiscalar_mul_verus.
 (Dcr Type Dcr Type Dcr Type Dcr Type Poly Poly) Bool
)
(declare-const %%global_location_label%%98 Bool)
(declare-const %%global_location_label%%99 Bool)
(assert
 (forall ((S&. Dcr) (S& Type) (P&. Dcr) (P& Type) (I&. Dcr) (I& Type) (J&. Dcr) (J& Type)
   (scalars! Poly) (points! Poly)
  ) (!
   (= (req%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.multiscalar_mul_verus.
     S&. S& P&. P& I&. I& J&. J& scalars! points!
    ) (and
     (=>
      %%global_location_label%%98
      (= (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!scalar.Scalar. (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
         (curve25519_dalek!specs.iterator_specs.spec_scalars_from_iter.? S&. S& I&. I& scalars!)
        )
       ) (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
         (curve25519_dalek!specs.iterator_specs.spec_points_from_iter.? P&. P& J&. J& points!)
     ))))
     (=>
      %%global_location_label%%99
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
               (curve25519_dalek!specs.iterator_specs.spec_points_from_iter.? P&. P& J&. J& points!)
          )))))
          (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (vstd!seq.Seq.index.?
            $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
             (curve25519_dalek!specs.iterator_specs.spec_points_from_iter.? P&. P& J&. J& points!)
            ) i$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.
           (curve25519_dalek!specs.iterator_specs.spec_points_from_iter.? P&. P& J&. J& points!)
          ) i$
        ))
        :qid user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_110
        :skolemid skolem_user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_110
   )))))
   :pattern ((req%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.multiscalar_mul_verus.
     S&. S& P&. P& I&. I& J&. J& scalars! points!
   ))
   :qid internal_req__curve25519_dalek!backend.serial.scalar_mul.straus.impl&__2.multiscalar_mul_verus._definition
   :skolemid skolem_internal_req__curve25519_dalek!backend.serial.scalar_mul.straus.impl&__2.multiscalar_mul_verus._definition
)))
(declare-fun ens%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.multiscalar_mul_verus.
 (Dcr Type Dcr Type Dcr Type Dcr Type Poly Poly curve25519_dalek!edwards.EdwardsPoint.)
 Bool
)
(assert
 (forall ((S&. Dcr) (S& Type) (P&. Dcr) (P& Type) (I&. Dcr) (I& Type) (J&. Dcr) (J& Type)
   (scalars! Poly) (points! Poly) (result! curve25519_dalek!edwards.EdwardsPoint.)
  ) (!
   (= (ens%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.multiscalar_mul_verus.
     S&. S& P&. P& I&. I& J&. J& scalars! points! result!
    ) (and
     (has_type (Poly%curve25519_dalek!edwards.EdwardsPoint. result!) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
     (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
       result!
     ))
     (= (curve25519_dalek!specs.edwards_specs.edwards_point_as_affine.? (Poly%curve25519_dalek!edwards.EdwardsPoint.
        result!
       )
      ) (curve25519_dalek!specs.edwards_specs.sum_of_scalar_muls.? (Poly%vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.
        (curve25519_dalek!specs.iterator_specs.spec_scalars_from_iter.? S&. S& I&. I& scalars!)
       ) (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. (curve25519_dalek!specs.iterator_specs.spec_points_from_iter.?
         P&. P& J&. J& points!
   ))))))
   :pattern ((ens%curve25519_dalek!backend.serial.scalar_mul.straus.impl&%2.multiscalar_mul_verus.
     S&. S& P&. P& I&. I& J&. J& scalars! points! result!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.scalar_mul.straus.impl&__2.multiscalar_mul_verus._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.scalar_mul.straus.impl&__2.multiscalar_mul_verus._definition
)))

;; Function-Def curve25519_dalek::backend::serial::scalar_mul::straus::Straus::multiscalar_mul_verus
;; curve25519-dalek/src/backend/serial/scalar_mul/straus.rs:859:9: 859:37 (#3438)
(get-info :all-statistics)
(push)
 (declare-const S&. Dcr)
 (declare-const S& Type)
 (declare-const P&. Dcr)
 (declare-const P& Type)
 (declare-const I&. Dcr)
 (declare-const I& Type)
 (declare-const J&. Dcr)
 (declare-const J& Type)
 (declare-const result! curve25519_dalek!edwards.EdwardsPoint.)
 (declare-const scalars! Poly)
 (declare-const points! Poly)
 (declare-const verus_tmp_spec_scalars@ vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.)
 (declare-const verus_tmp_spec_points@ vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)
 (declare-const tmp%1 Poly)
 (declare-const tmp%2 Int)
 (declare-const tmp%3 Int)
 (declare-const tmp%4 Poly)
 (declare-const tmp%5 Poly)
 (declare-const decrease%init0%0 Int)
 (declare-const tmp%6 Int)
 (declare-const tmp%7 Int)
 (declare-const tmp%8 Poly)
 (declare-const tmp%9 %%Function%%)
 (declare-const decrease%init1%0 Int)
 (declare-const verus_tmp_n@ Int)
 (declare-const verus_tmp_pts_affine@ vstd!seq.Seq<tuple%2<nat./nat.>.>.)
 (declare-const verus_tmp_digits_seqs@ vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
 (declare-const tmp%10 Poly)
 (declare-const tmp%11 Bool)
 (declare-const tmp%12 Bool)
 (declare-const tmp%13 Bool)
 (declare-const tmp%14 Int)
 (declare-const tmp%15 Int)
 (declare-const tmp%16 Int)
 (declare-const tmp%17 Int)
 (declare-const tmp%18 Int)
 (declare-const tmp%19 Int)
 (declare-const verus_tmp_scaled_affine@ tuple%2.)
 (declare-const tmp%20 Bool)
 (declare-const tmp%21 Poly)
 (declare-const tmp%22 Poly)
 (declare-const tmp%23 Bool)
 (declare-const tmp%24 Bool)
 (declare-const tmp%25 Poly)
 (declare-const tmp%26 curve25519_dalek!window.LookupTable.)
 (declare-const tmp%27 Bool)
 (declare-const tmp%28 %%Function%%)
 (declare-const base_k@ tuple%2.)
 (declare-const digit_kj@ Int)
 (declare-const tmp%29 Poly)
 (declare-const tmp%30 Int)
 (declare-const tmp%31 Int)
 (declare-const tmp%32 Int)
 (declare-const tmp%33 Int)
 (declare-const tmp%34 Int)
 (declare-const tmp%35 Int)
 (declare-const tmp%36 Bool)
 (declare-const tmp%37 Bool)
 (declare-const col_k@ tuple%2.)
 (declare-const base_k$1@ tuple%2.)
 (declare-const digit_kj$1@ Int)
 (declare-const term_k@ tuple%2.)
 (declare-const s_i@ %%Function%%)
 (declare-const lookup_table_i@ curve25519_dalek!window.LookupTable.)
 (declare-const R_i@ curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
 (declare-const decrease%init3%0 Int)
 (declare-const tmp%38 Bool)
 (declare-const k@0 Int)
 (declare-const min_len@ Int)
 (declare-const verus_tmp$5@0 tuple%2.)
 (declare-const scaled_affine@0 tuple%2.)
 (declare-const decrease%init2%0 Int)
 (declare-const tmp%39 Bool)
 (declare-const tmp%40 Bool)
 (declare-const tmp%41 Bool)
 (declare-const tmp%42 Bool)
 (declare-const tmp%43 Bool)
 (declare-const k$1@ Poly)
 (declare-const k$2@ Poly)
 (declare-const tmp%44 Bool)
 (declare-const tmp%45 Bool)
 (declare-const tmp%46 Bool)
 (declare-const verus_tmp@0 vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.)
 (declare-const spec_scalars@0 vstd!seq.Seq<curve25519_dalek!scalar.Scalar.>.)
 (declare-const verus_tmp$1@0 vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)
 (declare-const spec_points@0 vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>.)
 (declare-const scalars_vec@ alloc!vec.Vec<curve25519_dalek!scalar.Scalar./allocator_global%.>.)
 (declare-const points_vec@ alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.)
 (declare-const lookup_tables@0 alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.)
 (declare-const idx@0 Int)
 (declare-const scalar_digits@0 Poly)
 (declare-const verus_tmp$2@0 Int)
 (declare-const n@0 Int)
 (declare-const verus_tmp$3@0 vstd!seq.Seq<tuple%2<nat./nat.>.>.)
 (declare-const pts_affine@0 vstd!seq.Seq<tuple%2<nat./nat.>.>.)
 (declare-const verus_tmp$4@0 vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
 (declare-const digits_seqs@0 vstd!seq.Seq<vstd!seq.Seq<i8.>.>.)
 (declare-const Q@0 curve25519_dalek!edwards.EdwardsPoint.)
 (declare-const j@0 Int)
 (assert
  fuel_defaults
 )
 (assert
  (sized S&.)
 )
 (assert
  (sized P&.)
 )
 (assert
  (sized I&.)
 )
 (assert
  (sized J&.)
 )
 (assert
  (tr_bound%core!borrow.Borrow. S&. S& $ TYPE%curve25519_dalek!scalar.Scalar.)
 )
 (assert
  (tr_bound%core!borrow.Borrow. P&. P& $ TYPE%curve25519_dalek!edwards.EdwardsPoint.)
 )
 (assert
  (tr_bound%core!iter.traits.iterator.Iterator. I&. I&)
 )
 (assert
  (and
   (= S&. (proj%%core!iter.traits.iterator.Iterator./Item I&. I&))
   (= S& (proj%core!iter.traits.iterator.Iterator./Item I&. I&))
 ))
 (assert
  (tr_bound%core!iter.traits.iterator.Iterator. J&. J&)
 )
 (assert
  (and
   (= P&. (proj%%core!iter.traits.iterator.Iterator./Item J&. J&))
   (= P& (proj%core!iter.traits.iterator.Iterator./Item J&. J&))
 ))
 (assert
  (has_type scalars! I&)
 )
 (assert
  (has_type points! J&)
 )
 (assert
  (has_type tmp%1 (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable. $
     TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
    ) $ ALLOCATOR_GLOBAL
 )))
 (assert
  (uInv SZ idx@0)
 )
 (assert
  (uInv SZ tmp%2)
 )
 (assert
  (uInv SZ tmp%3)
 )
 (declare-const lookup_tables@1 alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.)
 (declare-const idx@1 Int)
 ;; precondition not satisfied
 (declare-const %%location_label%%0 Bool)
 ;; possible arithmetic underflow/overflow
 (declare-const %%location_label%%1 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%2 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%3 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%4 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%5 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%6 Bool)
 ;; decreases not satisfied at end of loop
 (declare-const %%location_label%%7 Bool)
 (assert
  (not (=>
    (let
     ((tmp%%$ idx@0))
     (and
      (<= 0 tmp%%$)
      (<= tmp%%$ (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.?
         $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL)
         (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. points_vec@)
    )))))
    (=>
     (= (vstd!seq.Seq.len.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
       (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
          $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
         ) $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
         lookup_tables@0
       ))
      ) idx@0
     )
     (=>
      (ext_eq false (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.) (
        vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
         $ ALLOCATOR_GLOBAL
        ) (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
         points_vec@
        )
       ) (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. spec_points@0)
      )
      (=>
       (forall ((k$ Poly)) (!
         (=>
          (has_type k$ INT)
          (=>
           (let
            ((tmp%%$ (%I k$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.?
                $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL)
                (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. points_vec@)
           )))))
           (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (vstd!seq.Seq.index.?
             $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
               $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL
              ) (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
               points_vec@
              )
             ) k$
         ))))
         :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.?
            $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL)
            (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. points_vec@)
           ) k$
         ))
         :qid user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_111
         :skolemid skolem_user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_111
       ))
       (=>
        (forall ((k$ Poly)) (!
          (=>
           (has_type k$ INT)
           (=>
            (let
             ((tmp%%$ (%I k$)))
             (and
              (<= 0 tmp%%$)
              (< tmp%%$ idx@0)
            ))
            (and
             (and
              (curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.? $ (CONST_INT
                8
               ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                  (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                   (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
                      $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                     ) $ ALLOCATOR_GLOBAL
                    ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                     lookup_tables@0
                    )
                   ) k$
                )))
               ) (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.?
                 $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL)
                 (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. points_vec@)
                ) k$
               ) (I 8)
              )
              (curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.? $ (CONST_INT
                8
               ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                  (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                   (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
                      $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                     ) $ ALLOCATOR_GLOBAL
                    ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                     lookup_tables@0
                    )
                   ) k$
             ))))))
             (forall ((j$ Poly)) (!
               (=>
                (has_type j$ INT)
                (=>
                 (let
                  ((tmp%%$ (%I j$)))
                  (and
                   (<= 0 tmp%%$)
                   (< tmp%%$ 8)
                 ))
                 (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
                   $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
                    $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                     $ (CONST_INT 8)
                    ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                       (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                        (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
                           $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                          ) $ ALLOCATOR_GLOBAL
                         ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                          lookup_tables@0
                         )
                        ) k$
                    ))))
                   ) j$
               ))))
               :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                 (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                   $ (CONST_INT 8)
                  ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                     (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                      (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
                         $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                        ) $ ALLOCATOR_GLOBAL
                       ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                        lookup_tables@0
                       )
                      ) k$
                  ))))
                 ) j$
               ))
               :qid user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_112
               :skolemid skolem_user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_112
          )))))
          :pattern ((vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
            (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
               $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
              ) $ ALLOCATOR_GLOBAL
             ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
              lookup_tables@0
             )
            ) k$
          ))
          :qid user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_113
          :skolemid skolem_user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_113
        ))
        (=>
         (= decrease%init0%0 (Sub (vstd!std_specs.vec.spec_vec_len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
            $ ALLOCATOR_GLOBAL (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
             points_vec@
            )
           ) idx@0
         ))
         (=>
          (= tmp%3 idx@0)
          (=>
           (ens%alloc!vec.impl&%1.len. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL
            (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. points_vec@)
            tmp%2
           )
           (=>
            (< tmp%3 tmp%2)
            (and
             (=>
              %%location_label%%0
              (req%vstd!std_specs.vec.vec_index. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $
               ALLOCATOR_GLOBAL (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
                points_vec@
               ) idx@0
             ))
             (=>
              (ens%vstd!std_specs.vec.vec_index. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $
               ALLOCATOR_GLOBAL (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
                points_vec@
               ) idx@0 tmp%4
              )
              (=>
               (ens%curve25519_dalek!window.impl&%12.from. tmp%4 tmp%5)
               (=>
                (closure_ens (FNDEF%core!convert.From.from. $ (TYPE%curve25519_dalek!window.LookupTable.
                   $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                  ) (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.
                 ) (DST (REF $)) (TYPE%tuple%1. (REF $) TYPE%curve25519_dalek!edwards.EdwardsPoint.)
                 (F fndef_singleton) (Poly%tuple%1. (tuple%1./tuple%1 tmp%4)) tmp%5
                )
                (=>
                 (ens%alloc!vec.impl&%1.push. $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                  $ ALLOCATOR_GLOBAL (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                   lookup_tables@0
                  ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                   lookup_tables@1
                  ) tmp%5
                 )
                 (and
                  (=>
                   %%location_label%%1
                   (uInv SZ (Add idx@0 1))
                  )
                  (=>
                   (uInv SZ (Add idx@0 1))
                   (=>
                    (= idx@1 (uClip SZ (Add idx@0 1)))
                    (and
                     (=>
                      %%location_label%%2
                      (let
                       ((tmp%%$ idx@1))
                       (and
                        (<= 0 tmp%%$)
                        (<= tmp%%$ (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.?
                           $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL)
                           (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. points_vec@)
                     ))))))
                     (and
                      (=>
                       %%location_label%%3
                       (= (vstd!seq.Seq.len.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                         (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
                            $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                           ) $ ALLOCATOR_GLOBAL
                          ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                           lookup_tables@1
                         ))
                        ) idx@1
                      ))
                      (and
                       (=>
                        %%location_label%%4
                        (ext_eq false (TYPE%vstd!seq.Seq. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.) (
                          vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
                           $ ALLOCATOR_GLOBAL
                          ) (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
                           points_vec@
                          )
                         ) (Poly%vstd!seq.Seq<curve25519_dalek!edwards.EdwardsPoint.>. spec_points@0)
                       ))
                       (and
                        (=>
                         %%location_label%%5
                         (forall ((k$ Poly)) (!
                           (=>
                            (has_type k$ INT)
                            (=>
                             (let
                              ((tmp%%$ (%I k$)))
                              (and
                               (<= 0 tmp%%$)
                               (< tmp%%$ (vstd!seq.Seq.len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.?
                                  $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL)
                                  (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. points_vec@)
                             )))))
                             (curve25519_dalek!specs.edwards_specs.is_well_formed_edwards_point.? (vstd!seq.Seq.index.?
                               $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec.
                                 $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL
                                ) (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
                                 points_vec@
                                )
                               ) k$
                           ))))
                           :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.?
                              $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL)
                              (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. points_vec@)
                             ) k$
                           ))
                           :qid user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_111
                           :skolemid skolem_user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_111
                        )))
                        (and
                         (=>
                          %%location_label%%6
                          (forall ((k$ Poly)) (!
                            (=>
                             (has_type k$ INT)
                             (=>
                              (let
                               ((tmp%%$ (%I k$)))
                               (and
                                (<= 0 tmp%%$)
                                (< tmp%%$ idx@1)
                              ))
                              (and
                               (and
                                (curve25519_dalek!specs.window_specs.is_valid_lookup_table_projective.? $ (CONST_INT
                                  8
                                 ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                                    (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                                     (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
                                        $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                                       ) $ ALLOCATOR_GLOBAL
                                      ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                                       lookup_tables@1
                                      )
                                     ) k$
                                  )))
                                 ) (vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint. (vstd!view.View.view.?
                                   $ (TYPE%alloc!vec.Vec. $ TYPE%curve25519_dalek!edwards.EdwardsPoint. $ ALLOCATOR_GLOBAL)
                                   (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>. points_vec@)
                                  ) k$
                                 ) (I 8)
                                )
                                (curve25519_dalek!specs.window_specs.lookup_table_projective_limbs_bounded.? $ (CONST_INT
                                  8
                                 ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                                    (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                                     (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
                                        $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                                       ) $ ALLOCATOR_GLOBAL
                                      ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                                       lookup_tables@1
                                      )
                                     ) k$
                               ))))))
                               (forall ((j$ Poly)) (!
                                 (=>
                                  (has_type j$ INT)
                                  (=>
                                   (let
                                    ((tmp%%$ (%I j$)))
                                    (and
                                     (<= 0 tmp%%$)
                                     (< tmp%%$ 8)
                                   ))
                                   (curve25519_dalek!specs.edwards_specs.is_valid_projective_niels_point.? (vstd!seq.Seq.index.?
                                     $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint. (vstd!view.View.view.?
                                      $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                                       $ (CONST_INT 8)
                                      ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                                         (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                                          (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
                                             $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                                            ) $ ALLOCATOR_GLOBAL
                                           ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                                            lookup_tables@1
                                           )
                                          ) k$
                                      ))))
                                     ) j$
                                 ))))
                                 :pattern ((vstd!seq.Seq.index.? $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                                   (vstd!view.View.view.? $ (ARRAY $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                                     $ (CONST_INT 8)
                                    ) (Poly%array%. (curve25519_dalek!window.LookupTable./LookupTable/0 (%Poly%curve25519_dalek!window.LookupTable.
                                       (vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                                        (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
                                           $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                                          ) $ ALLOCATOR_GLOBAL
                                         ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                                          lookup_tables@1
                                         )
                                        ) k$
                                    ))))
                                   ) j$
                                 ))
                                 :qid user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_112
                                 :skolemid skolem_user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_112
                            )))))
                            :pattern ((vstd!seq.Seq.index.? $ (TYPE%curve25519_dalek!window.LookupTable. $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.)
                              (vstd!view.View.view.? $ (TYPE%alloc!vec.Vec. $ (TYPE%curve25519_dalek!window.LookupTable.
                                 $ TYPE%curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.
                                ) $ ALLOCATOR_GLOBAL
                               ) (Poly%alloc!vec.Vec<curve25519_dalek!window.LookupTable<curve25519_dalek!backend.serial.curve_models.ProjectiveNielsPoint.>./allocator_global%.>.
                                lookup_tables@1
                               )
                              ) k$
                            ))
                            :qid user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_113
                            :skolemid skolem_user_curve25519_dalek__backend__serial__scalar_mul__straus__Straus__multiscalar_mul_verus_113
                         )))
                         (=>
                          %%location_label%%7
                          (check_decrease_int (Sub (vstd!std_specs.vec.spec_vec_len.? $ TYPE%curve25519_dalek!edwards.EdwardsPoint.
                             $ ALLOCATOR_GLOBAL (Poly%alloc!vec.Vec<curve25519_dalek!edwards.EdwardsPoint./allocator_global%.>.
                              points_vec@
                             )
                            ) idx@1
                           ) decrease%init0%0 false
 ))))))))))))))))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
