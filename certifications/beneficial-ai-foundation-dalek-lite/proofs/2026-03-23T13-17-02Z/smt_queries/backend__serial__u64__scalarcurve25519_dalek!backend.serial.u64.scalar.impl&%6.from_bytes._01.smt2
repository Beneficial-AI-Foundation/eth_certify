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

;; MODULE 'module backend::serial::u64::scalar'
;; curve25519-dalek/src/backend/serial/u64/scalar.rs:186:13: 205:14 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.
 FuelId
)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_basics_3. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_adds. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases. FuelId)
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
(declare-const fuel%vstd!std_specs.core.iter_into_iter_spec. FuelId)
(declare-const fuel%vstd!std_specs.option.impl&%0.arrow_0. FuelId)
(declare-const fuel%vstd!std_specs.option.is_some. FuelId)
(declare-const fuel%vstd!std_specs.option.is_none. FuelId)
(declare-const fuel%vstd!std_specs.option.spec_unwrap. FuelId)
(declare-const fuel%vstd!std_specs.option.spec_unwrap_or. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%3.ghost_iter. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.exec_invariant. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_invariant. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_ensures. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_decrease. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_peek_next. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%4.ghost_advance. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%5.view. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u8. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%7.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%7.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%7.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%7.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u16. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u32. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u64. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%10.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%10.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%10.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%10.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_u128. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_usize. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_is_lt. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_forward_checked. FuelId)
(declare-const fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int. FuelId)
(declare-const fuel%vstd!std_specs.range.axiom_spec_range_next_i32. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires. FuelId)
(declare-const fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures. FuelId)
(declare-const fuel%vstd!array.array_view. FuelId)
(declare-const fuel%vstd!array.impl&%0.view. FuelId)
(declare-const fuel%vstd!array.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!array.lemma_array_index. FuelId)
(declare-const fuel%vstd!array.array_len_matches_n. FuelId)
(declare-const fuel%vstd!array.axiom_spec_array_as_slice. FuelId)
(declare-const fuel%vstd!array.axiom_spec_array_fill_for_copy_type. FuelId)
(declare-const fuel%vstd!array.axiom_array_ext_equal. FuelId)
(declare-const fuel%vstd!array.axiom_array_has_resolved. FuelId)
(declare-const fuel%vstd!pervasive.strictly_cloned. FuelId)
(declare-const fuel%vstd!pervasive.cloned. FuelId)
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
(declare-const fuel%vstd!seq.axiom_seq_update_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_update_same. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_update_different. FuelId)
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
(declare-const fuel%vstd!string.axiom_str_literal_len. FuelId)
(declare-const fuel%vstd!string.axiom_str_literal_get_char. FuelId)
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
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%vstd!view.impl&%40.view. FuelId)
(declare-const fuel%vstd!view.impl&%42.view. FuelId)
(declare-const fuel%vstd!view.impl&%44.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.scalar.impl&%6.ZERO. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.L. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.LFACTOR. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.R. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.RR. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.scalar_byte_lemmas.scalar_to_bytes_lemmas.bytes_match_limbs_packing_52.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.spec_load8_at. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.bytes_seq_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.words_as_nat_u64. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.word64_from_bytes. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.word64_from_bytes_partial. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.slice128_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limbs52_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.group_order. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.group_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.montgomery_radix. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.is_canonical_scalar52. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.spec_mul_internal. FuelId)
(declare-const fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_congruent.
 FuelId
)
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
 (distinct fuel%vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.
  fuel%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. fuel%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish.
  fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. fuel%vstd!arithmetic.mul.lemma_mul_basics_3.
  fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add.
  fuel%vstd!arithmetic.power2.lemma_pow2_pos. fuel%vstd!arithmetic.power2.lemma_pow2_adds.
  fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases. fuel%vstd!std_specs.convert.impl&%6.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%6.from_spec. fuel%vstd!std_specs.convert.impl&%7.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%7.from_spec. fuel%vstd!std_specs.convert.impl&%8.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%8.from_spec. fuel%vstd!std_specs.convert.impl&%9.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%9.from_spec. fuel%vstd!std_specs.convert.impl&%10.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%10.from_spec. fuel%vstd!std_specs.convert.impl&%11.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%11.from_spec. fuel%vstd!std_specs.convert.impl&%12.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%12.from_spec. fuel%vstd!std_specs.convert.impl&%13.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%13.from_spec. fuel%vstd!std_specs.convert.impl&%14.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%14.from_spec. fuel%vstd!std_specs.convert.impl&%15.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%15.from_spec. fuel%vstd!std_specs.convert.impl&%16.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%16.from_spec. fuel%vstd!std_specs.convert.impl&%17.obeys_from_spec.
  fuel%vstd!std_specs.convert.impl&%17.from_spec. fuel%vstd!std_specs.core.iter_into_iter_spec.
  fuel%vstd!std_specs.option.impl&%0.arrow_0. fuel%vstd!std_specs.option.is_some. fuel%vstd!std_specs.option.is_none.
  fuel%vstd!std_specs.option.spec_unwrap. fuel%vstd!std_specs.option.spec_unwrap_or.
  fuel%vstd!std_specs.range.impl&%3.ghost_iter. fuel%vstd!std_specs.range.impl&%4.exec_invariant.
  fuel%vstd!std_specs.range.impl&%4.ghost_invariant. fuel%vstd!std_specs.range.impl&%4.ghost_ensures.
  fuel%vstd!std_specs.range.impl&%4.ghost_decrease. fuel%vstd!std_specs.range.impl&%4.ghost_peek_next.
  fuel%vstd!std_specs.range.impl&%4.ghost_advance. fuel%vstd!std_specs.range.impl&%5.view.
  fuel%vstd!std_specs.range.impl&%6.spec_is_lt. fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int.
  fuel%vstd!std_specs.range.impl&%6.spec_forward_checked. fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int.
  fuel%vstd!std_specs.range.axiom_spec_range_next_u8. fuel%vstd!std_specs.range.impl&%7.spec_is_lt.
  fuel%vstd!std_specs.range.impl&%7.spec_steps_between_int. fuel%vstd!std_specs.range.impl&%7.spec_forward_checked.
  fuel%vstd!std_specs.range.impl&%7.spec_forward_checked_int. fuel%vstd!std_specs.range.axiom_spec_range_next_u16.
  fuel%vstd!std_specs.range.impl&%8.spec_is_lt. fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int.
  fuel%vstd!std_specs.range.impl&%8.spec_forward_checked. fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int.
  fuel%vstd!std_specs.range.axiom_spec_range_next_u32. fuel%vstd!std_specs.range.impl&%9.spec_is_lt.
  fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int. fuel%vstd!std_specs.range.impl&%9.spec_forward_checked.
  fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int. fuel%vstd!std_specs.range.axiom_spec_range_next_u64.
  fuel%vstd!std_specs.range.impl&%10.spec_is_lt. fuel%vstd!std_specs.range.impl&%10.spec_steps_between_int.
  fuel%vstd!std_specs.range.impl&%10.spec_forward_checked. fuel%vstd!std_specs.range.impl&%10.spec_forward_checked_int.
  fuel%vstd!std_specs.range.axiom_spec_range_next_u128. fuel%vstd!std_specs.range.impl&%11.spec_is_lt.
  fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int. fuel%vstd!std_specs.range.impl&%11.spec_forward_checked.
  fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int. fuel%vstd!std_specs.range.axiom_spec_range_next_usize.
  fuel%vstd!std_specs.range.impl&%14.spec_is_lt. fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int.
  fuel%vstd!std_specs.range.impl&%14.spec_forward_checked. fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int.
  fuel%vstd!std_specs.range.axiom_spec_range_next_i32. fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires.
  fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures. fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires.
  fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures. fuel%vstd!array.array_view.
  fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index. fuel%vstd!array.lemma_array_index.
  fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_spec_array_as_slice. fuel%vstd!array.axiom_spec_array_fill_for_copy_type.
  fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!pervasive.strictly_cloned. fuel%vstd!pervasive.cloned. fuel%vstd!raw_ptr.impl&%3.view.
  fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized. fuel%vstd!seq.impl&%0.spec_index.
  fuel%vstd!seq.impl&%0.skip. fuel%vstd!seq.axiom_seq_index_decreases. fuel%vstd!seq.axiom_seq_subrange_decreases.
  fuel%vstd!seq.axiom_seq_empty. fuel%vstd!seq.axiom_seq_new_len. fuel%vstd!seq.axiom_seq_new_index.
  fuel%vstd!seq.axiom_seq_push_len. fuel%vstd!seq.axiom_seq_push_index_same. fuel%vstd!seq.axiom_seq_push_index_different.
  fuel%vstd!seq.axiom_seq_update_len. fuel%vstd!seq.axiom_seq_update_same. fuel%vstd!seq.axiom_seq_update_different.
  fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!seq.axiom_seq_subrange_len.
  fuel%vstd!seq.axiom_seq_subrange_index. fuel%vstd!seq.lemma_seq_two_subranges_index.
  fuel%vstd!seq_lib.impl&%0.map. fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len.
  fuel%vstd!slice.axiom_slice_ext_equal. fuel%vstd!slice.axiom_slice_has_resolved.
  fuel%vstd!string.axiom_str_literal_len. fuel%vstd!string.axiom_str_literal_get_char.
  fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view. fuel%vstd!view.impl&%4.view.
  fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%10.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%18.view.
  fuel%vstd!view.impl&%20.view. fuel%vstd!view.impl&%22.view. fuel%vstd!view.impl&%24.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%32.view. fuel%vstd!view.impl&%40.view.
  fuel%vstd!view.impl&%42.view. fuel%vstd!view.impl&%44.view. fuel%curve25519_dalek!backend.serial.u64.scalar.impl&%6.ZERO.
  fuel%curve25519_dalek!backend.serial.u64.constants.L. fuel%curve25519_dalek!backend.serial.u64.constants.LFACTOR.
  fuel%curve25519_dalek!backend.serial.u64.constants.R. fuel%curve25519_dalek!backend.serial.u64.constants.RR.
  fuel%curve25519_dalek!lemmas.scalar_byte_lemmas.scalar_to_bytes_lemmas.bytes_match_limbs_packing_52.
  fuel%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.
  fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.
  fuel%curve25519_dalek!specs.core_specs.spec_load8_at. fuel%curve25519_dalek!specs.core_specs.bytes_seq_as_nat.
  fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. fuel%curve25519_dalek!specs.core_specs.words_as_nat_gen.
  fuel%curve25519_dalek!specs.core_specs.words_as_nat_u64. fuel%curve25519_dalek!specs.core_specs.word64_from_bytes.
  fuel%curve25519_dalek!specs.core_specs.word64_from_bytes_partial. fuel%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.
  fuel%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52. fuel%curve25519_dalek!specs.scalar52_specs.slice128_as_nat.
  fuel%curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat. fuel%curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.
  fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_nat. fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.
  fuel%curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux. fuel%curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.
  fuel%curve25519_dalek!specs.scalar52_specs.group_order. fuel%curve25519_dalek!specs.scalar52_specs.group_canonical.
  fuel%curve25519_dalek!specs.scalar52_specs.montgomery_radix. fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded.
  fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub. fuel%curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.
  fuel%curve25519_dalek!specs.scalar52_specs.is_canonical_scalar52. fuel%curve25519_dalek!specs.scalar52_specs.spec_mul_internal.
  fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.
  fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.
  fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_congruent. fuel%vstd!array.group_array_axioms.
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
   (fuel_bool_default fuel%vstd!array.axiom_spec_array_fill_for_copy_type.)
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
   (fuel_bool_default fuel%vstd!seq.axiom_seq_update_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_update_same.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_update_different.)
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
  (fuel_bool_default fuel%vstd!string.group_string_axioms.)
  (and
   (fuel_bool_default fuel%vstd!string.axiom_str_literal_len.)
   (fuel_bool_default fuel%vstd!string.axiom_str_literal_get_char.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!std_specs.range.group_range_axioms.)
  (and
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u8.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u16.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u32.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u64.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_u128.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_usize.)
   (fuel_bool_default fuel%vstd!std_specs.range.axiom_spec_range_next_i32.)
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
(declare-fun tr_bound%vstd!pervasive.ForLoopGhostIterator. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!slice.SliceAdditionalSpecFns. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!slice.index.SliceIndex. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!view.View. (Dcr Type) Bool)
(declare-fun tr_bound%core!clone.Clone. (Dcr Type) Bool)
(declare-fun tr_bound%core!cmp.PartialEq. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!cmp.PartialOrd. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!convert.From. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.convert.FromSpec. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.index.Index. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!ops.index.IndexMut. (Dcr Type Dcr Type) Bool)
(declare-fun tr_bound%core!alloc.Allocator. (Dcr Type) Bool)
(declare-fun tr_bound%core!iter.traits.iterator.Iterator. (Dcr Type) Bool)
(declare-fun tr_bound%core!iter.range.Step. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.core.TrustedSpecSealed. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. (Dcr Type Dcr Type)
 Bool
)
(declare-fun tr_bound%vstd!std_specs.option.OptionAdditionalFns. (Dcr Type Dcr Type)
 Bool
)
(declare-fun tr_bound%vstd!std_specs.range.StepSpec. (Dcr Type) Bool)

;; Associated-Type-Decls
(declare-fun proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIterator./ExecIter (Dcr Type) Type)
(declare-fun proj%%vstd!pervasive.ForLoopGhostIterator./Item (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIterator./Item (Dcr Type) Type)
(declare-fun proj%%vstd!pervasive.ForLoopGhostIterator./Decrease (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIterator./Decrease (Dcr Type) Type)
(declare-fun proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter (Dcr Type) Dcr)
(declare-fun proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter (Dcr Type) Type)
(declare-fun proj%%core!slice.index.SliceIndex./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!slice.index.SliceIndex./Output (Dcr Type Dcr Type) Type)
(declare-fun proj%%vstd!view.View./V (Dcr Type) Dcr)
(declare-fun proj%vstd!view.View./V (Dcr Type) Type)
(declare-fun proj%%core!ops.index.Index./Output (Dcr Type Dcr Type) Dcr)
(declare-fun proj%core!ops.index.Index./Output (Dcr Type Dcr Type) Type)
(declare-fun proj%%core!iter.traits.iterator.Iterator./Item (Dcr Type) Dcr)
(declare-fun proj%core!iter.traits.iterator.Iterator./Item (Dcr Type) Type)

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
(declare-sort subtle!Choice. 0)
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort vstd!seq.Seq<nat.>. 0)
(declare-sort vstd!seq.Seq<u8.>. 0)
(declare-sort vstd!seq.Seq<u64.>. 0)
(declare-sort vstd!seq.Seq<u128.>. 0)
(declare-sort vstd!seq.Seq<char.>. 0)
(declare-sort slice%<u8.>. 0)
(declare-sort slice%<u64.>. 0)
(declare-sort slice%<u128.>. 0)
(declare-sort strslice%. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((core!option.Option. 0) (core!ops.range.Range. 0) (vstd!std_specs.range.RangeGhostIterator.
   0
  ) (vstd!raw_ptr.PtrData. 0) (curve25519_dalek!backend.serial.u64.scalar.Scalar52.
   0
  ) (tuple%0. 0) (tuple%1. 0) (tuple%2. 0)
 ) (((core!option.Option./None) (core!option.Option./Some (core!option.Option./Some/?0
     Poly
   ))
  ) ((core!ops.range.Range./Range (core!ops.range.Range./Range/?start Poly) (core!ops.range.Range./Range/?end
     Poly
   ))
  ) ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?start
     Poly
    ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?cur Poly) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?end
     Poly
   ))
  ) ((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52 (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/?limbs
     %%Function%%
   ))
  ) ((tuple%0./tuple%0)) ((tuple%1./tuple%1 (tuple%1./tuple%1/?0 Poly))) ((tuple%2./tuple%2
    (tuple%2./tuple%2/?0 Poly) (tuple%2./tuple%2/?1 Poly)
))))
(declare-fun core!option.Option./Some/0 (Dcr Type core!option.Option.) Poly)
(declare-fun core!ops.range.Range./Range/start (core!ops.range.Range.) Poly)
(declare-fun core!ops.range.Range./Range/end (core!ops.range.Range.) Poly)
(declare-fun vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (
  curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) %%Function%%
)
(declare-fun tuple%1./tuple%1/0 (tuple%1.) Poly)
(declare-fun tuple%2./tuple%2/0 (tuple%2.) Poly)
(declare-fun tuple%2./tuple%2/1 (tuple%2.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%fun%2. (Dcr Type Dcr Type Dcr Type) Type)
(declare-fun TYPE%core!option.Option. (Dcr Type) Type)
(declare-fun TYPE%core!ops.range.Range. (Dcr Type) Type)
(declare-fun TYPE%vstd!std_specs.range.RangeGhostIterator. (Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52. Type)
(declare-const TYPE%subtle!Choice. Type)
(declare-fun TYPE%tuple%1. (Dcr Type) Type)
(declare-fun TYPE%tuple%2. (Dcr Type Dcr Type) Type)
(declare-fun FNDEF%core!clone.Clone.clone. (Dcr Type) Type)
(declare-fun FNDEF%core!convert.From.from. (Dcr Type Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%fun%2. (%%Function%%) Poly)
(declare-fun %Poly%fun%2. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%subtle!Choice. (subtle!Choice.) Poly)
(declare-fun %Poly%subtle!Choice. (Poly) subtle!Choice.)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<nat.>. (vstd!seq.Seq<nat.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<nat.>. (Poly) vstd!seq.Seq<nat.>.)
(declare-fun Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq<u8.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u8.>. (Poly) vstd!seq.Seq<u8.>.)
(declare-fun Poly%vstd!seq.Seq<u64.>. (vstd!seq.Seq<u64.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u64.>. (Poly) vstd!seq.Seq<u64.>.)
(declare-fun Poly%vstd!seq.Seq<u128.>. (vstd!seq.Seq<u128.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u128.>. (Poly) vstd!seq.Seq<u128.>.)
(declare-fun Poly%vstd!seq.Seq<char.>. (vstd!seq.Seq<char.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<char.>. (Poly) vstd!seq.Seq<char.>.)
(declare-fun Poly%slice%<u8.>. (slice%<u8.>.) Poly)
(declare-fun %Poly%slice%<u8.>. (Poly) slice%<u8.>.)
(declare-fun Poly%slice%<u64.>. (slice%<u64.>.) Poly)
(declare-fun %Poly%slice%<u64.>. (Poly) slice%<u64.>.)
(declare-fun Poly%slice%<u128.>. (slice%<u128.>.) Poly)
(declare-fun %Poly%slice%<u128.>. (Poly) slice%<u128.>.)
(declare-fun Poly%strslice%. (strslice%.) Poly)
(declare-fun %Poly%strslice%. (Poly) strslice%.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%core!option.Option. (core!option.Option.) Poly)
(declare-fun %Poly%core!option.Option. (Poly) core!option.Option.)
(declare-fun Poly%core!ops.range.Range. (core!ops.range.Range.) Poly)
(declare-fun %Poly%core!ops.range.Range. (Poly) core!ops.range.Range.)
(declare-fun Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator.)
 Poly
)
(declare-fun %Poly%vstd!std_specs.range.RangeGhostIterator. (Poly) vstd!std_specs.range.RangeGhostIterator.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly) curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
(declare-fun Poly%tuple%1. (tuple%1.) Poly)
(declare-fun %Poly%tuple%1. (Poly) tuple%1.)
(declare-fun Poly%tuple%2. (tuple%2.) Poly)
(declare-fun %Poly%tuple%2. (Poly) tuple%2.)
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
 (forall ((x subtle!Choice.)) (!
   (= x (%Poly%subtle!Choice. (Poly%subtle!Choice. x)))
   :pattern ((Poly%subtle!Choice. x))
   :qid internal_subtle__Choice_box_axiom_definition
   :skolemid skolem_internal_subtle__Choice_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%subtle!Choice.)
    (= x (Poly%subtle!Choice. (%Poly%subtle!Choice. x)))
   )
   :pattern ((has_type x TYPE%subtle!Choice.))
   :qid internal_subtle__Choice_unbox_axiom_definition
   :skolemid skolem_internal_subtle__Choice_unbox_axiom_definition
)))
(assert
 (forall ((x subtle!Choice.)) (!
   (has_type (Poly%subtle!Choice. x) TYPE%subtle!Choice.)
   :pattern ((has_type (Poly%subtle!Choice. x) TYPE%subtle!Choice.))
   :qid internal_subtle__Choice_has_type_always_definition
   :skolemid skolem_internal_subtle__Choice_has_type_always_definition
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
 (forall ((x vstd!seq.Seq<u128.>.)) (!
   (= x (%Poly%vstd!seq.Seq<u128.>. (Poly%vstd!seq.Seq<u128.>. x)))
   :pattern ((Poly%vstd!seq.Seq<u128.>. x))
   :qid internal_vstd__seq__Seq<u128.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u128.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ (UINT 128)))
    (= x (Poly%vstd!seq.Seq<u128.>. (%Poly%vstd!seq.Seq<u128.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ (UINT 128))))
   :qid internal_vstd__seq__Seq<u128.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<u128.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<u128.>.)) (!
   (has_type (Poly%vstd!seq.Seq<u128.>. x) (TYPE%vstd!seq.Seq. $ (UINT 128)))
   :pattern ((has_type (Poly%vstd!seq.Seq<u128.>. x) (TYPE%vstd!seq.Seq. $ (UINT 128))))
   :qid internal_vstd__seq__Seq<u128.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<u128.>_has_type_always_definition
)))
(assert
 (forall ((x vstd!seq.Seq<char.>.)) (!
   (= x (%Poly%vstd!seq.Seq<char.>. (Poly%vstd!seq.Seq<char.>. x)))
   :pattern ((Poly%vstd!seq.Seq<char.>. x))
   :qid internal_vstd__seq__Seq<char.>_box_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<char.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!seq.Seq. $ CHAR))
    (= x (Poly%vstd!seq.Seq<char.>. (%Poly%vstd!seq.Seq<char.>. x)))
   )
   :pattern ((has_type x (TYPE%vstd!seq.Seq. $ CHAR)))
   :qid internal_vstd__seq__Seq<char.>_unbox_axiom_definition
   :skolemid skolem_internal_vstd__seq__Seq<char.>_unbox_axiom_definition
)))
(assert
 (forall ((x vstd!seq.Seq<char.>.)) (!
   (has_type (Poly%vstd!seq.Seq<char.>. x) (TYPE%vstd!seq.Seq. $ CHAR))
   :pattern ((has_type (Poly%vstd!seq.Seq<char.>. x) (TYPE%vstd!seq.Seq. $ CHAR)))
   :qid internal_vstd__seq__Seq<char.>_has_type_always_definition
   :skolemid skolem_internal_vstd__seq__Seq<char.>_has_type_always_definition
)))
(assert
 (forall ((x slice%<u8.>.)) (!
   (= x (%Poly%slice%<u8.>. (Poly%slice%<u8.>. x)))
   :pattern ((Poly%slice%<u8.>. x))
   :qid internal_crate__slice__<u8.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<u8.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ (UINT 8)))
    (= x (Poly%slice%<u8.>. (%Poly%slice%<u8.>. x)))
   )
   :pattern ((has_type x (SLICE $ (UINT 8))))
   :qid internal_crate__slice__<u8.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<u8.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<u8.>.)) (!
   (has_type (Poly%slice%<u8.>. x) (SLICE $ (UINT 8)))
   :pattern ((has_type (Poly%slice%<u8.>. x) (SLICE $ (UINT 8))))
   :qid internal_crate__slice__<u8.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<u8.>_has_type_always_definition
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
 (forall ((x slice%<u128.>.)) (!
   (= x (%Poly%slice%<u128.>. (Poly%slice%<u128.>. x)))
   :pattern ((Poly%slice%<u128.>. x))
   :qid internal_crate__slice__<u128.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<u128.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ (UINT 128)))
    (= x (Poly%slice%<u128.>. (%Poly%slice%<u128.>. x)))
   )
   :pattern ((has_type x (SLICE $ (UINT 128))))
   :qid internal_crate__slice__<u128.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<u128.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<u128.>.)) (!
   (has_type (Poly%slice%<u128.>. x) (SLICE $ (UINT 128)))
   :pattern ((has_type (Poly%slice%<u128.>. x) (SLICE $ (UINT 128))))
   :qid internal_crate__slice__<u128.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<u128.>_has_type_always_definition
)))
(assert
 (forall ((x strslice%.)) (!
   (= x (%Poly%strslice%. (Poly%strslice%. x)))
   :pattern ((Poly%strslice%. x))
   :qid internal_crate__strslice___box_axiom_definition
   :skolemid skolem_internal_crate__strslice___box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x STRSLICE)
    (= x (Poly%strslice%. (%Poly%strslice%. x)))
   )
   :pattern ((has_type x STRSLICE))
   :qid internal_crate__strslice___unbox_axiom_definition
   :skolemid skolem_internal_crate__strslice___unbox_axiom_definition
)))
(assert
 (forall ((x strslice%.)) (!
   (has_type (Poly%strslice%. x) STRSLICE)
   :pattern ((has_type (Poly%strslice%. x) STRSLICE))
   :qid internal_crate__strslice___has_type_always_definition
   :skolemid skolem_internal_crate__strslice___has_type_always_definition
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
 (forall ((x core!ops.range.Range.)) (!
   (= x (%Poly%core!ops.range.Range. (Poly%core!ops.range.Range. x)))
   :pattern ((Poly%core!ops.range.Range. x))
   :qid internal_core__ops__range__Range_box_axiom_definition
   :skolemid skolem_internal_core__ops__range__Range_box_axiom_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!ops.range.Range. Idx&. Idx&))
    (= x (Poly%core!ops.range.Range. (%Poly%core!ops.range.Range. x)))
   )
   :pattern ((has_type x (TYPE%core!ops.range.Range. Idx&. Idx&)))
   :qid internal_core__ops__range__Range_unbox_axiom_definition
   :skolemid skolem_internal_core__ops__range__Range_unbox_axiom_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (_start! Poly) (_end! Poly)) (!
   (=>
    (and
     (has_type _start! Idx&)
     (has_type _end! Idx&)
    )
    (has_type (Poly%core!ops.range.Range. (core!ops.range.Range./Range _start! _end!))
     (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :pattern ((has_type (Poly%core!ops.range.Range. (core!ops.range.Range./Range _start!
       _end!
      )
     ) (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core!ops.range.Range./Range_constructor_definition
   :skolemid skolem_internal_core!ops.range.Range./Range_constructor_definition
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (= (core!ops.range.Range./Range/start x) (core!ops.range.Range./Range/?start x))
   :pattern ((core!ops.range.Range./Range/start x))
   :qid internal_core!ops.range.Range./Range/start_accessor_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/start_accessor_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!ops.range.Range. Idx&. Idx&))
    (has_type (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. x)) Idx&)
   )
   :pattern ((core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. x)) (has_type
     x (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core!ops.range.Range./Range/start_invariant_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/start_invariant_definition
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (= (core!ops.range.Range./Range/end x) (core!ops.range.Range./Range/?end x))
   :pattern ((core!ops.range.Range./Range/end x))
   :qid internal_core!ops.range.Range./Range/end_accessor_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/end_accessor_definition
)))
(assert
 (forall ((Idx&. Dcr) (Idx& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!ops.range.Range. Idx&. Idx&))
    (has_type (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. x)) Idx&)
   )
   :pattern ((core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. x)) (has_type
     x (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core!ops.range.Range./Range/end_invariant_definition
   :skolemid skolem_internal_core!ops.range.Range./Range/end_invariant_definition
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (=>
    (is-core!ops.range.Range./Range x)
    (height_lt (height (core!ops.range.Range./Range/start x)) (height (Poly%core!ops.range.Range.
       x
   ))))
   :pattern ((height (core!ops.range.Range./Range/start x)))
   :qid prelude_datatype_height_core!ops.range.Range./Range/start
   :skolemid skolem_prelude_datatype_height_core!ops.range.Range./Range/start
)))
(assert
 (forall ((x core!ops.range.Range.)) (!
   (=>
    (is-core!ops.range.Range./Range x)
    (height_lt (height (core!ops.range.Range./Range/end x)) (height (Poly%core!ops.range.Range.
       x
   ))))
   :pattern ((height (core!ops.range.Range./Range/end x)))
   :qid prelude_datatype_height_core!ops.range.Range./Range/end
   :skolemid skolem_prelude_datatype_height_core!ops.range.Range./Range/end
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= x (%Poly%vstd!std_specs.range.RangeGhostIterator. (Poly%vstd!std_specs.range.RangeGhostIterator.
      x
   )))
   :pattern ((Poly%vstd!std_specs.range.RangeGhostIterator. x))
   :qid internal_vstd__std_specs__range__RangeGhostIterator_box_axiom_definition
   :skolemid skolem_internal_vstd__std_specs__range__RangeGhostIterator_box_axiom_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (= x (Poly%vstd!std_specs.range.RangeGhostIterator. (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
   ))))
   :pattern ((has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)))
   :qid internal_vstd__std_specs__range__RangeGhostIterator_unbox_axiom_definition
   :skolemid skolem_internal_vstd__std_specs__range__RangeGhostIterator_unbox_axiom_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (_start! Poly) (_cur! Poly) (_end! Poly)) (!
   (=>
    (and
     (has_type _start! A&)
     (has_type _cur! A&)
     (has_type _end! A&)
    )
    (has_type (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
       _start! _cur! _end!
      )
     ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
   ))
   :pattern ((has_type (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
       _start! _cur! _end!
      )
     ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
   ))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator_constructor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator_constructor_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start x) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?start
     x
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start x))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_accessor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_accessor_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (has_type (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
      )
     ) A&
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
      x
     )
    ) (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_invariant_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start_invariant_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur x) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?cur
     x
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur x))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_accessor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_accessor_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (has_type (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
      )
     ) A&
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
      x
     )
    ) (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_invariant_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur_invariant_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end x) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/?end
     x
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end x))
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_accessor_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_accessor_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (has_type (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
       x
      )
     ) A&
   ))
   :pattern ((vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
      x
     )
    ) (has_type x (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :qid internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_invariant_definition
   :skolemid skolem_internal_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end_invariant_definition
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (=>
    (is-vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator x)
    (height_lt (height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
       x
      )
     ) (height (Poly%vstd!std_specs.range.RangeGhostIterator. x))
   ))
   :pattern ((height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
      x
   )))
   :qid prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
   :skolemid skolem_prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (=>
    (is-vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator x)
    (height_lt (height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
       x
      )
     ) (height (Poly%vstd!std_specs.range.RangeGhostIterator. x))
   ))
   :pattern ((height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur x)))
   :qid prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
   :skolemid skolem_prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
)))
(assert
 (forall ((x vstd!std_specs.range.RangeGhostIterator.)) (!
   (=>
    (is-vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator x)
    (height_lt (height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end
       x
      )
     ) (height (Poly%vstd!std_specs.range.RangeGhostIterator. x))
   ))
   :pattern ((height (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end x)))
   :qid prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end
   :skolemid skolem_prelude_datatype_height_vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end
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
(declare-fun str%strslice_is_ascii (strslice%.) Bool)
(declare-fun str%strslice_len (strslice%.) Int)
(declare-fun str%strslice_get_char (strslice%. Int) Int)
(declare-fun str%new_strlit (Int) strslice%.)
(declare-fun str%from_strlit (strslice%.) Int)
(assert
 (forall ((x Int)) (!
   (= (str%from_strlit (str%new_strlit x)) x)
   :pattern ((str%new_strlit x))
   :qid prelude_strlit_injective
   :skolemid skolem_prelude_strlit_injective
)))

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
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!pervasive.ForLoopGhostIterator. Self%&. Self%&)
    (and
     (sized (proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter Self%&. Self%&))
     (sized (proj%%vstd!pervasive.ForLoopGhostIterator./Item Self%&. Self%&))
     (sized (proj%%vstd!pervasive.ForLoopGhostIterator./Decrease Self%&. Self%&))
   ))
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIterator. Self%&. Self%&))
   :qid internal_vstd__pervasive__ForLoopGhostIterator_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__pervasive__ForLoopGhostIterator_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. Self%&. Self%&)
    (sized (proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter Self%&. Self%&))
   )
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. Self%&. Self%&))
   :qid internal_vstd__pervasive__ForLoopGhostIteratorNew_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__pervasive__ForLoopGhostIteratorNew_trait_type_bounds_definition
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
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type)) (!
   true
   :pattern ((tr_bound%core!slice.index.SliceIndex. Self%&. Self%& T&. T&))
   :qid internal_core__slice__index__SliceIndex_trait_type_bounds_definition
   :skolemid skolem_internal_core__slice__index__SliceIndex_trait_type_bounds_definition
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
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type)) (!
   true
   :pattern ((tr_bound%core!ops.index.Index. Self%&. Self%& Idx&. Idx&))
   :qid internal_core__ops__index__Index_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__index__Index_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type)) (!
   (=>
    (tr_bound%core!ops.index.IndexMut. Self%&. Self%& Idx&. Idx&)
    (tr_bound%core!ops.index.Index. Self%&. Self%& Idx&. Idx&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. Self%&. Self%& Idx&. Idx&))
   :qid internal_core__ops__index__IndexMut_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__index__IndexMut_trait_type_bounds_definition
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
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!iter.range.Step. Self%&. Self%&)
    (and
     (sized Self%&.)
     (tr_bound%core!clone.Clone. Self%&. Self%&)
     (tr_bound%core!cmp.PartialOrd. Self%&. Self%& Self%&. Self%&)
   ))
   :pattern ((tr_bound%core!iter.range.Step. Self%&. Self%&))
   :qid internal_core__iter__range__Step_trait_type_bounds_definition
   :skolemid skolem_internal_core__iter__range__Step_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%vstd!std_specs.core.TrustedSpecSealed. Self%&. Self%&))
   :qid internal_vstd__std_specs__core__TrustedSpecSealed_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__core__TrustedSpecSealed_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. Self%&. Self%& Idx&. Idx&)
    (and
     (tr_bound%core!ops.index.IndexMut. Self%&. Self%& Idx&. Idx&)
     (tr_bound%vstd!std_specs.core.TrustedSpecSealed. Self%&. Self%&)
     (sized Idx&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. Self%&. Self%& Idx&. Idx&))
   :qid internal_vstd__std_specs__core__IndexSetTrustedSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__core__IndexSetTrustedSpec_trait_type_bounds_definition
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
   (=>
    (tr_bound%vstd!std_specs.range.StepSpec. Self%&. Self%&)
    (sized Self%&.)
   )
   :pattern ((tr_bound%vstd!std_specs.range.StepSpec. Self%&. Self%&))
   :qid internal_vstd__std_specs__range__StepSpec_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__range__StepSpec_trait_type_bounds_definition
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
 (= (proj%%vstd!view.View./V $slice STRSLICE) $)
)
(assert
 (= (proj%vstd!view.View./V $slice STRSLICE) (TYPE%vstd!seq.Seq. $ CHAR))
)
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
 (= (proj%%vstd!view.View./V $ (SINT 32)) $)
)
(assert
 (= (proj%vstd!view.View./V $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%vstd!view.View./V $ CHAR) $)
)
(assert
 (= (proj%vstd!view.View./V $ CHAR) CHAR)
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
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
     )
    ) $
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
     )
    ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIteratorNew./GhostIter_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) $
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) (TYPE%core!ops.range.Range. A&. A&)
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIterator./ExecIter $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIterator./ExecIter_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) A&.
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) A&
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIterator./Item $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIterator./Item_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) $
   )
   :pattern ((proj%%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
     )
    ) INT
   )
   :pattern ((proj%vstd!pervasive.ForLoopGhostIterator./Decrease $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj__vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!pervasive.ForLoopGhostIterator./Decrease_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    $
   )
   :pattern ((proj%%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____vstd!view.View./V_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
    (TYPE%vstd!seq.Seq. A&. A&)
   )
   :pattern ((proj%vstd!view.View./V $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&.
      A&
   )))
   :qid internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__vstd!view.View./V_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&) (proj%%core!ops.index.Index./Output
     $slice (SLICE T&. T&) I&. I&
   ))
   :pattern ((proj%%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (= (proj%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&) (proj%core!ops.index.Index./Output
     $slice (SLICE T&. T&) I&. I&
   ))
   :pattern ((proj%core!ops.index.Index./Output $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (= (proj%%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&) (proj%%core!slice.index.SliceIndex./Output
     I&. I& $slice (SLICE T&. T&)
   ))
   :pattern ((proj%%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&))
   :qid internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (= (proj%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&) (proj%core!slice.index.SliceIndex./Output
     I&. I& $slice (SLICE T&. T&)
   ))
   :pattern ((proj%core!ops.index.Index./Output $slice (SLICE T&. T&) I&. I&))
   :qid internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((I&. Dcr) (I& Type)) (!
   (= (proj%%core!ops.index.Index./Output $slice STRSLICE I&. I&) (proj%%core!slice.index.SliceIndex./Output
     I&. I& $slice STRSLICE
   ))
   :pattern ((proj%%core!ops.index.Index./Output $slice STRSLICE I&. I&))
   :qid internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!ops.index.Index./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((I&. Dcr) (I& Type)) (!
   (= (proj%core!ops.index.Index./Output $slice STRSLICE I&. I&) (proj%core!slice.index.SliceIndex./Output
     I&. I& $slice STRSLICE
   ))
   :pattern ((proj%core!ops.index.Index./Output $slice STRSLICE I&. I&))
   :qid internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!ops.index.Index./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range. A&.
      A&
     )
    ) A&.
   )
   :pattern ((proj%%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj____core!iter.traits.iterator.Iterator./Item_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!iter.traits.iterator.Iterator./Item_assoc_type_impl_true_definition
)))
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (= (proj%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range. A&.
      A&
     )
    ) A&
   )
   :pattern ((proj%core!iter.traits.iterator.Iterator./Item $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_proj__core!iter.traits.iterator.Iterator./Item_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!iter.traits.iterator.Iterator./Item_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)) T&.)
   :pattern ((proj%%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)))
   :qid internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)) T&)
   :pattern ((proj%core!slice.index.SliceIndex./Output $ USIZE $slice (SLICE T&. T&)))
   :qid internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
     $slice (SLICE T&. T&)
    ) $slice
   )
   :pattern ((proj%%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $
      USIZE
     ) $slice (SLICE T&. T&)
   ))
   :qid internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
   :skolemid skolem_internal_proj____core!slice.index.SliceIndex./Output_assoc_type_impl_true_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (= (proj%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
     $slice (SLICE T&. T&)
    ) (SLICE T&. T&)
   )
   :pattern ((proj%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $
      USIZE
     ) $slice (SLICE T&. T&)
   ))
   :qid internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
   :skolemid skolem_internal_proj__core!slice.index.SliceIndex./Output_assoc_type_impl_false_definition
)))
(assert
 (= (proj%%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
   $slice STRSLICE
  ) $slice
))
(assert
 (= (proj%core!slice.index.SliceIndex./Output $ (TYPE%core!ops.range.Range. $ USIZE)
   $slice STRSLICE
  ) STRSLICE
))
(assert
 (= (proj%%core!ops.index.Index./Output $ TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
   $ USIZE
  ) $
))
(assert
 (= (proj%core!ops.index.Index./Output $ TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
   $ USIZE
  ) (UINT 64)
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

;; Function-Decl vstd::seq::Seq::update
(declare-fun vstd!seq.Seq.update.? (Dcr Type Poly Poly Poly) Poly)

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

;; Function-Decl vstd::array::spec_array_fill_for_copy_type
(declare-fun vstd!array.spec_array_fill_for_copy_type.? (Dcr Type Dcr Type Poly) %%Function%%)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_is_lt
(declare-fun vstd!std_specs.range.StepSpec.spec_is_lt.? (Dcr Type Poly Poly) Poly)
(declare-fun vstd!std_specs.range.StepSpec.spec_is_lt%default%.? (Dcr Type Poly Poly)
 Poly
)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_steps_between_int
(declare-fun vstd!std_specs.range.StepSpec.spec_steps_between_int.? (Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!std_specs.range.StepSpec.spec_steps_between_int%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_forward_checked
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::range::StepSpec::spec_forward_checked_int
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked_int.? (Dcr Type Poly
  Poly
 ) Poly
)
(declare-fun vstd!std_specs.range.StepSpec.spec_forward_checked_int%default%.? (Dcr
  Type Poly Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::range::spec_range_next
(declare-fun vstd!std_specs.range.spec_range_next.? (Dcr Type Poly) tuple%2.)

;; Function-Decl vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_requires
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? (Dcr
  Type Dcr Type Poly Poly
 ) Poly
)
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires%default%.?
 (Dcr Type Dcr Type Poly Poly) Poly
)

;; Function-Decl vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_ensures
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? (Dcr
  Type Dcr Type Poly Poly Poly Poly
 ) Poly
)
(declare-fun vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures%default%.?
 (Dcr Type Dcr Type Poly Poly Poly Poly) Poly
)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::pervasive::strictly_cloned
(declare-fun vstd!pervasive.strictly_cloned.? (Dcr Type Poly Poly) Bool)

;; Function-Decl vstd::pervasive::cloned
(declare-fun vstd!pervasive.cloned.? (Dcr Type Poly Poly) Bool)

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

;; Function-Decl vstd::std_specs::option::is_none
(declare-fun vstd!std_specs.option.is_none.? (Dcr Type Poly) Bool)

;; Function-Decl vstd::std_specs::option::spec_unwrap
(declare-fun vstd!std_specs.option.spec_unwrap.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::std_specs::option::spec_unwrap_or
(declare-fun vstd!std_specs.option.spec_unwrap_or.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::exec_invariant
(declare-fun vstd!pervasive.ForLoopGhostIterator.exec_invariant.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.exec_invariant%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_invariant
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_invariant%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_ensures
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? (Dcr Type Poly) Poly)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_ensures%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_decrease
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? (Dcr Type Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_decrease%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_peek_next
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? (Dcr Type Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_peek_next%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIterator::ghost_advance
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_advance.? (Dcr Type Poly Poly)
 Poly
)
(declare-fun vstd!pervasive.ForLoopGhostIterator.ghost_advance%default%.? (Dcr Type
  Poly Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::ForLoopGhostIteratorNew::ghost_iter
(declare-fun vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? (Dcr Type Poly) Poly)
(declare-fun vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter%default%.? (Dcr Type
  Poly
 ) Poly
)

;; Function-Decl vstd::pervasive::arbitrary
(declare-fun vstd!pervasive.arbitrary.? (Dcr Type) Poly)

;; Function-Decl curve25519_dalek::backend::serial::u64::subtle_assumes::choice_is_true
(declare-fun curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::core_specs::u8_32_as_nat
(declare-fun curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::group_order
(declare-fun curve25519_dalek!specs.scalar52_specs.group_order.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(declare-fun curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly Poly) Int)
(declare-fun curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? (Poly Poly
  Fuel
 ) Int
)

;; Function-Decl vstd::std_specs::num::u64_specs::wrapping_sub%returns_clause_autospec
(declare-fun vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.? (
  Poly Poly
 ) Int
)

;; Function-Decl vstd::std_specs::core::iter_into_iter_spec
(declare-fun vstd!std_specs.core.iter_into_iter_spec.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::skip
(declare-fun vstd!seq.impl&%0.skip.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq_lib::impl&%0::map
(declare-fun vstd!seq_lib.impl&%0.map.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl curve25519_dalek::backend::serial::u64::scalar::impl&%6::ZERO
(declare-fun curve25519_dalek!backend.serial.u64.scalar.impl&%6.ZERO.? () curve25519_dalek!backend.serial.u64.scalar.Scalar52.)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::L
(declare-fun curve25519_dalek!backend.serial.u64.constants.L.? () curve25519_dalek!backend.serial.u64.scalar.Scalar52.)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::LFACTOR
(declare-fun curve25519_dalek!backend.serial.u64.constants.LFACTOR.? () Int)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::R
(declare-fun curve25519_dalek!backend.serial.u64.constants.R.? () curve25519_dalek!backend.serial.u64.scalar.Scalar52.)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::RR
(declare-fun curve25519_dalek!backend.serial.u64.constants.RR.? () curve25519_dalek!backend.serial.u64.scalar.Scalar52.)

;; Function-Decl curve25519_dalek::lemmas::scalar_byte_lemmas::scalar_to_bytes_lemmas::bytes_match_limbs_packing_52
(declare-fun curve25519_dalek!lemmas.scalar_byte_lemmas.scalar_to_bytes_lemmas.bytes_match_limbs_packing_52.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_part1_chain_lemmas::l0
(declare-fun curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.?
 (Poly) Int
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::montgomery_radix
(declare-fun curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::core_specs::bytes_as_nat_suffix
(declare-fun curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? (Dcr Type Poly
  Poly
 ) Int
)
(declare-fun curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? (Dcr Type
  Poly Poly Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::specs::core_specs::spec_load8_at
(declare-fun curve25519_dalek!specs.core_specs.spec_load8_at.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::core_specs::bytes_seq_as_nat
(declare-fun curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? (Poly) Int)
(declare-fun curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? (Poly Fuel)
 Int
)

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

;; Function-Decl curve25519_dalek::specs::core_specs::word64_from_bytes
(declare-fun curve25519_dalek!specs.core_specs.word64_from_bytes.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::core_specs::word64_from_bytes_partial
(declare-fun curve25519_dalek!specs.core_specs.word64_from_bytes_partial.? (Poly Poly
  Poly
 ) Int
)
(declare-fun curve25519_dalek!specs.core_specs.rec%word64_from_bytes_partial.? (Poly
  Poly Poly Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::specs::core_specs::words64_from_bytes_to_nat
(declare-fun curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? (Poly Poly)
 Int
)
(declare-fun curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? (Poly
  Poly Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::group_canonical
(declare-fun curve25519_dalek!specs.scalar52_specs.group_canonical.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::seq_as_nat_52
(declare-fun curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.? (Poly) Int)
(declare-fun curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.? (Poly Fuel)
 Int
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::slice128_as_nat
(declare-fun curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::seq_u64_as_nat
(declare-fun curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::limbs52_as_nat
(declare-fun curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::scalar52_as_nat
(declare-fun curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::scalar52_as_canonical_nat
(declare-fun curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::five_limbs_to_nat_aux
(declare-fun curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::five_u64_limbs_to_nat
(declare-fun curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.? (Poly Poly
  Poly Poly Poly
 ) Int
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::limbs_bounded
(declare-fun curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::limbs_bounded_for_sub
(declare-fun curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub.? (Poly Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::limb_prod_bounded_u128
(declare-fun curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.? (Poly Poly
  Poly
 ) Bool
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::is_canonical_scalar52
(declare-fun curve25519_dalek!specs.scalar52_specs.is_canonical_scalar52.? (Poly)
 Bool
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::spec_mul_internal
(declare-fun curve25519_dalek!specs.scalar52_specs.spec_mul_internal.? (Poly Poly)
 %%Function%%
)

;; Function-Decl curve25519_dalek::specs::montgomery_reduce_specs::montgomery_reduce_input_bounds
(declare-fun curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::montgomery_reduce_specs::montgomery_reduce_canonical_bound
(declare-fun curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::specs::montgomery_reduce_specs::montgomery_congruent
(declare-fun curve25519_dalek!specs.montgomery_reduce_specs.montgomery_congruent.?
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

;; Function-Specs vstd::seq::Seq::update
(declare-fun req%vstd!seq.Seq.update. (Dcr Type Poly Poly Poly) Bool)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly) (a! Poly)) (!
   (= (req%vstd!seq.Seq.update. A&. A& self! i! a!) (=>
     %%global_location_label%%3
     (let
      ((tmp%%$ (%I i!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? A&. A& self!))
   ))))
   :pattern ((req%vstd!seq.Seq.update. A&. A& self! i! a!))
   :qid internal_req__vstd!seq.Seq.update._definition
   :skolemid skolem_internal_req__vstd!seq.Seq.update._definition
)))

;; Function-Axioms vstd::seq::Seq::update
(assert
 (forall ((A&. Dcr) (A& Type) (self! Poly) (i! Poly) (a! Poly)) (!
   (=>
    (and
     (has_type self! (TYPE%vstd!seq.Seq. A&. A&))
     (has_type i! INT)
     (has_type a! A&)
    )
    (has_type (vstd!seq.Seq.update.? A&. A& self! i! a!) (TYPE%vstd!seq.Seq. A&. A&))
   )
   :pattern ((vstd!seq.Seq.update.? A&. A& self! i! a!))
   :qid internal_vstd!seq.Seq.update.?_pre_post_definition
   :skolemid skolem_internal_vstd!seq.Seq.update.?_pre_post_definition
)))

;; Broadcast vstd::seq::axiom_seq_update_len
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_update_len.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly) (a! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
      (has_type a! A&)
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
      (= (vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!)) (vstd!seq.Seq.len.?
        A&. A& s!
    ))))
    :pattern ((vstd!seq.Seq.len.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!)))
    :qid user_vstd__seq__axiom_seq_update_len_8
    :skolemid skolem_user_vstd__seq__axiom_seq_update_len_8
))))

;; Broadcast vstd::seq::axiom_seq_update_same
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_update_same.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i! Poly) (a! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i! INT)
      (has_type a! A&)
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
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!) i!) a!)
    ))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i! a!) i!))
    :qid user_vstd__seq__axiom_seq_update_same_9
    :skolemid skolem_user_vstd__seq__axiom_seq_update_same_9
))))

;; Broadcast vstd::seq::axiom_seq_update_different
(assert
 (=>
  (fuel_bool fuel%vstd!seq.axiom_seq_update_different.)
  (forall ((A&. Dcr) (A& Type) (s! Poly) (i1! Poly) (i2! Poly) (a! Poly)) (!
    (=>
     (and
      (has_type s! (TYPE%vstd!seq.Seq. A&. A&))
      (has_type i1! INT)
      (has_type i2! INT)
      (has_type a! A&)
     )
     (=>
      (and
       (and
        (and
         (sized A&.)
         (let
          ((tmp%%$ (%I i1!)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
        )))
        (let
         ((tmp%%$ (%I i2!)))
         (and
          (<= 0 tmp%%$)
          (< tmp%%$ (vstd!seq.Seq.len.? A&. A& s!))
       )))
       (not (= i1! i2!))
      )
      (= (vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i2! a!) i1!) (vstd!seq.Seq.index.?
        A&. A& s! i1!
    ))))
    :pattern ((vstd!seq.Seq.index.? A&. A& (vstd!seq.Seq.update.? A&. A& s! i2! a!) i1!))
    :qid user_vstd__seq__axiom_seq_update_different_10
    :skolemid skolem_user_vstd__seq__axiom_seq_update_different_10
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
          :qid user_vstd__seq__axiom_seq_ext_equal_11
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_11
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_12
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_12
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
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_13
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_13
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_14
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_14
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
    :qid user_vstd__seq__axiom_seq_subrange_len_15
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_len_15
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
    :qid user_vstd__seq__axiom_seq_subrange_index_16
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_index_16
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
    :qid user_vstd__seq__lemma_seq_two_subranges_index_17
    :skolemid skolem_user_vstd__seq__lemma_seq_two_subranges_index_17
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
    :qid user_vstd__slice__axiom_spec_len_18
    :skolemid skolem_user_vstd__slice__axiom_spec_len_18
))))

;; Function-Specs vstd::slice::SliceAdditionalSpecFns::spec_index
(declare-fun req%vstd!slice.SliceAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%4
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
          :qid user_vstd__slice__axiom_slice_ext_equal_19
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_19
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_20
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_20
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
    :qid user_vstd__slice__axiom_slice_has_resolved_21
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_21
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
    :qid user_vstd__array__array_len_matches_n_22
    :skolemid skolem_user_vstd__array__array_len_matches_n_22
))))

;; Function-Specs vstd::array::ArrayAdditionalSpecFns::spec_index
(declare-fun req%vstd!array.ArrayAdditionalSpecFns.spec_index. (Dcr Type Dcr Type Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%5
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
    :qid user_vstd__array__lemma_array_index_23
    :skolemid skolem_user_vstd__array__lemma_array_index_23
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
    :qid user_vstd__array__axiom_spec_array_as_slice_24
    :skolemid skolem_user_vstd__array__axiom_spec_array_as_slice_24
))))

;; Function-Axioms vstd::array::spec_array_fill_for_copy_type
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (t! Poly)) (!
   (=>
    (has_type t! T&)
    (has_type (Poly%array%. (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
     (ARRAY T&. T& N&. N&)
   ))
   :pattern ((vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
   :qid internal_vstd!array.spec_array_fill_for_copy_type.?_pre_post_definition
   :skolemid skolem_internal_vstd!array.spec_array_fill_for_copy_type.?_pre_post_definition
)))

;; Broadcast vstd::array::axiom_spec_array_fill_for_copy_type
(assert
 (=>
  (fuel_bool fuel%vstd!array.axiom_spec_array_fill_for_copy_type.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (t! Poly)) (!
    (=>
     (has_type t! T&)
     (=>
      (and
       (sized T&.)
       (uInv SZ (const_int N&))
      )
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ (const_int N&))
          ))
          (= (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) (Poly%array%.
              (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!)
             )
            ) i$
           ) t!
        )))
        :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
           (Poly%array%. (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
          ) i$
        ))
        :qid user_vstd__array__axiom_spec_array_fill_for_copy_type_25
        :skolemid skolem_user_vstd__array__axiom_spec_array_fill_for_copy_type_25
    ))))
    :pattern ((vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
    :qid user_vstd__array__axiom_spec_array_fill_for_copy_type_26
    :skolemid skolem_user_vstd__array__axiom_spec_array_fill_for_copy_type_26
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
         :qid user_vstd__array__axiom_array_ext_equal_27
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_27
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_28
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_28
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
    :qid user_vstd__array__axiom_array_has_resolved_29
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_29
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $slice STRSLICE)
)

;; Broadcast vstd::string::axiom_str_literal_len
(assert
 (=>
  (fuel_bool fuel%vstd!string.axiom_str_literal_len.)
  (forall ((s! Poly)) (!
    (=>
     (has_type s! STRSLICE)
     (= (vstd!seq.Seq.len.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!)) (str%strslice_len
       (%Poly%strslice%. s!)
    )))
    :pattern ((vstd!seq.Seq.len.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!)))
    :qid user_vstd__string__axiom_str_literal_len_30
    :skolemid skolem_user_vstd__string__axiom_str_literal_len_30
))))

;; Broadcast vstd::string::axiom_str_literal_get_char
(assert
 (=>
  (fuel_bool fuel%vstd!string.axiom_str_literal_get_char.)
  (forall ((s! Poly) (i! Poly)) (!
    (=>
     (and
      (has_type s! STRSLICE)
      (has_type i! INT)
     )
     (= (%I (vstd!seq.Seq.index.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!) i!))
      (str%strslice_get_char (%Poly%strslice%. s!) (%I i!))
    ))
    :pattern ((vstd!seq.Seq.index.? $ CHAR (vstd!view.View.view.? $slice STRSLICE s!) i!))
    :qid user_vstd__string__axiom_str_literal_get_char_31
    :skolemid skolem_user_vstd__string__axiom_str_literal_get_char_31
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_32
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_32
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_33
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_33
))))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_is_lt
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (other! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type other! Self%&)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_is_lt.? Self%&. Self%& self! other!)
     BOOL
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? Self%&. Self%& self! other!))
   :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_steps_between_int
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (end! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type end! Self%&)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_steps_between_int.? Self%&. Self%& self!
      end!
     ) INT
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? Self%&. Self%& self!
     end!
   ))
   :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_forward_checked
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (count! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type count! USIZE)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_forward_checked.? Self%&. Self%& self!
      count!
     ) (TYPE%core!option.Option. Self%&. Self%&)
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? Self%&. Self%& self!
     count!
   ))
   :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::StepSpec::spec_forward_checked_int
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (count! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type count! INT)
    )
    (has_type (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? Self%&. Self%&
      self! count!
     ) (TYPE%core!option.Option. Self%&. Self%&)
   ))
   :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? Self%&. Self%&
     self! count!
   ))
   :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 8) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 255)
       (core!option.Option./Some (I (uClip 8 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 8) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 8) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 8) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 8) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::spec_range_next
(assert
 (forall ((A&. Dcr) (A& Type) (a! Poly)) (!
   (=>
    (has_type a! (TYPE%core!ops.range.Range. A&. A&))
    (has_type (Poly%tuple%2. (vstd!std_specs.range.spec_range_next.? A&. A& a!)) (TYPE%tuple%2.
      $ (TYPE%core!ops.range.Range. A&. A&) $ (TYPE%core!option.Option. A&. A&)
   )))
   :pattern ((vstd!std_specs.range.spec_range_next.? A&. A& a!))
   :qid internal_vstd!std_specs.range.spec_range_next.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.range.spec_range_next.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::impl&%6::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%6.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 8) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 8) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 8))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u8
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u8.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 8)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 8) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 8) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 8) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 8) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 8) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 8) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u8_34
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u8_34
))))

;; Function-Axioms vstd::std_specs::range::impl&%7::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%7.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%7.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 16) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 16) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%7::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%7.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%7.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 16) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 65535)
       (core!option.Option./Some (I (uClip 16 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 16) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%7::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%7.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%7.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 16) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 16) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 16) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%7::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%7.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%7.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 16) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 16) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 16))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u16
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u16.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 16)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 16) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 16) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 16) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 16) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 16) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 16) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 16) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u16_35
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u16_35
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 32) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 4294967295)
       (core!option.Option./Some (I (uClip 32 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 32) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 32) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 32) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 32) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%8::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%8.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 32) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 32) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 32))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u32
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u32.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 32)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 32) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 32) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 32) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 32) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 32) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 32) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u32_36
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u32_36
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 64) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 18446744073709551615)
       (core!option.Option./Some (I (uClip 64 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 64) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 64) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 64) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 64) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%9::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%9.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 64) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 64) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 64))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u64
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u64.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 64)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 64) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 64) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 64) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 64) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 64) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 64) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u64_37
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u64_37
))))

;; Function-Axioms vstd::std_specs::range::impl&%10::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%10.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%10.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 128) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 128) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%10::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%10.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%10.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 128) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 340282366920938463463374607431768211455)
       (core!option.Option./Some (I (uClip 128 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 128) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%10::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%10.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%10.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 128) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (UINT 128) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (UINT 128) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%10::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%10.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%10.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 128) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (UINT 128) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (UINT 128))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_u128
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_u128.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (UINT 128)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 128) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (UINT 128) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (UINT 128) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (UINT 128) range!) (tuple%2./tuple%2 (
             Poly%core!ops.range.Range. (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end
               (%Poly%core!ops.range.Range. range!)
             ))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (UINT 128) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (UINT 128) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (UINT 128) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_u128_38
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_u128_38
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ USIZE self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) (- (uHi SZ) 1))
       (core!option.Option./Some (I (uClip SZ (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ USIZE self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ USIZE self! count!) (vstd!std_specs.range.StepSpec.spec_forward_checked_int.?
      $ USIZE self! count!
    ))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ USIZE self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%11::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%11.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ USIZE self! end!) (I (
       Sub (%I end!) (%I self!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ USIZE self! end!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ USIZE)
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_usize
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_usize.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ USIZE))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ USIZE (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ USIZE range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ USIZE (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ USIZE range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ USIZE range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_usize_39
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_usize_39
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_is_lt
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_is_lt.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_is_lt.)
  (forall ((self! Poly) (other! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) self! other!) (B (< (%I self!)
       (%I other!)
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) self! other!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_is_lt.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_forward_checked_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_forward_checked_int.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 32) self! count!)
     (Poly%core!option.Option. (ite
       (<= (Add (%I self!) (%I count!)) 2147483647)
       (core!option.Option./Some (I (iClip 32 (Add (%I self!) (%I count!)))))
       core!option.Option./None
    )))
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 32) self!
      count!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked_int.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_forward_checked
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_forward_checked.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_forward_checked.)
  (forall ((self! Poly) (count! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (SINT 32) self! count!)
     (vstd!std_specs.range.StepSpec.spec_forward_checked_int.? $ (SINT 32) self! count!)
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_forward_checked.? $ (SINT 32) self! count!))
    :qid internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_forward_checked.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%14::spec_steps_between_int
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%14.spec_steps_between_int.)
  (forall ((self! Poly) (end! Poly)) (!
    (= (vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (SINT 32) self! end!)
     (I (Sub (%I end!) (%I self!)))
    )
    :pattern ((vstd!std_specs.range.StepSpec.spec_steps_between_int.? $ (SINT 32) self!
      end!
    ))
    :qid internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
    :skolemid skolem_internal_vstd!std_specs.range.StepSpec.spec_steps_between_int.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!std_specs.range.StepSpec. $ (SINT 32))
)

;; Broadcast vstd::std_specs::range::axiom_spec_range_next_i32
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.axiom_spec_range_next_i32.)
  (forall ((range! Poly)) (!
    (=>
     (has_type range! (TYPE%core!ops.range.Range. $ (SINT 32)))
     (and
      (=>
       (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) (core!ops.range.Range./Range/start
          (%Poly%core!ops.range.Range. range!)
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       ))
       (let
        ((tmp%%$ (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
            $ (SINT 32) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. range!))
            (I 1)
        ))))
        (=>
         (is-core!option.Option./Some tmp%%$)
         (let
          ((n$ (%I (core!option.Option./Some/0 $ (SINT 32) (%Poly%core!option.Option. (Poly%core!option.Option.
                tmp%%$
          ))))))
          (= (vstd!std_specs.range.spec_range_next.? $ (SINT 32) range!) (tuple%2./tuple%2 (Poly%core!ops.range.Range.
             (core!ops.range.Range./Range (I n$) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range.
                range!
             )))
            ) (Poly%core!option.Option. (core!option.Option./Some (core!ops.range.Range./Range/start
               (%Poly%core!ops.range.Range. range!)
      )))))))))
      (=>
       (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? $ (SINT 32) (core!ops.range.Range./Range/start
           (%Poly%core!ops.range.Range. range!)
          ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. range!))
       )))
       (= (vstd!std_specs.range.spec_range_next.? $ (SINT 32) range!) (tuple%2./tuple%2 range!
         (Poly%core!option.Option. core!option.Option./None)
    )))))
    :pattern ((vstd!std_specs.range.spec_range_next.? $ (SINT 32) range!))
    :qid user_vstd__std_specs__range__axiom_spec_range_next_i32_40
    :skolemid skolem_user_vstd__std_specs__range__axiom_spec_range_next_i32_40
))))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!alloc.Allocator. $ ALLOCATOR_GLOBAL)
)

;; Function-Specs core::clone::Clone::clone
(declare-fun ens%core!clone.Clone.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (%return! Poly)) (!
   (= (ens%core!clone.Clone.clone. Self%&. Self%& self! %return!) (has_type %return! Self%&))
   :pattern ((ens%core!clone.Clone.clone. Self%&. Self%& self! %return!))
   :qid internal_ens__core!clone.Clone.clone._definition
   :skolemid skolem_internal_ens__core!clone.Clone.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (Self%&. Dcr) (Self%& Type)) (!
   (=>
    (has_type closure%$ (TYPE%tuple%1. (REF Self%&.) Self%&))
    (=>
     (let
      ((self$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      true
     )
     (closure_req (FNDEF%core!clone.Clone.clone. Self%&. Self%&) (DST (REF Self%&.)) (TYPE%tuple%1.
       (REF Self%&.) Self%&
      ) (F fndef_singleton) closure%$
   )))
   :pattern ((closure_req (FNDEF%core!clone.Clone.clone. Self%&. Self%&) (DST (REF Self%&.))
     (TYPE%tuple%1. (REF Self%&.) Self%&) (F fndef_singleton) closure%$
   ))
   :qid user_core__clone__Clone__clone_41
   :skolemid skolem_user_core__clone__Clone__clone_41
)))

;; Function-Axioms vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_requires
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type) (self! Poly) (index! Poly))
  (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type index! Idx&)
    )
    (has_type (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? Self%&.
      Self%& Idx&. Idx& self! index!
     ) BOOL
   ))
   :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? Self%&.
     Self%& Idx&. Idx& self! index!
   ))
   :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::core::IndexSetTrustedSpec::spec_index_set_ensures
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (Idx&. Dcr) (Idx& Type) (self! Poly) (new_container!
    Poly
   ) (index! Poly) (val! Poly)
  ) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type new_container! Self%&)
     (has_type index! Idx&)
     (has_type val! (proj%core!ops.index.Index./Output Self%&. Self%& Idx&. Idx&))
    )
    (has_type (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? Self%&.
      Self%& Idx&. Idx& self! new_container! index! val!
     ) BOOL
   ))
   :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? Self%&.
     Self%& Idx&. Idx& self! new_container! index! val!
   ))
   :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_pre_post_definition
)))

;; Function-Specs core::clone::impls::impl&%6::clone
(declare-fun ens%core!clone.impls.impl&%6.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%6.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 8) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%6.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__6.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__6.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 8)))
     (has_type res$ (UINT 8))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 8)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 8)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 8)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 8)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%6__clone_42
   :skolemid skolem_user_core__clone__impls__impl&%6__clone_42
)))

;; Function-Specs core::clone::impls::impl&%7::clone
(declare-fun ens%core!clone.impls.impl&%7.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%7.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 16) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%7.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__7.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__7.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 16)))
     (has_type res$ (UINT 16))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 16)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 16)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 16)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 16)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%7__clone_43
   :skolemid skolem_user_core__clone__impls__impl&%7__clone_43
)))

;; Function-Specs core::clone::impls::impl&%8::clone
(declare-fun ens%core!clone.impls.impl&%8.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%8.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 32) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%8.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__8.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__8.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 32)))
     (has_type res$ (UINT 32))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 32)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 32)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 32)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 32)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%8__clone_44
   :skolemid skolem_user_core__clone__impls__impl&%8__clone_44
)))

;; Function-Specs core::clone::impls::impl&%14::clone
(declare-fun ens%core!clone.impls.impl&%14.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%14.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (SINT 32) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%14.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__14.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__14.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (SINT 32)))
     (has_type res$ (SINT 32))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 32)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (SINT 32)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (SINT 32)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (SINT 32)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%14__clone_45
   :skolemid skolem_user_core__clone__impls__impl&%14__clone_45
)))

;; Function-Specs core::clone::impls::impl&%9::clone
(declare-fun ens%core!clone.impls.impl&%9.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%9.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 64) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%9.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__9.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__9.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 64)))
     (has_type res$ (UINT 64))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 64)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 64)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 64)) (DST (REF $)) (TYPE%tuple%1.
      (REF $) (UINT 64)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%9__clone_46
   :skolemid skolem_user_core__clone__impls__impl&%9__clone_46
)))

;; Function-Specs core::num::impl&%9::wrapping_sub
(declare-fun ens%core!num.impl&%9.wrapping_sub. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (%return! Int)) (!
   (= (ens%core!num.impl&%9.wrapping_sub. x! y! %return!) (and
     (uInv 64 %return!)
     (= %return! (ite
       (< (Sub x! y!) 0)
       (uClip 64 (Add (Sub x! y!) 18446744073709551616))
       (uClip 64 (Sub x! y!))
   ))))
   :pattern ((ens%core!num.impl&%9.wrapping_sub. x! y! %return!))
   :qid internal_ens__core!num.impl&__9.wrapping_sub._definition
   :skolemid skolem_internal_ens__core!num.impl&__9.wrapping_sub._definition
)))

;; Function-Specs core::clone::impls::impl&%10::clone
(declare-fun ens%core!clone.impls.impl&%10.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%10.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ (UINT 128) x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%10.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__10.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__10.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (UINT 128)))
     (has_type res$ (UINT 128))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 128)) (DST (REF $)) (TYPE%tuple%1.
       (REF $) (UINT 128)
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (UINT 128)) (DST (REF $)) (
      TYPE%tuple%1. (REF $) (UINT 128)
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%10__clone_47
   :skolemid skolem_user_core__clone__impls__impl&%10__clone_47
)))

;; Function-Specs core::clone::impls::impl&%5::clone
(declare-fun ens%core!clone.impls.impl&%5.clone. (Poly Poly) Bool)
(assert
 (forall ((x! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%5.clone. x! res!) (and
     (ens%core!clone.Clone.clone. $ USIZE x! res!)
     (= res! x!)
   ))
   :pattern ((ens%core!clone.impls.impl&%5.clone. x! res!))
   :qid internal_ens__core!clone.impls.impl&__5.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__5.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) USIZE))
     (has_type res$ USIZE)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ USIZE) (DST (REF $)) (TYPE%tuple%1. (
        REF $
       ) USIZE
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((x$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I res$) x$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ USIZE) (DST (REF $)) (TYPE%tuple%1.
      (REF $) USIZE
     ) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%5__clone_48
   :skolemid skolem_user_core__clone__impls__impl&%5__clone_48
)))

;; Function-Specs vstd::arithmetic::div_mod::lemma_small_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(declare-const %%global_location_label%%6 Bool)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (and
     (=>
      %%global_location_label%%6
      (< x! m!)
     )
     (=>
      %%global_location_label%%7
      (< 0 m!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_small_mod._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_small_mod._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (= (EucMod x! m!) x!))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_small_mod. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_small_mod._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_small_mod._definition
)))

;; Function-Specs vstd::arithmetic::div_mod::lemma_multiply_divide_lt
(declare-fun req%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. (Int Int Int) Bool)
(declare-const %%global_location_label%%8 Bool)
(declare-const %%global_location_label%%9 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. a! b! c!) (and
     (=>
      %%global_location_label%%8
      (< 0 b!)
     )
     (=>
      %%global_location_label%%9
      (< a! (Mul b! c!))
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. a! b! c!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_multiply_divide_lt._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_multiply_divide_lt._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. (Int Int Int) Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. a! b! c!) (< (EucDiv a! b!)
     c!
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. a! b! c!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_multiply_divide_lt._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_multiply_divide_lt._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_multiply_divide_lt
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_multiply_divide_lt.)
  (forall ((a! Int) (b! Int) (c! Int)) (!
    (=>
     (and
      (< 0 b!)
      (< a! (Mul b! c!))
     )
     (< (EucDiv a! b!) c!)
    )
    :pattern ((EucDiv a! b!) (Mul b! c!))
    :qid user_vstd__arithmetic__div_mod__lemma_multiply_divide_lt_49
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_multiply_divide_lt_49
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_sub_multiples_vanish
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish. (Int Int)
 Bool
)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((b! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish. b! m!) (=>
     %%global_location_label%%10
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish. b! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish. (Int Int)
 Bool
)
(assert
 (forall ((b! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish. b! m!) (= (EucMod (Add
       (Sub 0 m!) b!
      ) m!
     ) (EucMod b! m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish. b! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_sub_multiples_vanish
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish.)
  (forall ((b! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Add (Sub 0 m!) b!) m!) (EucMod b! m!))
    )
    :pattern ((EucMod b! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_sub_multiples_vanish_50
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_sub_multiples_vanish_50
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_multiples_vanish
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. (Int Int Int)
 Bool
)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!) (=>
     %%global_location_label%%11
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. (Int Int Int)
 Bool
)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!) (= (EucMod (Add
       (Mul m! a!) b!
      ) m!
     ) (EucMod b! m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_vanish._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_multiples_vanish
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish.)
  (forall ((a! Int) (b! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Add (Mul m! a!) b!) m!) (EucMod b! m!))
    )
    :pattern ((EucMod (Add (Mul m! a!) b!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_multiples_vanish_51
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_multiples_vanish_51
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_fundamental_div_mod_converse
(declare-fun req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. (Int Int
  Int Int
 ) Bool
)
(declare-const %%global_location_label%%12 Bool)
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((x! Int) (d! Int) (q! Int) (r! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. x! d! q! r!) (
     and
     (=>
      %%global_location_label%%12
      (not (= d! 0))
     )
     (=>
      %%global_location_label%%13
      (let
       ((tmp%%$ r!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ d!)
     )))
     (=>
      %%global_location_label%%14
      (= x! (Add (Mul q! d!) r!))
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. x! d! q!
     r!
   ))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. (Int Int
  Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (d! Int) (q! Int) (r! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. x! d! q! r!) (
     and
     (= r! (EucMod x! d!))
     (= q! (EucDiv x! d!))
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. x! d! q!
     r!
   ))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse._definition
)))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_basics_3
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_basics_3. (Int) Bool)
(assert
 (forall ((x! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_basics_3. x!) (= (Mul x! 1) x!))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_basics_3. x!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_basics_3._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_basics_3._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_basics_3
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_basics_3.)
  (forall ((x! Int)) (!
    (= (Mul x! 1) x!)
    :pattern ((Mul x! 1))
    :qid user_vstd__arithmetic__mul__lemma_mul_basics_3_52
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_basics_3_52
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_53
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_53
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_distributive_add
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add. (Int Int Int)
 Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add. x! y! z!) (= (Mul x! (Add
       y! z!
      )
     ) (Add (Mul x! y!) (Mul x! z!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_distributive_add. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_add._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_add._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_distributive_add
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul x! (Add y! z!)) (Add (Mul x! y!) (Mul x! z!)))
    :pattern ((Mul x! (Add y! z!)))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_54
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_54
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_55
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_55
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_adds_56
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_adds_56
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_57
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_57
))))

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

;; Function-Specs vstd::arithmetic::power2::lemma2_to64_rest
(declare-fun ens%vstd!arithmetic.power2.lemma2_to64_rest. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma2_to64_rest. no%param) (and
     (= (vstd!arithmetic.power2.pow2.? (I 33)) 8589934592)
     (= (vstd!arithmetic.power2.pow2.? (I 34)) 17179869184)
     (= (vstd!arithmetic.power2.pow2.? (I 35)) 34359738368)
     (= (vstd!arithmetic.power2.pow2.? (I 36)) 68719476736)
     (= (vstd!arithmetic.power2.pow2.? (I 37)) 137438953472)
     (= (vstd!arithmetic.power2.pow2.? (I 38)) 274877906944)
     (= (vstd!arithmetic.power2.pow2.? (I 39)) 549755813888)
     (= (vstd!arithmetic.power2.pow2.? (I 40)) 1099511627776)
     (= (vstd!arithmetic.power2.pow2.? (I 41)) 2199023255552)
     (= (vstd!arithmetic.power2.pow2.? (I 42)) 4398046511104)
     (= (vstd!arithmetic.power2.pow2.? (I 43)) 8796093022208)
     (= (vstd!arithmetic.power2.pow2.? (I 44)) 17592186044416)
     (= (vstd!arithmetic.power2.pow2.? (I 45)) 35184372088832)
     (= (vstd!arithmetic.power2.pow2.? (I 46)) 70368744177664)
     (= (vstd!arithmetic.power2.pow2.? (I 47)) 140737488355328)
     (= (vstd!arithmetic.power2.pow2.? (I 48)) 281474976710656)
     (= (vstd!arithmetic.power2.pow2.? (I 49)) 562949953421312)
     (= (vstd!arithmetic.power2.pow2.? (I 50)) 1125899906842624)
     (= (vstd!arithmetic.power2.pow2.? (I 51)) 2251799813685248)
     (= (vstd!arithmetic.power2.pow2.? (I 52)) 4503599627370496)
     (= (vstd!arithmetic.power2.pow2.? (I 53)) 9007199254740992)
     (= (vstd!arithmetic.power2.pow2.? (I 54)) 18014398509481984)
     (= (vstd!arithmetic.power2.pow2.? (I 55)) 36028797018963968)
     (= (vstd!arithmetic.power2.pow2.? (I 56)) 72057594037927936)
     (= (vstd!arithmetic.power2.pow2.? (I 57)) 144115188075855872)
     (= (vstd!arithmetic.power2.pow2.? (I 58)) 288230376151711744)
     (= (vstd!arithmetic.power2.pow2.? (I 59)) 576460752303423488)
     (= (vstd!arithmetic.power2.pow2.? (I 60)) 1152921504606846976)
     (= (vstd!arithmetic.power2.pow2.? (I 61)) 2305843009213693952)
     (= (vstd!arithmetic.power2.pow2.? (I 62)) 4611686018427387904)
     (= (vstd!arithmetic.power2.pow2.? (I 63)) 9223372036854775808)
     (= (vstd!arithmetic.power2.pow2.? (I 64)) 18446744073709551616)
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma2_to64_rest. no%param))
   :qid internal_ens__vstd!arithmetic.power2.lemma2_to64_rest._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma2_to64_rest._definition
)))

;; Function-Specs core::clone::impls::impl&%21::clone
(declare-fun ens%core!clone.impls.impl&%21.clone. (Poly Poly) Bool)
(assert
 (forall ((b! Poly) (%return! Poly)) (!
   (= (ens%core!clone.impls.impl&%21.clone. b! %return!) (and
     (ens%core!clone.Clone.clone. $ BOOL b! %return!)
     (= %return! b!)
   ))
   :pattern ((ens%core!clone.impls.impl&%21.clone. b! %return!))
   :qid internal_ens__core!clone.impls.impl&__21.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__21.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) BOOL))
     (has_type %return$ BOOL)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ BOOL) (DST (REF $)) (TYPE%tuple%1. (REF
        $
       ) BOOL
      ) (F fndef_singleton) closure%$ %return$
     )
     (let
      ((b$ (%B (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%B %return$) b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ BOOL) (DST (REF $)) (TYPE%tuple%1.
      (REF $) BOOL
     ) (F fndef_singleton) closure%$ %return$
   ))
   :qid user_core__clone__impls__impl&%21__clone_58
   :skolemid skolem_user_core__clone__impls__impl&%21__clone_58
)))

;; Function-Specs core::clone::impls::impl&%22::clone
(declare-fun ens%core!clone.impls.impl&%22.clone. (Poly Poly) Bool)
(assert
 (forall ((c! Poly) (%return! Poly)) (!
   (= (ens%core!clone.impls.impl&%22.clone. c! %return!) (and
     (ens%core!clone.Clone.clone. $ CHAR c! %return!)
     (= %return! c!)
   ))
   :pattern ((ens%core!clone.impls.impl&%22.clone. c! %return!))
   :qid internal_ens__core!clone.impls.impl&__22.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__22.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (%return$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) CHAR))
     (has_type %return$ CHAR)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ CHAR) (DST (REF $)) (TYPE%tuple%1. (REF
        $
       ) CHAR
      ) (F fndef_singleton) closure%$ %return$
     )
     (let
      ((c$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (%I %return$) c$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ CHAR) (DST (REF $)) (TYPE%tuple%1.
      (REF $) CHAR
     ) (F fndef_singleton) closure%$ %return$
   ))
   :qid user_core__clone__impls__impl&%22__clone_59
   :skolemid skolem_user_core__clone__impls__impl&%22__clone_59
)))

;; Function-Specs core::clone::impls::impl&%3::clone
(declare-fun ens%core!clone.impls.impl&%3.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%core!clone.impls.impl&%3.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (REF T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%core!clone.impls.impl&%3.clone. T&. T& b! res!))
   :qid internal_ens__core!clone.impls.impl&__3.clone._definition
   :skolemid skolem_internal_ens__core!clone.impls.impl&__3.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (REF T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (REF T&.) T&) (DST (REF (REF T&.))) (TYPE%tuple%1.
       (REF (REF T&.)) T&
      ) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (REF T&.) T&) (DST (REF (REF T&.)))
     (TYPE%tuple%1. (REF (REF T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__clone__impls__impl&%3__clone_60
   :skolemid skolem_user_core__clone__impls__impl&%3__clone_60
)))

;; Function-Axioms vstd::pervasive::strictly_cloned
(assert
 (fuel_bool_default fuel%vstd!pervasive.strictly_cloned.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!pervasive.strictly_cloned.)
  (forall ((T&. Dcr) (T& Type) (a! Poly) (b! Poly)) (!
    (= (vstd!pervasive.strictly_cloned.? T&. T& a! b!) (closure_ens (FNDEF%core!clone.Clone.clone.
       T&. T&
      ) (DST (REF T&.)) (TYPE%tuple%1. (REF T&.) T&) (F fndef_singleton) (Poly%tuple%1.
       (tuple%1./tuple%1 a!)
      ) b!
    ))
    :pattern ((vstd!pervasive.strictly_cloned.? T&. T& a! b!))
    :qid internal_vstd!pervasive.strictly_cloned.?_definition
    :skolemid skolem_internal_vstd!pervasive.strictly_cloned.?_definition
))))

;; Function-Axioms vstd::pervasive::cloned
(assert
 (fuel_bool_default fuel%vstd!pervasive.cloned.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!pervasive.cloned.)
  (forall ((T&. Dcr) (T& Type) (a! Poly) (b! Poly)) (!
    (= (vstd!pervasive.cloned.? T&. T& a! b!) (or
      (vstd!pervasive.strictly_cloned.? T&. T& a! b!)
      (= a! b!)
    ))
    :pattern ((vstd!pervasive.cloned.? T&. T& a! b!))
    :qid internal_vstd!pervasive.cloned.?_definition
    :skolemid skolem_internal_vstd!pervasive.cloned.?_definition
))))

;; Function-Specs core::array::impl&%20::clone
(declare-fun ens%core!array.impl&%20.clone. (Dcr Type Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (a! Poly) (res! Poly)) (!
   (= (ens%core!array.impl&%20.clone. T&. T& N&. N& a! res!) (and
     (ens%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&) a! res!)
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (const_int N&))
         ))
         (vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
            $ (ARRAY T&. T& N&. N&) a!
           ) i$
          ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
           i$
       ))))
       :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
          a!
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
          res!
         ) i$
       ))
       :pattern ((vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
           $ (ARRAY T&. T& N&. N&) a!
          ) i$
         ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
          i$
       )))
       :qid user_core__array__impl&%20__clone_61
       :skolemid skolem_user_core__array__impl&%20__clone_61
     ))
     (=>
      (ext_eq false (TYPE%vstd!seq.Seq. T&. T&) (vstd!view.View.view.? $ (ARRAY T&. T& N&.
         N&
        ) a!
       ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res!)
      )
      (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) a!) (vstd!view.View.view.? $ (ARRAY
         T&. T& N&. N&
        ) res!
   )))))
   :pattern ((ens%core!array.impl&%20.clone. T&. T& N&. N& a! res!))
   :qid internal_ens__core!array.impl&__20.clone._definition
   :skolemid skolem_internal_ens__core!array.impl&__20.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)))
     (has_type res$ (ARRAY T&. T& N&. N&))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&)) (DST (REF $))
      (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)) (F fndef_singleton) closure%$ res$
     )
     (let
      ((a$ (%Poly%array%. (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (and
       (forall ((i$ Poly)) (!
         (=>
          (has_type i$ INT)
          (=>
           (let
            ((tmp%%$ (%I i$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ (const_int N&))
           ))
           (vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
              $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)
             ) i$
            ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
             i$
         ))))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            (Poly%array%. a$)
           ) i$
         ))
         :pattern ((vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&)
            res$
           ) i$
         ))
         :pattern ((vstd!pervasive.cloned.? T&. T& (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.?
             $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)
            ) i$
           ) (vstd!seq.Seq.index.? T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
            i$
         )))
         :qid user_core__array__impl&%20__clone_62
         :skolemid skolem_user_core__array__impl&%20__clone_62
       ))
       (=>
        (ext_eq false (TYPE%vstd!seq.Seq. T&. T&) (vstd!view.View.view.? $ (ARRAY T&. T& N&.
           N&
          ) (Poly%array%. a$)
         ) (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) res$)
        )
        (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) (Poly%array%. a$)) (vstd!view.View.view.?
          $ (ARRAY T&. T& N&. N&) res$
   )))))))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (ARRAY T&. T& N&. N&)) (DST
      (REF $)
     ) (TYPE%tuple%1. (REF $) (ARRAY T&. T& N&. N&)) (F fndef_singleton) closure%$ res$
   ))
   :qid user_core__array__impl&%20__clone_63
   :skolemid skolem_user_core__array__impl&%20__clone_63
)))

;; Function-Specs verus_builtin::impl&%5::clone
(declare-fun ens%verus_builtin!impl&%5.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%verus_builtin!impl&%5.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (TRACKED T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%verus_builtin!impl&%5.clone. T&. T& b! res!))
   :qid internal_ens__verus_builtin!impl&__5.clone._definition
   :skolemid skolem_internal_ens__verus_builtin!impl&__5.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (TRACKED T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (TRACKED T&.) T&) (DST (REF (TRACKED T&.)))
      (TYPE%tuple%1. (REF (TRACKED T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (TRACKED T&.) T&) (DST (REF (TRACKED
        T&.
      ))
     ) (TYPE%tuple%1. (REF (TRACKED T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_verus_builtin__impl&%5__clone_64
   :skolemid skolem_user_verus_builtin__impl&%5__clone_64
)))

;; Function-Specs verus_builtin::impl&%3::clone
(declare-fun ens%verus_builtin!impl&%3.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (b! Poly) (res! Poly)) (!
   (= (ens%verus_builtin!impl&%3.clone. T&. T& b! res!) (and
     (ens%core!clone.Clone.clone. (GHOST T&.) T& b! res!)
     (= res! b!)
   ))
   :pattern ((ens%verus_builtin!impl&%3.clone. T&. T& b! res!))
   :qid internal_ens__verus_builtin!impl&__3.clone._definition
   :skolemid skolem_internal_ens__verus_builtin!impl&__3.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (GHOST T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (GHOST T&.) T&) (DST (REF (GHOST T&.)))
      (TYPE%tuple%1. (REF (GHOST T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (= res$ b$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (GHOST T&.) T&) (DST (REF (GHOST
        T&.
      ))
     ) (TYPE%tuple%1. (REF (GHOST T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_verus_builtin__impl&%3__clone_65
   :skolemid skolem_user_verus_builtin__impl&%3__clone_65
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
   :qid user_core__convert__From__from_66
   :skolemid skolem_user_core__convert__From__from_66
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
   :qid user_core__convert__From__from_67
   :skolemid skolem_user_core__convert__From__from_67
)))

;; Function-Specs core::iter::traits::iterator::Iterator::next
(declare-fun ens%core!iter.traits.iterator.Iterator.next. (Dcr Type Poly Poly Poly)
 Bool
)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (pre%self! Poly) (self! Poly) (%return! Poly))
  (!
   (= (ens%core!iter.traits.iterator.Iterator.next. Self%&. Self%& pre%self! self! %return!)
    (and
     (has_type %return! (TYPE%core!option.Option. (proj%%core!iter.traits.iterator.Iterator./Item
        Self%&. Self%&
       ) (proj%core!iter.traits.iterator.Iterator./Item Self%&. Self%&)
     ))
     (has_type self! Self%&)
   ))
   :pattern ((ens%core!iter.traits.iterator.Iterator.next. Self%&. Self%& pre%self! self!
     %return!
   ))
   :qid internal_ens__core!iter.traits.iterator.Iterator.next._definition
   :skolemid skolem_internal_ens__core!iter.traits.iterator.Iterator.next._definition
)))

;; Function-Specs core::iter::traits::collect::impl&%0::into_iter
(declare-fun ens%core!iter.traits.collect.impl&%0.into_iter. (Dcr Type Poly Poly)
 Bool
)
(assert
 (forall ((I&. Dcr) (I& Type) (i! Poly) (r! Poly)) (!
   (= (ens%core!iter.traits.collect.impl&%0.into_iter. I&. I& i! r!) (and
     (has_type r! I&)
     (= r! i!)
   ))
   :pattern ((ens%core!iter.traits.collect.impl&%0.into_iter. I&. I& i! r!))
   :qid internal_ens__core!iter.traits.collect.impl&__0.into_iter._definition
   :skolemid skolem_internal_ens__core!iter.traits.collect.impl&__0.into_iter._definition
)))

;; Function-Specs vstd::std_specs::core::index_set
(declare-fun req%vstd!std_specs.core.index_set. (Dcr Type Dcr Type Dcr Type Poly Poly
  Poly
 ) Bool
)
(declare-const %%global_location_label%%16 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (Idx&. Dcr) (Idx& Type) (E&. Dcr) (E& Type) (pre%container!
    Poly
   ) (index! Poly) (val! Poly)
  ) (!
   (= (req%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container! index!
     val!
    ) (=>
     %%global_location_label%%16
     (%B (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? T&. T& Idx&.
       Idx& pre%container! index!
   ))))
   :pattern ((req%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container!
     index! val!
   ))
   :qid internal_req__vstd!std_specs.core.index_set._definition
   :skolemid skolem_internal_req__vstd!std_specs.core.index_set._definition
)))
(declare-fun ens%vstd!std_specs.core.index_set. (Dcr Type Dcr Type Dcr Type Poly Poly
  Poly Poly
 ) Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (Idx&. Dcr) (Idx& Type) (E&. Dcr) (E& Type) (pre%container!
    Poly
   ) (container! Poly) (index! Poly) (val! Poly)
  ) (!
   (= (ens%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container! container!
     index! val!
    ) (and
     (has_type container! T&)
     (%B (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? T&. T& Idx&.
       Idx& pre%container! container! index! val!
   ))))
   :pattern ((ens%vstd!std_specs.core.index_set. T&. T& Idx&. Idx& E&. E& pre%container!
     container! index! val!
   ))
   :qid internal_ens__vstd!std_specs.core.index_set._definition
   :skolemid skolem_internal_ens__vstd!std_specs.core.index_set._definition
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

;; Function-Axioms vstd::std_specs::option::is_none
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.is_none.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.is_none.)
  (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
    (= (vstd!std_specs.option.is_none.? T&. T& option!) (is-core!option.Option./None (%Poly%core!option.Option.
       option!
    )))
    :pattern ((vstd!std_specs.option.is_none.? T&. T& option!))
    :qid internal_vstd!std_specs.option.is_none.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.is_none.?_definition
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
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly)) (!
   (= (req%vstd!std_specs.option.spec_unwrap. T&. T& option!) (=>
     %%global_location_label%%17
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

;; Function-Axioms vstd::std_specs::option::spec_unwrap_or
(assert
 (fuel_bool_default fuel%vstd!std_specs.option.spec_unwrap_or.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.option.spec_unwrap_or.)
  (forall ((T&. Dcr) (T& Type) (option! Poly) (default! Poly)) (!
    (= (vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!) (ite
      (is-core!option.Option./Some (%Poly%core!option.Option. option!))
      (let
       ((t$ (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. option!))))
       t$
      )
      default!
    ))
    :pattern ((vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!))
    :qid internal_vstd!std_specs.option.spec_unwrap_or.?_definition
    :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap_or.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (option! Poly) (default! Poly)) (!
   (=>
    (and
     (has_type option! (TYPE%core!option.Option. T&. T&))
     (has_type default! T&)
    )
    (has_type (vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!) T&)
   )
   :pattern ((vstd!std_specs.option.spec_unwrap_or.? T&. T& option! default!))
   :qid internal_vstd!std_specs.option.spec_unwrap_or.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.option.spec_unwrap_or.?_pre_post_definition
)))

;; Function-Specs core::option::impl&%5::clone
(declare-fun ens%core!option.impl&%5.clone. (Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (opt! Poly) (res! Poly)) (!
   (= (ens%core!option.impl&%5.clone. T&. T& opt! res!) (and
     (ens%core!clone.Clone.clone. $ (TYPE%core!option.Option. T&. T&) opt! res!)
     (=>
      (is-core!option.Option./None (%Poly%core!option.Option. opt!))
      (is-core!option.Option./None (%Poly%core!option.Option. res!))
     )
     (=>
      (is-core!option.Option./Some (%Poly%core!option.Option. opt!))
      (and
       (is-core!option.Option./Some (%Poly%core!option.Option. res!))
       (vstd!pervasive.cloned.? T&. T& (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option.
          opt!
         )
        ) (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. res!))
   )))))
   :pattern ((ens%core!option.impl&%5.clone. T&. T& opt! res!))
   :qid internal_ens__core!option.impl&__5.clone._definition
   :skolemid skolem_internal_ens__core!option.impl&__5.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF $) (TYPE%core!option.Option. T&. T&)))
     (has_type res$ (TYPE%core!option.Option. T&. T&))
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. $ (TYPE%core!option.Option. T&. T&)) (
       DST (REF $)
      ) (TYPE%tuple%1. (REF $) (TYPE%core!option.Option. T&. T&)) (F fndef_singleton) closure%$
      res$
     )
     (let
      ((opt$ (%Poly%core!option.Option. (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (and
       (=>
        (is-core!option.Option./None opt$)
        (is-core!option.Option./None (%Poly%core!option.Option. res$))
       )
       (=>
        (is-core!option.Option./Some opt$)
        (and
         (is-core!option.Option./Some (%Poly%core!option.Option. res$))
         (vstd!pervasive.cloned.? T&. T& (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option.
            (Poly%core!option.Option. opt$)
           )
          ) (core!option.Option./Some/0 T&. T& (%Poly%core!option.Option. res$))
   )))))))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. $ (TYPE%core!option.Option. T&.
       T&
      )
     ) (DST (REF $)) (TYPE%tuple%1. (REF $) (TYPE%core!option.Option. T&. T&)) (F fndef_singleton)
     closure%$ res$
   ))
   :qid user_core__option__impl&%5__clone_68
   :skolemid skolem_user_core__option__impl&%5__clone_68
)))

;; Function-Specs core::iter::range::impl&%6::next
(declare-fun ens%core!iter.range.impl&%6.next. (Dcr Type Poly Poly Poly) Bool)
(assert
 (forall ((A&. Dcr) (A& Type) (pre%range! Poly) (range! Poly) (r! Poly)) (!
   (= (ens%core!iter.range.impl&%6.next. A&. A& pre%range! range! r!) (and
     (ens%core!iter.traits.iterator.Iterator.next. $ (TYPE%core!ops.range.Range. A&. A&)
      pre%range! range! r!
     )
     (= (tuple%2./tuple%2 range! r!) (vstd!std_specs.range.spec_range_next.? A&. A& pre%range!))
   ))
   :pattern ((ens%core!iter.range.impl&%6.next. A&. A& pre%range! range! r!))
   :qid internal_ens__core!iter.range.impl&__6.next._definition
   :skolemid skolem_internal_ens__core!iter.range.impl&__6.next._definition
)))

;; Function-Specs alloc::boxed::impl&%13::clone
(declare-fun ens%alloc!boxed.impl&%13.clone. (Dcr Type Dcr Type Poly Poly) Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (A&. Dcr) (A& Type) (b! Poly) (res! Poly)) (!
   (= (ens%alloc!boxed.impl&%13.clone. T&. T& A&. A& b! res!) (and
     (ens%core!clone.Clone.clone. (BOX A&. A& T&.) T& b! res!)
     (vstd!pervasive.cloned.? T&. T& b! res!)
   ))
   :pattern ((ens%alloc!boxed.impl&%13.clone. T&. T& A&. A& b! res!))
   :qid internal_ens__alloc!boxed.impl&__13.clone._definition
   :skolemid skolem_internal_ens__alloc!boxed.impl&__13.clone._definition
)))
(assert
 (forall ((closure%$ Poly) (res$ Poly) (T&. Dcr) (T& Type) (A&. Dcr) (A& Type)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&))
     (has_type res$ T&)
    )
    (=>
     (closure_ens (FNDEF%core!clone.Clone.clone. (BOX A&. A& T&.) T&) (DST (REF (BOX A&. A&
         T&.
       ))
      ) (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&) (F fndef_singleton) closure%$ res$
     )
     (let
      ((b$ (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$))))
      (vstd!pervasive.cloned.? T&. T& b$ res$)
   )))
   :pattern ((closure_ens (FNDEF%core!clone.Clone.clone. (BOX A&. A& T&.) T&) (DST (REF
       (BOX A&. A& T&.)
      )
     ) (TYPE%tuple%1. (REF (BOX A&. A& T&.)) T&) (F fndef_singleton) closure%$ res$
   ))
   :qid user_alloc__boxed__impl&%13__clone_69
   :skolemid skolem_user_alloc__boxed__impl&%13__clone_69
)))

;; Function-Specs vstd::array::array_index_get
(declare-fun req%vstd!array.array_index_get. (Dcr Type Dcr Type %%Function%% Int)
 Bool
)
(declare-const %%global_location_label%%18 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! %%Function%%) (i! Int)) (!
   (= (req%vstd!array.array_index_get. T&. T& N&. N& ar! i!) (=>
     %%global_location_label%%18
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

;; Function-Specs vstd::array::array_as_slice
(declare-fun ens%vstd!array.array_as_slice. (Dcr Type Dcr Type %%Function%% Poly)
 Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (ar! %%Function%%) (out! Poly)) (
   !
   (= (ens%vstd!array.array_as_slice. T&. T& N&. N& ar! out!) (and
     (has_type out! (SLICE T&. T&))
     (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) (Poly%array%. ar!)) (vstd!view.View.view.?
       $slice (SLICE T&. T&) out!
   ))))
   :pattern ((ens%vstd!array.array_as_slice. T&. T& N&. N& ar! out!))
   :qid internal_ens__vstd!array.array_as_slice._definition
   :skolemid skolem_internal_ens__vstd!array.array_as_slice._definition
)))

;; Function-Specs vstd::array::array_fill_for_copy_types
(declare-fun ens%vstd!array.array_fill_for_copy_types. (Dcr Type Dcr Type Poly %%Function%%)
 Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (t! Poly) (res! %%Function%%)) (!
   (= (ens%vstd!array.array_fill_for_copy_types. T&. T& N&. N& t! res!) (and
     (has_type (Poly%array%. res!) (ARRAY T&. T& N&. N&))
     (= res! (vstd!array.spec_array_fill_for_copy_type.? T&. T& N&. N& t!))
   ))
   :pattern ((ens%vstd!array.array_fill_for_copy_types. T&. T& N&. N& t! res!))
   :qid internal_ens__vstd!array.array_fill_for_copy_types._definition
   :skolemid skolem_internal_ens__vstd!array.array_fill_for_copy_types._definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::exec_invariant
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (exec_iter! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type exec_iter! (proj%vstd!pervasive.ForLoopGhostIterator./ExecIter Self%&. Self%&))
    )
    (has_type (vstd!pervasive.ForLoopGhostIterator.exec_invariant.? Self%&. Self%& self!
      exec_iter!
     ) BOOL
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.exec_invariant.? Self%&. Self%& self!
     exec_iter!
   ))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_invariant
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (init! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type init! (TYPE%core!option.Option. (REF Self%&.) Self%&))
    )
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? Self%&. Self%& self!
      init!
     ) BOOL
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? Self%&. Self%& self!
     init!
   ))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_ensures
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? Self%&. Self%& self!)
     BOOL
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_decrease
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? Self%&. Self%& self!)
     (TYPE%core!option.Option. (proj%%vstd!pervasive.ForLoopGhostIterator./Decrease Self%&.
       Self%&
      ) (proj%vstd!pervasive.ForLoopGhostIterator./Decrease Self%&. Self%&)
   )))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_peek_next
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? Self%&. Self%& self!)
     (TYPE%core!option.Option. (proj%%vstd!pervasive.ForLoopGhostIterator./Item Self%&.
       Self%&
      ) (proj%vstd!pervasive.ForLoopGhostIterator./Item Self%&. Self%&)
   )))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIterator::ghost_advance
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly) (exec_iter! Poly)) (!
   (=>
    (and
     (has_type self! Self%&)
     (has_type exec_iter! (proj%vstd!pervasive.ForLoopGhostIterator./ExecIter Self%&. Self%&))
    )
    (has_type (vstd!pervasive.ForLoopGhostIterator.ghost_advance.? Self%&. Self%& self!
      exec_iter!
     ) Self%&
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_advance.? Self%&. Self%& self!
     exec_iter!
   ))
   :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_pre_post_definition
)))

;; Function-Axioms vstd::pervasive::ForLoopGhostIteratorNew::ghost_iter
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (self! Poly)) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? Self%&. Self%& self!)
     (proj%vstd!pervasive.ForLoopGhostIteratorNew./GhostIter Self%&. Self%&)
   ))
   :pattern ((vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? Self%&. Self%& self!))
   :qid internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_pre_post_definition
   :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_pre_post_definition
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

;; Function-Specs subtle::impl&%9::from
(declare-fun ens%subtle!impl&%9.from. (Poly Poly) Bool)
(assert
 (forall ((u! Poly) (c! Poly)) (!
   (= (ens%subtle!impl&%9.from. u! c!) (and
     (ens%core!convert.From.from. $ TYPE%subtle!Choice. $ (UINT 8) u! c!)
     (= (= (%I u!) 1) (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.?
       c!
   ))))
   :pattern ((ens%subtle!impl&%9.from. u! c!))
   :qid internal_ens__subtle!impl&__9.from._definition
   :skolemid skolem_internal_ens__subtle!impl&__9.from._definition
)))
(assert
 (forall ((closure%$ Poly) (c$ Poly)) (!
   (=>
    (and
     (has_type closure%$ (TYPE%tuple%1. $ (UINT 8)))
     (has_type c$ TYPE%subtle!Choice.)
    )
    (=>
     (closure_ens (FNDEF%core!convert.From.from. $ TYPE%subtle!Choice. $ (UINT 8)) (DST
       $
      ) (TYPE%tuple%1. $ (UINT 8)) (F fndef_singleton) closure%$ c$
     )
     (let
      ((u$ (%I (tuple%1./tuple%1/0 (%Poly%tuple%1. closure%$)))))
      (= (= u$ 1) (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? c$))
   )))
   :pattern ((closure_ens (FNDEF%core!convert.From.from. $ TYPE%subtle!Choice. $ (UINT 8))
     (DST $) (TYPE%tuple%1. $ (UINT 8)) (F fndef_singleton) closure%$ c$
   ))
   :qid user_subtle__impl&%9__from_70
   :skolemid skolem_user_subtle__impl&%9__from_70
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::subtle_assumes::select
(declare-fun ens%curve25519_dalek!backend.serial.u64.subtle_assumes.select. (Int Int
  subtle!Choice. Int
 ) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! subtle!Choice.) (res! Int)) (!
   (= (ens%curve25519_dalek!backend.serial.u64.subtle_assumes.select. a! b! c! res!)
    (and
     (uInv 64 res!)
     (=>
      (not (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
         c!
      )))
      (= res! a!)
     )
     (=>
      (curve25519_dalek!backend.serial.u64.subtle_assumes.choice_is_true.? (Poly%subtle!Choice.
        c!
      ))
      (= res! b!)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.subtle_assumes.select. a! b! c!
     res!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.select._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.subtle_assumes.select._definition
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

;; Function-Specs curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(declare-fun req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. (Poly Poly)
 Bool
)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((bytes! Poly) (j! Poly)) (!
   (= (req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. bytes! j!) (=>
     %%global_location_label%%19
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

;; Function-Specs curve25519_dalek::core_assumes::zeroize_limbs5
(declare-fun ens%curve25519_dalek!core_assumes.zeroize_limbs5. (%%Function%% %%Function%%)
 Bool
)
(assert
 (forall ((pre%limbs! %%Function%%) (limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.zeroize_limbs5. pre%limbs! limbs!) (and
     (has_type (Poly%array%. limbs!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 5)
         ))
         (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. limbs!)
            ) i$
           )
          ) 0
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) (Poly%array%. limbs!)
         ) i$
       ))
       :qid user_curve25519_dalek__core_assumes__zeroize_limbs5_71
       :skolemid skolem_user_curve25519_dalek__core_assumes__zeroize_limbs5_71
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.zeroize_limbs5. pre%limbs! limbs!))
   :qid internal_ens__curve25519_dalek!core_assumes.zeroize_limbs5._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.zeroize_limbs5._definition
)))

;; Function-Axioms vstd::std_specs::num::u64_specs::wrapping_sub%returns_clause_autospec
(assert
 (fuel_bool_default fuel%vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.)
  (forall ((x! Poly) (y! Poly)) (!
    (= (vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.? x! y!) (ite
      (< (Sub (%I x!) (%I y!)) 0)
      (uClip 64 (Add (Sub (%I x!) (%I y!)) 18446744073709551616))
      (uClip 64 (Sub (%I x!) (%I y!)))
    ))
    :pattern ((vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.? x! y!))
    :qid internal_vstd!std_specs.num.u64_specs.wrapping_sub__returns_clause_autospec.?_definition
    :skolemid skolem_internal_vstd!std_specs.num.u64_specs.wrapping_sub__returns_clause_autospec.?_definition
))))
(assert
 (forall ((x! Poly) (y! Poly)) (!
   (=>
    (and
     (has_type x! (UINT 64))
     (has_type y! (UINT 64))
    )
    (uInv 64 (vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.? x! y!))
   )
   :pattern ((vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.? x! y!))
   :qid internal_vstd!std_specs.num.u64_specs.wrapping_sub__returns_clause_autospec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.num.u64_specs.wrapping_sub__returns_clause_autospec.?_pre_post_definition
)))

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

;; Function-Axioms vstd::std_specs::core::iter_into_iter_spec
(assert
 (fuel_bool_default fuel%vstd!std_specs.core.iter_into_iter_spec.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.core.iter_into_iter_spec.)
  (forall ((I&. Dcr) (I& Type) (i! Poly)) (!
    (= (vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!) i!)
    :pattern ((vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!))
    :qid internal_vstd!std_specs.core.iter_into_iter_spec.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.iter_into_iter_spec.?_definition
))))
(assert
 (forall ((I&. Dcr) (I& Type) (i! Poly)) (!
   (=>
    (has_type i! I&)
    (has_type (vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!) I&)
   )
   :pattern ((vstd!std_specs.core.iter_into_iter_spec.? I&. I& i!))
   :qid internal_vstd!std_specs.core.iter_into_iter_spec.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.core.iter_into_iter_spec.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::range::impl&%3::ghost_iter
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%3.ghost_iter.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%3.ghost_iter.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? $ (TYPE%core!ops.range.Range.
        A&. A&
       ) self!
      ) (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
        (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. self!)) (core!ops.range.Range./Range/start
         (%Poly%core!ops.range.Range. self!)
        ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. self!))
    ))))
    :pattern ((vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? $ (TYPE%core!ops.range.Range.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::exec_invariant
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.exec_invariant.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.exec_invariant.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (exec_iter! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.exec_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self! exec_iter!
      ) (B (and
        (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
          )
         ) (core!ops.range.Range./Range/start (%Poly%core!ops.range.Range. exec_iter!))
        )
        (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
          )
         ) (core!ops.range.Range./Range/end (%Poly%core!ops.range.Range. exec_iter!))
    )))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.exec_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self! exec_iter!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.exec_invariant.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_invariant
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_invariant.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_invariant.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (init! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self! init!
      ) (B (and
        (and
         (or
          (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
             (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
            ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
              self!
          ))))
          (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
         ))))
         (or
          (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
             (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
            ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
              self!
          ))))
          (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
        )))))
        (=>
         (is-core!option.Option./Some (%Poly%core!option.Option. init!))
         (let
          ((init$ (%Poly%vstd!std_specs.range.RangeGhostIterator. (core!option.Option./Some/0 (
               REF $
              ) (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&) (%Poly%core!option.Option.
               init!
          )))))
          (and
           (and
            (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
               (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
              )
             ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
               (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
            )))
            (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
               (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
              )
             ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
               self!
           ))))
           (= (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
              (Poly%vstd!std_specs.range.RangeGhostIterator. init$)
             )
            ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
              self!
    ))))))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self! init!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_invariant.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_ensures
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_ensures.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_ensures.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self!
      ) (B (not (%B (vstd!std_specs.range.StepSpec.spec_is_lt.? A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
           (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
          ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
            self!
    ))))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_ensures.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_decrease
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_decrease.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_decrease.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self!
      ) (Poly%core!option.Option. (core!option.Option./Some (vstd!std_specs.range.StepSpec.spec_steps_between_int.?
         A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
          )
         ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
           self!
    )))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_decrease.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_peek_next
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_peek_next.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_peek_next.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self!
      ) (Poly%core!option.Option. (core!option.Option./Some (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur
         (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
    )))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%4::ghost_advance
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%4.ghost_advance.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%4.ghost_advance.)
  (forall ((A&. Dcr) (A& Type) (self! Poly) (_exec_iter! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!pervasive.ForLoopGhostIterator.ghost_advance.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        A&. A&
       ) self! _exec_iter!
      ) (Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator
        (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
          self!
         )
        ) (core!option.Option./Some/0 A&. A& (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked.?
           A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (I 1)
         ))
        ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/end (%Poly%vstd!std_specs.range.RangeGhostIterator.
          self!
    ))))))
    :pattern ((vstd!pervasive.ForLoopGhostIterator.ghost_advance.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       A&. A&
      ) self! _exec_iter!
    ))
    :qid internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_definition
    :skolemid skolem_internal_vstd!pervasive.ForLoopGhostIterator.ghost_advance.?_definition
))))

;; Function-Axioms vstd::std_specs::range::impl&%5::view
(assert
 (fuel_bool_default fuel%vstd!std_specs.range.impl&%5.view.)
)
(declare-fun %%lambda%%1 (Dcr Type Poly Dcr Type) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Poly) (%%hole%%3 Dcr) (%%hole%%4
    Type
   ) (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4) i$)
    (core!option.Option./Some/0 %%hole%%3 %%hole%%4 (%Poly%core!option.Option. (vstd!std_specs.range.StepSpec.spec_forward_checked_int.?
       %%hole%%0 %%hole%%1 %%hole%%2 i$
   ))))
   :pattern ((%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4)
     i$
)))))
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.range.impl&%5.view.)
  (forall ((A&. Dcr) (A& Type) (self! Poly)) (!
    (=>
     (and
      (sized A&.)
      (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
      (tr_bound%core!iter.range.Step. A&. A&)
     )
     (= (vstd!view.View.view.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&)
       self!
      ) (vstd!seq.Seq.new.? A&. A& $ (TYPE%fun%1. $ INT A&. A&) (I (nClip (%I (vstd!std_specs.range.StepSpec.spec_steps_between_int.?
           A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
            )
           ) (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/cur (%Poly%vstd!std_specs.range.RangeGhostIterator.
             self!
        )))))
       ) (Poly%fun%1. (mk_fun (%%lambda%%1 A&. A& (vstd!std_specs.range.RangeGhostIterator./RangeGhostIterator/start
           (%Poly%vstd!std_specs.range.RangeGhostIterator. self!)
          ) A&. A&
    ))))))
    :pattern ((vstd!view.View.view.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&.
       A&
      ) self!
    ))
    :qid internal_vstd!view.View.view.?_definition
    :skolemid skolem_internal_vstd!view.View.view.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%1::spec_index_set_requires
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%1.spec_index_set_requires.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly) (index! Poly)) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $ (ARRAY T&. T&
        N&. N&
       ) $ USIZE self! index!
      ) (B (let
        ((tmp%%$ (%I index!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (const_int N&))
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $ (ARRAY
       T&. T& N&. N&
      ) $ USIZE self! index!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%1::spec_index_set_ensures
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%1.spec_index_set_ensures.)
  (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (self! Poly) (new_container! Poly)
    (index! Poly) (val! Poly)
   ) (!
    (=>
     (and
      (sized T&.)
      (uInv SZ (const_int N&))
     )
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $ (ARRAY T&. T&
        N&. N&
       ) $ USIZE self! new_container! index! val!
      ) (B (= (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) new_container!) (vstd!seq.Seq.update.?
         T&. T& (vstd!view.View.view.? $ (ARRAY T&. T& N&. N&) self!) index! val!
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $ (ARRAY
       T&. T& N&. N&
      ) $ USIZE self! new_container! index! val!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%3::spec_index_set_requires
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%3.spec_index_set_requires.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (index! Poly)) (!
    (=>
     (sized T&.)
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $slice (SLICE
        T&. T&
       ) $ USIZE self! index!
      ) (B (let
        ((tmp%%$ (%I index!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ (vstd!seq.Seq.len.? T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!)))
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.? $slice
      (SLICE T&. T&) $ USIZE self! index!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_requires.?_definition
))))

;; Function-Axioms vstd::std_specs::slice::impl&%3::spec_index_set_ensures
(assert
 (fuel_bool_default fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.slice.impl&%3.spec_index_set_ensures.)
  (forall ((T&. Dcr) (T& Type) (self! Poly) (new_container! Poly) (index! Poly) (val!
     Poly
    )
   ) (!
    (=>
     (sized T&.)
     (= (vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $slice (SLICE T&.
        T&
       ) $ USIZE self! new_container! index! val!
      ) (B (= (vstd!view.View.view.? $slice (SLICE T&. T&) new_container!) (vstd!seq.Seq.update.?
         T&. T& (vstd!view.View.view.? $slice (SLICE T&. T&) self!) index! val!
    )))))
    :pattern ((vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.? $slice
      (SLICE T&. T&) $ USIZE self! new_container! index! val!
    ))
    :qid internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
    :skolemid skolem_internal_vstd!std_specs.core.IndexSetTrustedSpec.spec_index_set_ensures.?_definition
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
(declare-fun %%lambda%%2 (Dcr Type Poly %%Function%%) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Poly) (%%hole%%3 %%Function%%)
   (i$ Poly)
  ) (!
   (= (%%apply%%0 (%%lambda%%2 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) i$) (%%apply%%1
     %%hole%%3 i$ (vstd!seq.Seq.index.? %%hole%%0 %%hole%%1 %%hole%%2 i$)
   ))
   :pattern ((%%apply%%0 (%%lambda%%2 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) i$))
)))
(assert
 (=>
  (fuel_bool fuel%vstd!seq_lib.impl&%0.map.)
  (forall ((A&. Dcr) (A& Type) (B&. Dcr) (B& Type) (self! Poly) (f! Poly)) (!
    (= (vstd!seq_lib.impl&%0.map.? A&. A& B&. B& self! f!) (vstd!seq.Seq.new.? B&. B& $
      (TYPE%fun%1. $ INT B&. B&) (I (vstd!seq.Seq.len.? A&. A& self!)) (Poly%fun%1. (mk_fun
        (%%lambda%%2 A&. A& self! (%Poly%fun%2. f!))
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

;; Function-Axioms vstd::view::impl&%40::view
(assert
 (fuel_bool_default fuel%vstd!view.impl&%40.view.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!view.impl&%40.view.)
  (forall ((self! Poly)) (!
    (= (vstd!view.View.view.? $ CHAR self!) self!)
    :pattern ((vstd!view.View.view.? $ CHAR self!))
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

;; Function-Axioms curve25519_dalek::backend::serial::u64::scalar::impl&%6::ZERO
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.scalar.impl&%6.ZERO.)
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
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.scalar.impl&%6.ZERO.)
  (= curve25519_dalek!backend.serial.u64.scalar.impl&%6.ZERO.? (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0))))
))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.impl&%6.ZERO.?)
  TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::L
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.L.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.L.)
  (= curve25519_dalek!backend.serial.u64.constants.L.? (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 671914833335277) (I 3916664325105025)
       (I 1367801) (I 0) (I 17592186044416)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.constants.L.?)
  TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::LFACTOR
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.LFACTOR.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.LFACTOR.)
  (= curve25519_dalek!backend.serial.u64.constants.LFACTOR.? 1439961107955227)
))
(assert
 (uInv 64 curve25519_dalek!backend.serial.u64.constants.LFACTOR.?)
)

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::R
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.R.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.R.)
  (= curve25519_dalek!backend.serial.u64.constants.R.? (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 4302102966953709) (I 1049714374468698)
       (I 4503599278581019) (I 4503599627370495) (I 17592186044415)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.constants.R.?)
  TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
))

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::RR
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.RR.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!backend.serial.u64.constants.RR.)
  (= curve25519_dalek!backend.serial.u64.constants.RR.? (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52
    (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I 2764609938444603) (I 3768881411696287)
       (I 1616719297148420) (I 1087343033131391) (I 10175238647962)
)))))))
(assert
 (has_type (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.constants.RR.?)
  TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
))

;; Function-Axioms curve25519_dalek::lemmas::scalar_byte_lemmas::scalar_to_bytes_lemmas::bytes_match_limbs_packing_52
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.scalar_byte_lemmas.scalar_to_bytes_lemmas.bytes_match_limbs_packing_52.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.scalar_byte_lemmas.scalar_to_bytes_lemmas.bytes_match_limbs_packing_52.)
  (forall ((limbs! Poly) (bytes! Poly)) (!
    (= (curve25519_dalek!lemmas.scalar_byte_lemmas.scalar_to_bytes_lemmas.bytes_match_limbs_packing_52.?
      limbs! bytes!
     ) (and
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
                            (and
                             (and
                              (and
                               (and
                                (and
                                 (and
                                  (and
                                   (and
                                    (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                          CONST_INT 32
                                         )
                                        ) bytes!
                                       ) (I 0)
                                      )
                                     ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                            $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                           ) (I 0)
                                         ))
                                        ) (I 0)
                                    ))))
                                    (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                          CONST_INT 32
                                         )
                                        ) bytes!
                                       ) (I 1)
                                      )
                                     ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                            $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                           ) (I 0)
                                         ))
                                        ) (I 8)
                                   )))))
                                   (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                         CONST_INT 32
                                        )
                                       ) bytes!
                                      ) (I 2)
                                     )
                                    ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                           $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                          ) (I 0)
                                        ))
                                       ) (I 16)
                                  )))))
                                  (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                        CONST_INT 32
                                       )
                                      ) bytes!
                                     ) (I 3)
                                    )
                                   ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                          $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                         ) (I 0)
                                       ))
                                      ) (I 24)
                                 )))))
                                 (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                       CONST_INT 32
                                      )
                                     ) bytes!
                                    ) (I 4)
                                   )
                                  ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                         $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                        ) (I 0)
                                      ))
                                     ) (I 32)
                                )))))
                                (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                      CONST_INT 32
                                     )
                                    ) bytes!
                                   ) (I 5)
                                  )
                                 ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                        $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                       ) (I 0)
                                     ))
                                    ) (I 40)
                               )))))
                               (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                     CONST_INT 32
                                    )
                                   ) bytes!
                                  ) (I 6)
                                 )
                                ) (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64)
                                         (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 0)
                                       ))
                                      ) (I 48)
                                    ))
                                   ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                                          (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                         ) (I 1)
                                       ))
                                      ) (I 4)
                              ))))))))
                              (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                    CONST_INT 32
                                   )
                                  ) bytes!
                                 ) (I 7)
                                )
                               ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                      $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                     ) (I 1)
                                   ))
                                  ) (I 4)
                             )))))
                             (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                   CONST_INT 32
                                  )
                                 ) bytes!
                                ) (I 8)
                               )
                              ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                    ) (I 1)
                                  ))
                                 ) (I 12)
                            )))))
                            (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                  CONST_INT 32
                                 )
                                ) bytes!
                               ) (I 9)
                              )
                             ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                   ) (I 1)
                                 ))
                                ) (I 20)
                           )))))
                           (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                 CONST_INT 32
                                )
                               ) bytes!
                              ) (I 10)
                             )
                            ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                  ) (I 1)
                                ))
                               ) (I 28)
                          )))))
                          (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                                CONST_INT 32
                               )
                              ) bytes!
                             ) (I 11)
                            )
                           ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                  $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                 ) (I 1)
                               ))
                              ) (I 36)
                         )))))
                         (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                               CONST_INT 32
                              )
                             ) bytes!
                            ) (I 12)
                           )
                          ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                 $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                                ) (I 1)
                              ))
                             ) (I 44)
                        )))))
                        (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                              CONST_INT 32
                             )
                            ) bytes!
                           ) (I 13)
                          )
                         ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                               ) (I 2)
                             ))
                            ) (I 0)
                       )))))
                       (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                             CONST_INT 32
                            )
                           ) bytes!
                          ) (I 14)
                         )
                        ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                               $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                              ) (I 2)
                            ))
                           ) (I 8)
                      )))))
                      (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                            CONST_INT 32
                           )
                          ) bytes!
                         ) (I 15)
                        )
                       ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                              $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                             ) (I 2)
                           ))
                          ) (I 16)
                     )))))
                     (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                           CONST_INT 32
                          )
                         ) bytes!
                        ) (I 16)
                       )
                      ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                             $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                            ) (I 2)
                          ))
                         ) (I 24)
                    )))))
                    (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                          CONST_INT 32
                         )
                        ) bytes!
                       ) (I 17)
                      )
                     ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                            $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                           ) (I 2)
                         ))
                        ) (I 32)
                   )))))
                   (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                         CONST_INT 32
                        )
                       ) bytes!
                      ) (I 18)
                     )
                    ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                           $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                          ) (I 2)
                        ))
                       ) (I 40)
                  )))))
                  (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                        CONST_INT 32
                       )
                      ) bytes!
                     ) (I 19)
                    )
                   ) (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64)
                            (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 2)
                          ))
                         ) (I 48)
                       ))
                      ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                             (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                            ) (I 3)
                          ))
                         ) (I 4)
                 ))))))))
                 (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                       CONST_INT 32
                      )
                     ) bytes!
                    ) (I 20)
                   )
                  ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                         $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                        ) (I 3)
                      ))
                     ) (I 4)
                )))))
                (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                      CONST_INT 32
                     )
                    ) bytes!
                   ) (I 21)
                  )
                 ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                        $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                       ) (I 3)
                     ))
                    ) (I 12)
               )))))
               (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                     CONST_INT 32
                    )
                   ) bytes!
                  ) (I 22)
                 )
                ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                       $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                      ) (I 3)
                    ))
                   ) (I 20)
              )))))
              (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                    CONST_INT 32
                   )
                  ) bytes!
                 ) (I 23)
                )
               ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                      $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                     ) (I 3)
                   ))
                  ) (I 28)
             )))))
             (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                   CONST_INT 32
                  )
                 ) bytes!
                ) (I 24)
               )
              ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                    ) (I 3)
                  ))
                 ) (I 36)
            )))))
            (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                  CONST_INT 32
                 )
                ) bytes!
               ) (I 25)
              )
             ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                   ) (I 3)
                 ))
                ) (I 44)
           )))))
           (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                 CONST_INT 32
                )
               ) bytes!
              ) (I 26)
             )
            ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                  ) (I 4)
                ))
               ) (I 0)
          )))))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
                CONST_INT 32
               )
              ) bytes!
             ) (I 27)
            )
           ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                  $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                 ) (I 4)
               ))
              ) (I 8)
         )))))
         (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
               CONST_INT 32
              )
             ) bytes!
            ) (I 28)
           )
          ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                 $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
                ) (I 4)
              ))
             ) (I 16)
        )))))
        (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
              CONST_INT 32
             )
            ) bytes!
           ) (I 29)
          )
         ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
               ) (I 4)
             ))
            ) (I 24)
       )))))
       (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
             CONST_INT 32
            )
           ) bytes!
          ) (I 30)
         )
        ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
               $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
              ) (I 4)
            ))
           ) (I 32)
      )))))
      (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
            CONST_INT 32
           )
          ) bytes!
         ) (I 31)
        )
       ) (uClip 8 (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
              $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
             ) (I 4)
           ))
          ) (I 40)
    ))))))
    :pattern ((curve25519_dalek!lemmas.scalar_byte_lemmas.scalar_to_bytes_lemmas.bytes_match_limbs_packing_52.?
      limbs! bytes!
    ))
    :qid internal_curve25519_dalek!lemmas.scalar_byte_lemmas.scalar_to_bytes_lemmas.bytes_match_limbs_packing_52.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.scalar_byte_lemmas.scalar_to_bytes_lemmas.bytes_match_limbs_packing_52.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_part1_chain_lemmas::l0
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.?
      no%param
     ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
         (CONST_INT 5)
        ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
          (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            curve25519_dalek!backend.serial.u64.constants.L.?
        ))))
       ) (I 0)
    )))
    :pattern ((curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.?
      no%param
    ))
    :qid internal_curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.?
      no%param
   )))
   :pattern ((curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.?
     no%param
   ))
   :qid internal_curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part1_chain_lemmas.l0.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::montgomery_radix
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.montgomery_radix.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.montgomery_radix.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? no%param) (vstd!arithmetic.power2.pow2.?
      (I 260)
    ))
    :pattern ((curve25519_dalek!specs.scalar52_specs.montgomery_radix.? no%param))
    :qid internal_curve25519_dalek!specs.scalar52_specs.montgomery_radix.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.montgomery_radix.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? no%param))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.montgomery_radix.? no%param))
   :qid internal_curve25519_dalek!specs.scalar52_specs.montgomery_radix.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.montgomery_radix.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::bytes_as_nat_suffix
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix. Fuel)
(assert
 (forall ((N&. Dcr) (N& Type) (bytes! Poly) (start! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! start!
     fuel%
    ) (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! start!
     zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes!
     start! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix._fuel_to_zero_definition
)))
(assert
 (forall ((N&. Dcr) (N& Type) (bytes! Poly) (start! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (uInv SZ (const_int N&))
     (has_type bytes! (ARRAY $ (UINT 8) N&. N&))
     (has_type start! INT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! start!
      (succ fuel%)
     ) (ite
      (>= (%I start!) (const_int N&))
      0
      (nClip (Add (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 8) N&. N&
             ) bytes!
            ) start!
           )
          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (%I start!) 8))))
         )
        ) (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! (I (Add
           (%I start!) 1
          )
         ) fuel%
   ))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes!
     start! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.)
  (forall ((N&. Dcr) (N& Type) (bytes! Poly) (start! Poly)) (!
    (=>
     (and
      (uInv SZ (const_int N&))
      (has_type bytes! (ARRAY $ (UINT 8) N&. N&))
      (has_type start! INT)
     )
     (= (curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? N&. N& bytes! start!)
      (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! start!
       (succ fuel_nat%curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? N&. N& bytes! start!))
    :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.?_definition
))))
(assert
 (forall ((N&. Dcr) (N& Type) (bytes! Poly) (start! Poly)) (!
   (=>
    (and
     (has_type bytes! (ARRAY $ (UINT 8) N&. N&))
     (has_type start! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? N&. N& bytes! start!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.? N&. N& bytes! start!))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_as_nat_suffix.?_pre_post_definition
)))
(assert
 (forall ((N&. Dcr) (N& Type) (bytes! Poly) (start! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (ARRAY $ (UINT 8) N&. N&))
     (has_type start! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes! start!
      fuel%
   )))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_as_nat_suffix.? N&. N& bytes!
     start! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.rec__bytes_as_nat_suffix.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__bytes_as_nat_suffix.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::spec_load8_at
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.spec_load8_at.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.spec_load8_at.)
  (forall ((input! Poly) (i! Poly)) (!
    (= (curve25519_dalek!specs.core_specs.spec_load8_at.? input! i!) (nClip (Add (Add (Add
         (Add (Add (Add (Add (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 0 8)))) (%I (vstd!seq.Seq.index.?
                $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
                  0
              ))))
             ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 1 8)))) (%I (vstd!seq.Seq.index.?
                $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
                  1
             )))))
            ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 2 8)))) (%I (vstd!seq.Seq.index.?
               $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
                 2
            )))))
           ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 3 8)))) (%I (vstd!seq.Seq.index.?
              $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
                3
           )))))
          ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 4 8)))) (%I (vstd!seq.Seq.index.?
             $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
               4
          )))))
         ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 5 8)))) (%I (vstd!seq.Seq.index.?
            $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
              5
         )))))
        ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 6 8)))) (%I (vstd!seq.Seq.index.?
           $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
             6
        )))))
       ) (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 7 8)))) (%I (vstd!seq.Seq.index.?
          $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) input!) (I (Add (%I i!)
            7
    ))))))))
    :pattern ((curve25519_dalek!specs.core_specs.spec_load8_at.? input! i!))
    :qid internal_curve25519_dalek!specs.core_specs.spec_load8_at.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.spec_load8_at.?_definition
))))
(assert
 (forall ((input! Poly) (i! Poly)) (!
   (=>
    (and
     (has_type input! (SLICE $ (UINT 8)))
     (has_type i! USIZE)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.spec_load8_at.? input! i!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.spec_load8_at.? input! i!))
   :qid internal_curve25519_dalek!specs.core_specs.spec_load8_at.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.spec_load8_at.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::bytes_seq_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.bytes_seq_as_nat.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.bytes_seq_as_nat. Fuel)
(assert
 (forall ((bytes! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! fuel%) (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.?
     bytes! zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat._fuel_to_zero_definition
)))
(assert
 (forall ((bytes! Poly) (fuel% Fuel)) (!
   (=>
    (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (= (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! (succ fuel%))
     (ite
      (= (vstd!seq.Seq.len.? $ (UINT 8) bytes!) 0)
      0
      (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I 0))) (nClip (Mul (vstd!arithmetic.power2.pow2.?
           (I 8)
          ) (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? (vstd!seq.Seq.subrange.?
            $ (UINT 8) bytes! (I 1) (I (vstd!seq.Seq.len.? $ (UINT 8) bytes!))
           ) fuel%
   ))))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! (succ fuel%)))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.bytes_seq_as_nat.)
  (forall ((bytes! Poly)) (!
    (=>
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (= (curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? bytes!) (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.?
       bytes! (succ fuel_nat%curve25519_dalek!specs.core_specs.bytes_seq_as_nat.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? bytes!))
    :qid internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat.?_definition
))))
(assert
 (forall ((bytes! Poly)) (!
   (=>
    (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (<= 0 (curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? bytes!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.bytes_seq_as_nat.? bytes!))
   :qid internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.bytes_seq_as_nat.?_pre_post_definition
)))
(assert
 (forall ((bytes! Poly) (fuel% Fuel)) (!
   (=>
    (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (<= 0 (curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! fuel%))
   )
   :pattern ((curve25519_dalek!specs.core_specs.rec%bytes_seq_as_nat.? bytes! fuel%))
   :qid internal_curve25519_dalek!specs.core_specs.rec__bytes_seq_as_nat.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__bytes_seq_as_nat.?_pre_post_rec_definition
)))

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
(declare-fun %%lambda%%3 () %%Function%%)
(assert
 (forall ((i$ Poly) (x$ Poly)) (!
   (= (%%apply%%1 %%lambda%%3 i$ x$) x$)
   :pattern ((%%apply%%1 %%lambda%%3 i$ x$))
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.words_as_nat_u64.)
  (forall ((words! Poly) (num_words! Poly) (bits_per_word! Poly)) (!
    (= (curve25519_dalek!specs.core_specs.words_as_nat_u64.? words! num_words! bits_per_word!)
     (curve25519_dalek!specs.core_specs.words_as_nat_gen.? (vstd!seq_lib.impl&%0.map.? $
       (UINT 64) $ NAT (vstd!view.View.view.? $slice (SLICE $ (UINT 64)) words!) (Poly%fun%2.
        (mk_fun %%lambda%%3)
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

;; Function-Axioms curve25519_dalek::specs::core_specs::word64_from_bytes
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.word64_from_bytes.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.word64_from_bytes.)
  (forall ((bytes! Poly) (word_idx! Poly)) (!
    (= (curve25519_dalek!specs.core_specs.word64_from_bytes.? bytes! word_idx!) (let
      ((num_words$ (EucDiv (vstd!seq.Seq.len.? $ (UINT 8) bytes!) 8)))
      (ite
       (not (and
         (<= 0 (%I word_idx!))
         (< (%I word_idx!) num_words$)
       ))
       0
       (let
        ((base$ (Mul (%I word_idx!) 8)))
        (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Mul (
                         %I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 0)))
                        ) (vstd!arithmetic.power2.pow2.? (I 0))
                       )
                      ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 1)))) (vstd!arithmetic.power2.pow2.?
                         (I 8)
                     ))))
                    ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 2)))) (vstd!arithmetic.power2.pow2.?
                       (I 16)
                   ))))
                  ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 3)))) (vstd!arithmetic.power2.pow2.?
                     (I 24)
                 ))))
                ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 4)))) (vstd!arithmetic.power2.pow2.?
                   (I 32)
               ))))
              ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 5)))) (vstd!arithmetic.power2.pow2.?
                 (I 40)
             ))))
            ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 6)))) (vstd!arithmetic.power2.pow2.?
               (I 48)
           ))))
          ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add base$ 7)))) (vstd!arithmetic.power2.pow2.?
             (I 56)
    )))))))))
    :pattern ((curve25519_dalek!specs.core_specs.word64_from_bytes.? bytes! word_idx!))
    :qid internal_curve25519_dalek!specs.core_specs.word64_from_bytes.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.word64_from_bytes.?_definition
))))
(assert
 (forall ((bytes! Poly) (word_idx! Poly)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type word_idx! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.word64_from_bytes.? bytes! word_idx!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.word64_from_bytes.? bytes! word_idx!))
   :qid internal_curve25519_dalek!specs.core_specs.word64_from_bytes.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.word64_from_bytes.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::word64_from_bytes_partial
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.word64_from_bytes_partial.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.word64_from_bytes_partial.
 Fuel
)
(assert
 (forall ((bytes! Poly) (word_idx! Poly) (upto! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%word64_from_bytes_partial.? bytes! word_idx!
     upto! fuel%
    ) (curve25519_dalek!specs.core_specs.rec%word64_from_bytes_partial.? bytes! word_idx!
     upto! zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%word64_from_bytes_partial.? bytes!
     word_idx! upto! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.word64_from_bytes_partial._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.word64_from_bytes_partial._fuel_to_zero_definition
)))
(assert
 (forall ((bytes! Poly) (word_idx! Poly) (upto! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type word_idx! INT)
     (has_type upto! INT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%word64_from_bytes_partial.? bytes! word_idx!
      upto! (succ fuel%)
     ) (let
      ((num_words$ (EucDiv (vstd!seq.Seq.len.? $ (UINT 8) bytes!) 8)))
      (ite
       (not (and
         (<= 0 (%I word_idx!))
         (< (%I word_idx!) num_words$)
       ))
       0
       (ite
        (<= (%I upto!) 0)
        0
        (ite
         (>= (%I upto!) 8)
         (curve25519_dalek!specs.core_specs.word64_from_bytes.? bytes! word_idx!)
         (let
          ((j$ (Sub (%I upto!) 1)))
          (nClip (Add (curve25519_dalek!specs.core_specs.rec%word64_from_bytes_partial.? bytes!
             word_idx! (I j$) fuel%
            ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) bytes! (I (Add (Mul (%I word_idx!) 8)
                  j$
               )))
              ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul j$ 8))))
   )))))))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%word64_from_bytes_partial.? bytes!
     word_idx! upto! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.core_specs.word64_from_bytes_partial._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.word64_from_bytes_partial._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.word64_from_bytes_partial.)
  (forall ((bytes! Poly) (word_idx! Poly) (upto! Poly)) (!
    (=>
     (and
      (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
      (has_type word_idx! INT)
      (has_type upto! INT)
     )
     (= (curve25519_dalek!specs.core_specs.word64_from_bytes_partial.? bytes! word_idx!
       upto!
      ) (curve25519_dalek!specs.core_specs.rec%word64_from_bytes_partial.? bytes! word_idx!
       upto! (succ fuel_nat%curve25519_dalek!specs.core_specs.word64_from_bytes_partial.)
    )))
    :pattern ((curve25519_dalek!specs.core_specs.word64_from_bytes_partial.? bytes! word_idx!
      upto!
    ))
    :qid internal_curve25519_dalek!specs.core_specs.word64_from_bytes_partial.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.word64_from_bytes_partial.?_definition
))))
(assert
 (forall ((bytes! Poly) (word_idx! Poly) (upto! Poly)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type word_idx! INT)
     (has_type upto! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.word64_from_bytes_partial.? bytes! word_idx!
      upto!
   )))
   :pattern ((curve25519_dalek!specs.core_specs.word64_from_bytes_partial.? bytes! word_idx!
     upto!
   ))
   :qid internal_curve25519_dalek!specs.core_specs.word64_from_bytes_partial.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.word64_from_bytes_partial.?_pre_post_definition
)))
(assert
 (forall ((bytes! Poly) (word_idx! Poly) (upto! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type word_idx! INT)
     (has_type upto! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%word64_from_bytes_partial.? bytes! word_idx!
      upto! fuel%
   )))
   :pattern ((curve25519_dalek!specs.core_specs.rec%word64_from_bytes_partial.? bytes!
     word_idx! upto! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.rec__word64_from_bytes_partial.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__word64_from_bytes_partial.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::specs::core_specs::words64_from_bytes_to_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.)
)
(declare-const fuel_nat%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.
 Fuel
)
(assert
 (forall ((bytes! Poly) (count! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! count!
     fuel%
    ) (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! count!
     zero
   ))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes!
     count! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat._fuel_to_zero_definition
)))
(assert
 (forall ((bytes! Poly) (count! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type count! INT)
    )
    (= (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! count!
      (succ fuel%)
     ) (let
      ((num_words$ (EucDiv (vstd!seq.Seq.len.? $ (UINT 8) bytes!) 8)))
      (ite
       (<= (%I count!) 0)
       0
       (ite
        (> (%I count!) num_words$)
        (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! (I num_words$)
         fuel%
        )
        (let
         ((idx$ (Sub (%I count!) 1)))
         (nClip (Add (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes!
            (I idx$) fuel%
           ) (nClip (Mul (curve25519_dalek!specs.core_specs.word64_from_bytes.? bytes! (I idx$))
             (vstd!arithmetic.power2.pow2.? (I (nClip (Mul idx$ 64))))
   ))))))))))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes!
     count! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.)
  (forall ((bytes! Poly) (count! Poly)) (!
    (=>
     (and
      (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
      (has_type count! INT)
     )
     (= (curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? bytes! count!) (
       curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! count! (
        succ fuel_nat%curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.
    ))))
    :pattern ((curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? bytes! count!))
    :qid internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.?_definition
))))
(assert
 (forall ((bytes! Poly) (count! Poly)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type count! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? bytes! count!))
   )
   :pattern ((curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.? bytes! count!))
   :qid internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.words64_from_bytes_to_nat.?_pre_post_definition
)))
(assert
 (forall ((bytes! Poly) (count! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type bytes! (TYPE%vstd!seq.Seq. $ (UINT 8)))
     (has_type count! INT)
    )
    (<= 0 (curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes! count!
      fuel%
   )))
   :pattern ((curve25519_dalek!specs.core_specs.rec%words64_from_bytes_to_nat.? bytes!
     count! fuel%
   ))
   :qid internal_curve25519_dalek!specs.core_specs.rec__words64_from_bytes_to_nat.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!specs.core_specs.rec__words64_from_bytes_to_nat.?_pre_post_rec_definition
)))

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

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::slice128_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.slice128_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.slice128_as_nat.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? limbs!) (curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.?
      (vstd!seq_lib.impl&%0.map.? $ (UINT 128) $ NAT (vstd!view.View.view.? $slice (SLICE
         $ (UINT 128)
        ) limbs!
       ) (Poly%fun%2. (mk_fun %%lambda%%3))
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? limbs!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.slice128_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.slice128_as_nat.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (SLICE $ (UINT 128)))
    (<= 0 (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? limbs!))
   :qid internal_curve25519_dalek!specs.scalar52_specs.slice128_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.slice128_as_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::seq_u64_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? limbs!) (curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.?
      (vstd!seq_lib.impl&%0.map.? $ (UINT 64) $ NAT limbs! (Poly%fun%2. (mk_fun %%lambda%%3)))
    ))
    :pattern ((curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? limbs!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (TYPE%vstd!seq.Seq. $ (UINT 64)))
    (<= 0 (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? limbs!))
   :qid internal_curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.?_pre_post_definition
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
       ) (Poly%fun%2. (mk_fun %%lambda%%3))
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

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::scalar52_as_canonical_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.)
  (forall ((s! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.? s!) (curve25519_dalek!specs.scalar52_specs.group_canonical.?
      (I (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? s!))
    ))
    :pattern ((curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.? s!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.?_definition
))))
(assert
 (forall ((s! Poly)) (!
   (=>
    (has_type s! TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
    (<= 0 (curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.? s!))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.? s!))
   :qid internal_curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.scalar52_as_canonical_nat.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::five_limbs_to_nat_aux
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.? limbs!) (nClip (Add
       (nClip (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!
               ) (I 0)
              )
             ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 52)) (%I (vstd!seq.Seq.index.? $ (UINT
                  64
                 ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 1)
            )))))
           ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 104)) (%I (vstd!seq.Seq.index.? $ (UINT
                64
               ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 2)
          )))))
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 156)) (%I (vstd!seq.Seq.index.? $ (UINT
              64
             ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 3)
        )))))
       ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 208)) (%I (vstd!seq.Seq.index.? $ (UINT
            64
           ) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) limbs!) (I 4)
    )))))))
    :pattern ((curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.? limbs!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (<= 0 (curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.? limbs!))
   :qid internal_curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::five_u64_limbs_to_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.)
  (forall ((n0! Poly) (n1! Poly) (n2! Poly) (n3! Poly) (n4! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.? n0! n1! n2! n3! n4!)
     (nClip (Add (nClip (Add (nClip (Add (nClip (Add (%I n0!) (nClip (Mul (%I n1!) (vstd!arithmetic.power2.pow2.?
                (I 52)
            ))))
           ) (nClip (Mul (%I n2!) (vstd!arithmetic.power2.pow2.? (I 104))))
          )
         ) (nClip (Mul (%I n3!) (vstd!arithmetic.power2.pow2.? (I 156))))
        )
       ) (nClip (Mul (%I n4!) (vstd!arithmetic.power2.pow2.? (I 208))))
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.? n0! n1! n2!
      n3! n4!
    ))
    :qid internal_curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.?_definition
))))
(assert
 (forall ((n0! Poly) (n1! Poly) (n2! Poly) (n3! Poly) (n4! Poly)) (!
   (=>
    (and
     (has_type n0! (UINT 64))
     (has_type n1! (UINT 64))
     (has_type n2! (UINT 64))
     (has_type n3! (UINT 64))
     (has_type n4! (UINT 64))
    )
    (<= 0 (curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.? n0! n1! n2! n3!
      n4!
   )))
   :pattern ((curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.? n0! n1! n2!
     n3! n4!
   ))
   :qid internal_curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.?_pre_post_definition
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
       :qid user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_72
       :skolemid skolem_user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_72
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.limbs_bounded.? s!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.limbs_bounded.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::limbs_bounded_for_sub
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub.? a! b!) (and
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 4)
          ))
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
              ))
             ) i$
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
           ))
          ) i$
        ))
        :qid user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_for_sub_73
        :skolemid skolem_user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_for_sub_73
      ))
      (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
          ))
         ) (I 4)
        )
       ) (Add (uClip 64 (bitshl (I 1) (I 52))) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
           $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
           ))
          ) (I 4)
    ))))))
    :pattern ((curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub.? a! b!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::limb_prod_bounded_u128
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.)
  (forall ((limbs1! Poly) (limbs2! Poly) (k! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.? limbs1! limbs2!
      k!
     ) (forall ((i$ Poly) (j$ Poly)) (!
       (=>
        (and
         (has_type i$ INT)
         (has_type j$ INT)
        )
        (=>
         (and
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 5)
          ))
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 5)
         )))
         (<= (Mul (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                 64
                ) $ (CONST_INT 5)
               ) limbs1!
              ) i$
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) limbs2!
              ) j$
            ))
           ) (%I k!)
          ) 340282366920938463463374607431768211455
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
           $ (CONST_INT 5)
          ) limbs1!
         ) i$
        ) (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT
            5
           )
          ) limbs2!
         ) j$
       ))
       :qid user_curve25519_dalek__specs__scalar52_specs__limb_prod_bounded_u128_74
       :skolemid skolem_user_curve25519_dalek__specs__scalar52_specs__limb_prod_bounded_u128_74
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.? limbs1! limbs2!
      k!
    ))
    :qid internal_curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::is_canonical_scalar52
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.is_canonical_scalar52.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.is_canonical_scalar52.)
  (forall ((s! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.is_canonical_scalar52.? s!) (and
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? s!)
      (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? s!) (curve25519_dalek!specs.scalar52_specs.group_order.?
        (I 0)
    ))))
    :pattern ((curve25519_dalek!specs.scalar52_specs.is_canonical_scalar52.? s!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.is_canonical_scalar52.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.is_canonical_scalar52.?_definition
))))

;; Function-Specs curve25519_dalek::specs::scalar52_specs::spec_mul_internal
(declare-fun req%curve25519_dalek!specs.scalar52_specs.spec_mul_internal. (Poly Poly)
 Bool
)
(declare-const %%global_location_label%%20 Bool)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (= (req%curve25519_dalek!specs.scalar52_specs.spec_mul_internal. a! b!) (and
     (=>
      %%global_location_label%%20
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? a!)
     )
     (=>
      %%global_location_label%%21
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? b!)
   )))
   :pattern ((req%curve25519_dalek!specs.scalar52_specs.spec_mul_internal. a! b!))
   :qid internal_req__curve25519_dalek!specs.scalar52_specs.spec_mul_internal._definition
   :skolemid skolem_internal_req__curve25519_dalek!specs.scalar52_specs.spec_mul_internal._definition
)))

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::spec_mul_internal
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.spec_mul_internal.)
)
(declare-fun %%array%%1 (Poly Poly Poly Poly Poly Poly Poly Poly Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   ) (%%hole%%5 Poly) (%%hole%%6 Poly) (%%hole%%7 Poly) (%%hole%%8 Poly)
  ) (!
   (let
    ((%%x%% (%%array%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
       %%hole%%7 %%hole%%8
    )))
    (and
     (= (%%apply%%2 %%x%% 0) %%hole%%0)
     (= (%%apply%%2 %%x%% 1) %%hole%%1)
     (= (%%apply%%2 %%x%% 2) %%hole%%2)
     (= (%%apply%%2 %%x%% 3) %%hole%%3)
     (= (%%apply%%2 %%x%% 4) %%hole%%4)
     (= (%%apply%%2 %%x%% 5) %%hole%%5)
     (= (%%apply%%2 %%x%% 6) %%hole%%6)
     (= (%%apply%%2 %%x%% 7) %%hole%%7)
     (= (%%apply%%2 %%x%% 8) %%hole%%8)
   ))
   :pattern ((%%array%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
     %%hole%%7 %%hole%%8
   ))
   :qid __AIR_ARRAY_QID__
   :skolemid skolem___AIR_ARRAY_QID__
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.spec_mul_internal.)
  (forall ((a! Poly) (b! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.spec_mul_internal.? a! b!) (%Poly%array%.
      (array_new $ (UINT 128) 9 (%%array%%1 (I (uClip 128 (Mul (uClip 128 (%I (vstd!seq.Seq.index.?
              $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
                (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  a!
               )))
              ) (I 0)
            ))
           ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                 UINT 64
                ) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
               ))
              ) (I 0)
         )))))
        ) (I (uClip 128 (Add (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                ))
               ) (I 0)
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                ))
               ) (I 1)
            )))
           ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                ))
               ) (I 1)
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                ))
               ) (I 0)
         ))))))
        ) (I (uClip 128 (Add (Add (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                 $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                 ))
                ) (I 0)
              ))
             ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                   UINT 64
                  ) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                 ))
                ) (I 2)
             )))
            ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                 ))
                ) (I 1)
              ))
             ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                   UINT 64
                  ) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                 ))
                ) (I 1)
            ))))
           ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                ))
               ) (I 2)
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                ))
               ) (I 0)
         ))))))
        ) (I (uClip 128 (Add (Add (Add (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                  $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                  ))
                 ) (I 0)
               ))
              ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                    UINT 64
                   ) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                  ))
                 ) (I 3)
              )))
             ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                   $ (UINT 64) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                  ))
                 ) (I 1)
               ))
              ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                    UINT 64
                   ) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                  ))
                 ) (I 2)
             ))))
            ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                 ))
                ) (I 2)
              ))
             ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                   UINT 64
                  ) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                 ))
                ) (I 1)
            ))))
           ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                ))
               ) (I 3)
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                ))
               ) (I 0)
         ))))))
        ) (I (uClip 128 (Add (Add (Add (Add (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (
                   vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                     (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                   ))
                  ) (I 0)
                ))
               ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                     UINT 64
                    ) $ (CONST_INT 5)
                   ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                     (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                   ))
                  ) (I 4)
               )))
              ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                    $ (UINT 64) $ (CONST_INT 5)
                   ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                     (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                   ))
                  ) (I 1)
                ))
               ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                     UINT 64
                    ) $ (CONST_INT 5)
                   ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                     (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                   ))
                  ) (I 3)
              ))))
             ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                   $ (UINT 64) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                  ))
                 ) (I 2)
               ))
              ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                    UINT 64
                   ) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                  ))
                 ) (I 2)
             ))))
            ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                 ))
                ) (I 3)
              ))
             ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                   UINT 64
                  ) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                 ))
                ) (I 1)
            ))))
           ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                ))
               ) (I 4)
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                ))
               ) (I 0)
         ))))))
        ) (I (uClip 128 (Add (Add (Add (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                  $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                  ))
                 ) (I 1)
               ))
              ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                    UINT 64
                   ) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                  ))
                 ) (I 4)
              )))
             ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                   $ (UINT 64) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                  ))
                 ) (I 2)
               ))
              ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                    UINT 64
                   ) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                  ))
                 ) (I 3)
             ))))
            ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                 ))
                ) (I 3)
              ))
             ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                   UINT 64
                  ) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                 ))
                ) (I 2)
            ))))
           ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                ))
               ) (I 4)
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                ))
               ) (I 1)
         ))))))
        ) (I (uClip 128 (Add (Add (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                 $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                 ))
                ) (I 2)
              ))
             ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                   UINT 64
                  ) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                 ))
                ) (I 4)
             )))
            ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                 ))
                ) (I 3)
              ))
             ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                   UINT 64
                  ) $ (CONST_INT 5)
                 ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                   (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                 ))
                ) (I 3)
            ))))
           ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                ))
               ) (I 4)
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                ))
               ) (I 2)
         ))))))
        ) (I (uClip 128 (Add (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                ))
               ) (I 3)
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                ))
               ) (I 4)
            )))
           ) (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
                ))
               ) (I 4)
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
                ))
               ) (I 3)
         ))))))
        ) (I (uClip 128 (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
               $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
               ))
              ) (I 4)
            ))
           ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                 UINT 64
                ) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
               ))
              ) (I 4)
    ))))))))))
    :pattern ((curve25519_dalek!specs.scalar52_specs.spec_mul_internal.? a! b!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.spec_mul_internal.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.spec_mul_internal.?_definition
))))
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (=>
    (and
     (has_type a! TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
     (has_type b! TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
    )
    (has_type (Poly%array%. (curve25519_dalek!specs.scalar52_specs.spec_mul_internal.? a!
       b!
      )
     ) (ARRAY $ (UINT 128) $ (CONST_INT 9))
   ))
   :pattern ((curve25519_dalek!specs.scalar52_specs.spec_mul_internal.? a! b!))
   :qid internal_curve25519_dalek!specs.scalar52_specs.spec_mul_internal.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.spec_mul_internal.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::montgomery_reduce_specs::montgomery_reduce_input_bounds
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.?
      limbs!
     ) (and
      (and
       (and
        (and
         (and
          (and
           (and
            (and
             (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
                  $ (CONST_INT 9)
                 ) limbs!
                ) (I 0)
               )
              ) (vstd!arithmetic.power2.pow2.? (I 104))
             )
             (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
                  $ (CONST_INT 9)
                 ) limbs!
                ) (I 1)
               )
              ) (vstd!arithmetic.power2.pow2.? (I 105))
            ))
            (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
                 $ (CONST_INT 9)
                ) limbs!
               ) (I 2)
              )
             ) (vstd!arithmetic.power2.pow2.? (I 106))
           ))
           (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
                $ (CONST_INT 9)
               ) limbs!
              ) (I 3)
             )
            ) (vstd!arithmetic.power2.pow2.? (I 107))
          ))
          (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
               $ (CONST_INT 9)
              ) limbs!
             ) (I 4)
            )
           ) (vstd!arithmetic.power2.pow2.? (I 107))
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
              $ (CONST_INT 9)
             ) limbs!
            ) (I 5)
           )
          ) (vstd!arithmetic.power2.pow2.? (I 107))
        ))
        (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
             $ (CONST_INT 9)
            ) limbs!
           ) (I 6)
          )
         ) (vstd!arithmetic.power2.pow2.? (I 106))
       ))
       (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
            $ (CONST_INT 9)
           ) limbs!
          ) (I 7)
         )
        ) (vstd!arithmetic.power2.pow2.? (I 105))
      ))
      (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) limbs!
         ) (I 8)
        )
       ) (vstd!arithmetic.power2.pow2.? (I 104))
    )))
    :pattern ((curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.?
      limbs!
    ))
    :qid internal_curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::montgomery_reduce_specs::montgomery_reduce_canonical_bound
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.?
      limbs!
     ) (< (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (vstd!array.spec_array_as_slice.?
        $ (UINT 128) $ (CONST_INT 9) limbs!
       )
      ) (nClip (Mul (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0)) (curve25519_dalek!specs.scalar52_specs.group_order.?
         (I 0)
    )))))
    :pattern ((curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.?
      limbs!
    ))
    :qid internal_curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.?_definition
))))

;; Function-Axioms curve25519_dalek::specs::montgomery_reduce_specs::montgomery_congruent
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_congruent.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.montgomery_reduce_specs.montgomery_congruent.)
  (forall ((result! Poly) (limbs! Poly)) (!
    (= (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_congruent.? result! limbs!)
     (= (EucMod (nClip (Mul (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? result!)
         (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0))
        )
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
      ) (EucMod (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (vstd!array.spec_array_as_slice.?
         $ (UINT 128) $ (CONST_INT 9) limbs!
        )
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
    )))
    :pattern ((curve25519_dalek!specs.montgomery_reduce_specs.montgomery_congruent.? result!
      limbs!
    ))
    :qid internal_curve25519_dalek!specs.montgomery_reduce_specs.montgomery_congruent.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.montgomery_reduce_specs.montgomery_congruent.?_definition
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
 (tr_bound%vstd!view.View. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%vstd!view.View. $ CHAR)
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
 (tr_bound%core!cmp.PartialEq. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 8) $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 16) $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 32) $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (SINT 32) $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 64) $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ (UINT 128) $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ USIZE $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ USIZE $ USIZE)
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
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
    )
    (tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. $ (TYPE%core!ops.range.Range. A&.
      A&
   )))
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIteratorNew. $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_vstd__std_specs__range__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__range__impl&__3_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
     (tr_bound%core!iter.range.Step. A&. A&)
    )
    (tr_bound%vstd!pervasive.ForLoopGhostIterator. $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :pattern ((tr_bound%vstd!pervasive.ForLoopGhostIterator. $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_vstd__std_specs__range__impl&__4_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__range__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%vstd!std_specs.range.StepSpec. A&. A&)
     (tr_bound%core!iter.range.Step. A&. A&)
    )
    (tr_bound%vstd!view.View. $ (TYPE%vstd!std_specs.range.RangeGhostIterator. A&. A&))
   )
   :pattern ((tr_bound%vstd!view.View. $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
      A&. A&
   )))
   :qid internal_vstd__std_specs__range__impl&__5_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__range__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!std_specs.core.TrustedSpecSealed. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%vstd!std_specs.core.TrustedSpecSealed. $ (ARRAY T&. T& N&. N&)))
   :qid internal_vstd__std_specs__slice__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!ops.index.Index. $slice (SLICE T&. T&) I&. I&)
    )
    (tr_bound%core!ops.index.Index. $ (ARRAY T&. T& N&. N&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.Index. $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_core__array__impl&__15_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__15_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!ops.index.IndexMut. $slice (SLICE T&. T&) I&. I&)
    )
    (tr_bound%core!ops.index.IndexMut. $ (ARRAY T&. T& N&. N&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. $ (ARRAY T&. T& N&. N&) I&. I&))
   :qid internal_core__array__impl&__16_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__16_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice (SLICE T&. T&))
    )
    (tr_bound%core!ops.index.Index. $slice (SLICE T&. T&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.Index. $slice (SLICE T&. T&) I&. I&))
   :qid internal_core__slice__index__impl&__0_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__0_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice (SLICE T&. T&))
    )
    (tr_bound%core!ops.index.IndexMut. $slice (SLICE T&. T&) I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. $slice (SLICE T&. T&) I&. I&))
   :qid internal_core__slice__index__impl&__1_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!slice.index.SliceIndex. $ USIZE $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!slice.index.SliceIndex. $ USIZE $slice (SLICE T&. T&)))
   :qid internal_core__slice__index__impl&__2_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
    )
    (tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $ (ARRAY T&. T& N&. N&) $ USIZE)
   )
   :pattern ((tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $ (ARRAY T&. T& N&. N&)
     $ USIZE
   ))
   :qid internal_vstd__std_specs__slice__impl&__1_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__1_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!std_specs.core.TrustedSpecSealed. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%vstd!std_specs.core.TrustedSpecSealed. $slice (SLICE T&. T&)))
   :qid internal_vstd__std_specs__slice__impl&__2_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__2_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $slice (SLICE T&. T&) $ USIZE)
   )
   :pattern ((tr_bound%vstd!std_specs.core.IndexSetTrustedSpec. $slice (SLICE T&. T&)
     $ USIZE
   ))
   :qid internal_vstd__std_specs__slice__impl&__3_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__slice__impl&__3_trait_impl_definition
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
 (tr_bound%core!clone.Clone. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!clone.Clone. $ CHAR)
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
 (forall ((Idx&. Dcr) (Idx& Type)) (!
   (=>
    (and
     (sized Idx&.)
     (tr_bound%core!clone.Clone. Idx&. Idx&)
    )
    (tr_bound%core!clone.Clone. $ (TYPE%core!ops.range.Range. Idx&. Idx&))
   )
   :pattern ((tr_bound%core!clone.Clone. $ (TYPE%core!ops.range.Range. Idx&. Idx&)))
   :qid internal_core__ops__range__impl&__46_trait_impl_definition
   :skolemid skolem_internal_core__ops__range__impl&__46_trait_impl_definition
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
 (tr_bound%core!cmp.PartialEq. $slice STRSLICE $slice STRSLICE)
)

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
 (tr_bound%core!cmp.PartialEq. $ TYPE%tuple%0. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialEq. $ CHAR $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((Idx&. Dcr) (Idx& Type)) (!
   (=>
    (and
     (sized Idx&.)
     (tr_bound%core!cmp.PartialEq. Idx&. Idx& Idx&. Idx&)
    )
    (tr_bound%core!cmp.PartialEq. $ (TYPE%core!ops.range.Range. Idx&. Idx&) $ (TYPE%core!ops.range.Range.
      Idx&. Idx&
   )))
   :pattern ((tr_bound%core!cmp.PartialEq. $ (TYPE%core!ops.range.Range. Idx&. Idx&) $
     (TYPE%core!ops.range.Range. Idx&. Idx&)
   ))
   :qid internal_core__ops__range__impl&__49_trait_impl_definition
   :skolemid skolem_internal_core__ops__range__impl&__49_trait_impl_definition
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
   (tr_bound%core!cmp.PartialOrd. $ (PTR T&. T&) $ (PTR T&. T&))
   :pattern ((tr_bound%core!cmp.PartialOrd. $ (PTR T&. T&) $ (PTR T&. T&)))
   :qid internal_core__ptr__mut_ptr__impl&__9_trait_impl_definition
   :skolemid skolem_internal_core__ptr__mut_ptr__impl&__9_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ TYPE%tuple%0. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ BOOL $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!cmp.PartialOrd. $ CHAR $ CHAR)
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
 (tr_bound%core!cmp.PartialOrd. $slice STRSLICE $slice STRSLICE)
)

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
 (tr_bound%core!convert.From. $ (UINT 32) $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 64) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 64) $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 128) $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (UINT 128) $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!convert.From. $ (SINT 32) $ BOOL)
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
 (tr_bound%core!convert.From. $ CHAR $ (UINT 8))
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
 (forall ((I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice STRSLICE)
    )
    (tr_bound%core!ops.index.Index. $slice STRSLICE I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.Index. $slice STRSLICE I&. I&))
   :qid internal_core__str__traits__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__str__traits__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((I&. Dcr) (I& Type)) (!
   (=>
    (and
     (sized I&.)
     (tr_bound%core!slice.index.SliceIndex. I&. I& $slice STRSLICE)
    )
    (tr_bound%core!ops.index.IndexMut. $slice STRSLICE I&. I&)
   )
   :pattern ((tr_bound%core!ops.index.IndexMut. $slice STRSLICE I&. I&))
   :qid internal_core__str__traits__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__str__traits__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!iter.range.Step. $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((A&. Dcr) (A& Type)) (!
   (=>
    (and
     (sized A&.)
     (tr_bound%core!iter.range.Step. A&. A&)
    )
    (tr_bound%core!iter.traits.iterator.Iterator. $ (TYPE%core!ops.range.Range. A&. A&))
   )
   :pattern ((tr_bound%core!iter.traits.iterator.Iterator. $ (TYPE%core!ops.range.Range.
      A&. A&
   )))
   :qid internal_core__iter__range__impl&__6_trait_impl_definition
   :skolemid skolem_internal_core__iter__range__impl&__6_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (sized T&.)
    (tr_bound%core!slice.index.SliceIndex. $ (TYPE%core!ops.range.Range. $ USIZE) $slice
     (SLICE T&. T&)
   ))
   :pattern ((tr_bound%core!slice.index.SliceIndex. $ (TYPE%core!ops.range.Range. $ USIZE)
     $slice (SLICE T&. T&)
   ))
   :qid internal_core__slice__index__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__slice__index__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!slice.index.SliceIndex. $ (TYPE%core!ops.range.Range. $ USIZE) $slice
  STRSLICE
))

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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::mul_lemmas::lemma_mul_le
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. (Int
  Int Int Int
 ) Bool
)
(declare-const %%global_location_label%%22 Bool)
(declare-const %%global_location_label%%23 Bool)
(assert
 (forall ((a1! Int) (b1! Int) (a2! Int) (b2! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. a1! b1! a2!
     b2!
    ) (and
     (=>
      %%global_location_label%%22
      (<= a1! b1!)
     )
     (=>
      %%global_location_label%%23
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
(declare-fun %%lambda%%4 (Int Dcr Type Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Int) (%%hole%%1 Dcr) (%%hole%%2 Type) (%%hole%%3 Poly) (j2$ Poly))
  (!
   (= (%%apply%%0 (%%lambda%%4 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) j2$) (vstd!seq.Seq.index.?
     %%hole%%1 %%hole%%2 %%hole%%3 (I (Add %%hole%%0 (%I j2$)))
   ))
   :pattern ((%%apply%%0 (%%lambda%%4 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3) j2$))
)))
(declare-const %%global_location_label%%24 Bool)
(declare-const %%global_location_label%%25 Bool)
(declare-const %%global_location_label%%26 Bool)
(declare-const %%global_location_label%%27 Bool)
(declare-const %%global_location_label%%28 Bool)
(assert
 (forall ((bytes! %%Function%%) (words! %%Function%%) (i! Int) (j! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step.
     bytes! words! i! j!
    ) (and
     (=>
      %%global_location_label%%24
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
      %%global_location_label%%25
      (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 4)
          ) (Poly%array%. words!)
         ) (I i!)
        )
       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul j! 8))))
     ))
     (=>
      %%global_location_label%%26
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
        :qid user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_byte_to_word_step_75
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_byte_to_word_step_75
     )))
     (=>
      %%global_location_label%%27
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 4)
          ) (Poly%array%. words!)
         ) (I i!)
        )
       ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
          8
         ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%4 (Mul i! 8)
            $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
              bytes!
         )))))
        ) (I j!)
     )))
     (=>
      %%global_location_label%%28
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
             ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%4 (Mul (%I i2$)
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
        :qid user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_byte_to_word_step_76
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_byte_to_word_step_76
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
        ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%4 (nClip (Mul
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

;; Function-Specs curve25519_dalek::lemmas::scalar_byte_lemmas::bytes_to_scalar_lemmas::lemma_bytes_to_word_equivalence
(declare-fun req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence.
 (%%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%29 Bool)
(assert
 (forall ((bytes! %%Function%%) (words! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_bytes_to_word_equivalence.
     bytes! words!
    ) (=>
     %%global_location_label%%29
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
            ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%4 (Mul (%I i2$)
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
       :qid user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_bytes_to_word_equivalence_77
       :skolemid skolem_user_curve25519_dalek__lemmas__scalar_byte_lemmas__bytes_to_scalar_lemmas__lemma_bytes_to_word_equivalence_77
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

;; Function-Specs curve25519_dalek::lemmas::scalar_byte_lemmas::bytes_to_scalar_lemmas::lemma_words_to_scalar
(declare-fun req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_words_to_scalar.
 (%%Function%% curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int) Bool
)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(declare-const %%global_location_label%%36 Bool)
(assert
 (forall ((words! %%Function%%) (s! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (mask! Int) (top_mask! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_words_to_scalar.
     words! s! mask! top_mask!
    ) (and
     (=>
      %%global_location_label%%30
      (= mask! (Sub (uClip 64 (bitshl (I 1) (I 52))) 1))
     )
     (=>
      %%global_location_label%%31
      (= top_mask! (Sub (uClip 64 (bitshl (I 1) (I 48))) 1))
     )
     (=>
      %%global_location_label%%32
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              s!
          ))))
         ) (I 0)
        )
       ) (uClip 64 (bitand (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (
              ARRAY $ (UINT 64) $ (CONST_INT 4)
             ) (Poly%array%. words!)
            ) (I 0)
          ))
         ) (I mask!)
     ))))
     (=>
      %%global_location_label%%33
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              s!
          ))))
         ) (I 1)
        )
       ) (uClip 64 (bitand (I (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $
                  (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 4)) (Poly%array%.
                    words!
                   )
                  ) (I 0)
                ))
               ) (I 52)
             ))
            ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                   (ARRAY $ (UINT 64) $ (CONST_INT 4)) (Poly%array%. words!)
                  ) (I 1)
                ))
               ) (I 12)
          )))))
         ) (I mask!)
     ))))
     (=>
      %%global_location_label%%34
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              s!
          ))))
         ) (I 2)
        )
       ) (uClip 64 (bitand (I (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $
                  (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 4)) (Poly%array%.
                    words!
                   )
                  ) (I 1)
                ))
               ) (I 40)
             ))
            ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                   (ARRAY $ (UINT 64) $ (CONST_INT 4)) (Poly%array%. words!)
                  ) (I 2)
                ))
               ) (I 24)
          )))))
         ) (I mask!)
     ))))
     (=>
      %%global_location_label%%35
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              s!
          ))))
         ) (I 3)
        )
       ) (uClip 64 (bitand (I (uClip 64 (bitor (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $
                  (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 4)) (Poly%array%.
                    words!
                   )
                  ) (I 2)
                ))
               ) (I 28)
             ))
            ) (I (uClip 64 (bitshl (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
                   (ARRAY $ (UINT 64) $ (CONST_INT 4)) (Poly%array%. words!)
                  ) (I 3)
                ))
               ) (I 36)
          )))))
         ) (I mask!)
     ))))
     (=>
      %%global_location_label%%36
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              s!
          ))))
         ) (I 4)
        )
       ) (uClip 64 (bitand (I (uClip 64 (bitshr (I (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                $ (ARRAY $ (UINT 64) $ (CONST_INT 4)) (Poly%array%. words!)
               ) (I 3)
             ))
            ) (I 16)
          ))
         ) (I top_mask!)
   ))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_words_to_scalar.
     words! s! mask! top_mask!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_words_to_scalar._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_words_to_scalar._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_words_to_scalar.
 (%%Function%% curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int) Bool
)
(assert
 (forall ((words! %%Function%%) (s! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (mask! Int) (top_mask! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_words_to_scalar.
     words! s! mask! top_mask!
    ) (and
     (= (curve25519_dalek!specs.core_specs.words_as_nat_u64.? (vstd!array.spec_array_as_slice.?
        $ (UINT 64) $ (CONST_INT 4) (Poly%array%. words!)
       ) (I 4) (I 64)
      ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        s!
     )))
     (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       s!
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_words_to_scalar.
     words! s! mask! top_mask!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_words_to_scalar._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_words_to_scalar._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_limbs_bounded_implies_prod_bounded
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(declare-const %%global_location_label%%37 Bool)
(assert
 (forall ((s! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (t! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded.
     s! t!
    ) (=>
     %%global_location_label%%37
     (or
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        s!
      ))
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        t!
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded.
     s! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(assert
 (forall ((s! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (t! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded.
     s! t!
    ) (curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.? (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
       (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         s!
      )))
     ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
       (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         t!
      )))
     ) (I 5)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded.
     s! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded._definition
)))

;; Function-Specs curve25519_dalek::backend::serial::u64::scalar::Scalar52::from_bytes
(declare-fun ens%curve25519_dalek!backend.serial.u64.scalar.impl&%6.from_bytes. (%%Function%%
  curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) Bool
)
(assert
 (forall ((bytes! %%Function%%) (s! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (ens%curve25519_dalek!backend.serial.u64.scalar.impl&%6.from_bytes. bytes! s!)
    (and
     (has_type (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. s!) TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
     (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.?
       (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. s!)
     ))
     (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       s!
     ))
     (curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.? (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
          s!
       )))
      ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
        (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
          s!
       )))
      ) (I 5)
   )))
   :pattern ((ens%curve25519_dalek!backend.serial.u64.scalar.impl&%6.from_bytes. bytes!
     s!
   ))
   :qid internal_ens__curve25519_dalek!backend.serial.u64.scalar.impl&__6.from_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!backend.serial.u64.scalar.impl&__6.from_bytes._definition
)))

;; Function-Def curve25519_dalek::backend::serial::u64::scalar::Scalar52::from_bytes
;; curve25519-dalek/src/backend/serial/u64/scalar.rs:186:13: 205:14 (#0)
(get-info :all-statistics)
(push)
 (declare-const s! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 (declare-const bytes! %%Function%%)
 (declare-const tmp%1 Poly)
 (declare-const tmp%2 Poly)
 (declare-const VERUS_loop_val@ Int)
 (declare-const tmp%%$1@ core!option.Option.)
 (declare-const tmp%3 Bool)
 (declare-const tmp%4 Poly)
 (declare-const tmp%5 Poly)
 (declare-const VERUS_loop_val$1@ Int)
 (declare-const tmp%%$4@ core!option.Option.)
 (declare-const tmp%6 Poly)
 (declare-const tmp%7 %%Function%%)
 (declare-const tmp%8 Poly)
 (declare-const tmp%9 Int)
 (declare-const tmp%10 Int)
 (declare-const tmp%11 Poly)
 (declare-const tmp%12 Int)
 (declare-const tmp%13 Int)
 (declare-const VERUS_loop_next$1@0 Int)
 (declare-const j@ Int)
 (declare-const tmp%%$5@ tuple%0.)
 (declare-const decrease%init1%0 Int)
 (declare-const VERUS_ghost_iter$1@0 vstd!std_specs.range.RangeGhostIterator.)
 (declare-const VERUS_exec_iter$1@0 core!ops.range.Range.)
 (declare-const tmp%%$3@ core!ops.range.Range.)
 (declare-const VERUS_iter$1@ core!ops.range.Range.)
 (declare-const VERUS_loop_result$1@ tuple%0.)
 (declare-const VERUS_loop_next@0 Int)
 (declare-const i@ Int)
 (declare-const tmp%%$2@ tuple%0.)
 (declare-const decrease%init0%0 Int)
 (declare-const VERUS_ghost_iter@0 vstd!std_specs.range.RangeGhostIterator.)
 (declare-const VERUS_exec_iter@0 core!ops.range.Range.)
 (declare-const tmp%%@ core!ops.range.Range.)
 (declare-const VERUS_iter@ core!ops.range.Range.)
 (declare-const VERUS_loop_result@ tuple%0.)
 (declare-const tmp%14 Poly)
 (declare-const tmp%15 Int)
 (declare-const tmp%16 Int)
 (declare-const tmp%17 Poly)
 (declare-const tmp%18 Poly)
 (declare-const tmp%19 Int)
 (declare-const tmp%20 Int)
 (declare-const tmp%21 Int)
 (declare-const tmp%22 Poly)
 (declare-const tmp%23 Poly)
 (declare-const tmp%24 Int)
 (declare-const tmp%25 Int)
 (declare-const tmp%26 Int)
 (declare-const tmp%27 Poly)
 (declare-const tmp%28 Poly)
 (declare-const tmp%29 Int)
 (declare-const tmp%30 Int)
 (declare-const tmp%31 Int)
 (declare-const tmp%32 Poly)
 (declare-const tmp%33 Int)
 (declare-const tmp%34 Int)
 (declare-const tmp%35 Bool)
 (declare-const words@0 %%Function%%)
 (declare-const mask@ Int)
 (declare-const top_mask@ Int)
 (declare-const s@0 curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%array%. bytes!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
 )
 (assert
  (has_type (Poly%array%. words@0) (ARRAY $ (UINT 64) $ (CONST_INT 4)))
 )
 (assert
  (has_type (Poly%core!ops.range.Range. VERUS_iter@) (TYPE%core!ops.range.Range. $ USIZE))
 )
 (assert
  (has_type tmp%1 (TYPE%core!ops.range.Range. $ USIZE))
 )
 (assert
  (has_type (Poly%core!ops.range.Range. tmp%%@) (TYPE%core!ops.range.Range. $ USIZE))
 )
 (assert
  (has_type (Poly%core!ops.range.Range. VERUS_exec_iter@0) (TYPE%core!ops.range.Range.
    $ USIZE
 )))
 (assert
  (has_type (Poly%vstd!std_specs.range.RangeGhostIterator. VERUS_ghost_iter@0) (TYPE%vstd!std_specs.range.RangeGhostIterator.
    $ USIZE
 )))
 (assert
  (has_type tmp%2 (TYPE%core!option.Option. $ USIZE))
 )
 (assert
  (has_type (Poly%core!option.Option. tmp%%$1@) (TYPE%core!option.Option. $ USIZE))
 )
 (assert
  (uInv SZ i@)
 )
 (assert
  (has_type (Poly%core!ops.range.Range. VERUS_iter$1@) (TYPE%core!ops.range.Range. $
    USIZE
 )))
 (assert
  (has_type tmp%4 (TYPE%core!ops.range.Range. $ USIZE))
 )
 (assert
  (has_type (Poly%core!ops.range.Range. tmp%%$3@) (TYPE%core!ops.range.Range. $ USIZE))
 )
 (assert
  (has_type (Poly%core!ops.range.Range. VERUS_exec_iter$1@0) (TYPE%core!ops.range.Range.
    $ USIZE
 )))
 (assert
  (has_type (Poly%vstd!std_specs.range.RangeGhostIterator. VERUS_ghost_iter$1@0) (TYPE%vstd!std_specs.range.RangeGhostIterator.
    $ USIZE
 )))
 (declare-const VERUS_exec_iter$1@1 core!ops.range.Range.)
 (declare-const VERUS_loop_next$1@1 Int)
 (declare-const words@1 %%Function%%)
 (declare-const VERUS_ghost_iter$1@1 vstd!std_specs.range.RangeGhostIterator.)
 (declare-const %%switch_label%%0 Bool)
 ;; loop invariant not satisfied
 (declare-const %%location_label%%0 Bool)
 ;; loop invariant not satisfied
 (declare-const %%location_label%%1 Bool)
 ;; loop invariant not satisfied
 (declare-const %%location_label%%2 Bool)
 ;; loop invariant not satisfied
 (declare-const %%location_label%%3 Bool)
 ;; loop invariant not satisfied
 (declare-const %%location_label%%4 Bool)
 ;; loop invariant not satisfied
 (declare-const %%location_label%%5 Bool)
 ;; loop invariant not satisfied
 (declare-const %%location_label%%6 Bool)
 ;; loop invariant not satisfied
 (declare-const %%location_label%%7 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%8 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%9 Bool)
 ;; possible arithmetic underflow/overflow
 (declare-const %%location_label%%10 Bool)
 ;; possible arithmetic underflow/overflow
 (declare-const %%location_label%%11 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%12 Bool)
 ;; possible arithmetic underflow/overflow
 (declare-const %%location_label%%13 Bool)
 ;; possible bit shift underflow/overflow
 (declare-const %%location_label%%14 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%15 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%16 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%17 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%18 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%19 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%20 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%21 Bool)
 ;; invariant not satisfied at end of loop body
 (declare-const %%location_label%%22 Bool)
 ;; decreases not satisfied at end of loop
 (declare-const %%location_label%%23 Bool)
 (assert
  (not (=>
    (%B (vstd!pervasive.ForLoopGhostIterator.exec_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
       $ USIZE
      ) (Poly%vstd!std_specs.range.RangeGhostIterator. VERUS_ghost_iter$1@0) (Poly%core!ops.range.Range.
       VERUS_exec_iter$1@0
    )))
    (=>
     (%B (vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
        $ USIZE
       ) (Poly%vstd!std_specs.range.RangeGhostIterator. VERUS_ghost_iter$1@0) (Poly%core!option.Option.
        (core!option.Option./Some (vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? $ (TYPE%core!ops.range.Range.
           $ USIZE
          ) (vstd!std_specs.core.iter_into_iter_spec.? $ (TYPE%core!ops.range.Range. $ USIZE)
           (Poly%core!ops.range.Range. (core!ops.range.Range./Range (I 0) (I 8)))
     ))))))
     (=>
      (let
       ((j$ (ite
          (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
             $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
              VERUS_ghost_iter$1@0
          ))))
          (let
           ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                 $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                  VERUS_ghost_iter$1@0
           )))))))
           t$
          )
          (%I (vstd!pervasive.arbitrary.? $ USIZE))
       )))
       (and
        (let
         ((tmp%%$6 j$))
         (and
          (<= 0 tmp%%$6)
          (<= tmp%%$6 8)
        ))
        (let
         ((tmp%%$7 i@))
         (and
          (<= 0 tmp%%$7)
          (< tmp%%$7 4)
      ))))
      (=>
       (let
        ((j$ (ite
           (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
              $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
               VERUS_ghost_iter$1@0
           ))))
           (let
            ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                  $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                   VERUS_ghost_iter$1@0
            )))))))
            t$
           )
           (%I (vstd!pervasive.arbitrary.? $ USIZE))
        )))
        (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 4)
            ) (Poly%array%. words@0)
           ) (I i@)
          )
         ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul j$ 8))))
       ))
       (=>
        (let
         ((j$ (ite
            (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
               $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                VERUS_ghost_iter$1@0
            ))))
            (let
             ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                   $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                    VERUS_ghost_iter$1@0
             )))))))
             t$
            )
            (%I (vstd!pervasive.arbitrary.? $ USIZE))
         )))
         (forall ((i2$ Poly)) (!
           (=>
            (has_type i2$ INT)
            (=>
             (let
              ((tmp%%$8 (%I i2$)))
              (and
               (<= (Add i@ 1) tmp%%$8)
               (< tmp%%$8 4)
             ))
             (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                  (CONST_INT 4)
                 ) (Poly%array%. words@0)
                ) i2$
               )
              ) 0
           )))
           :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 4)
              ) (Poly%array%. words@0)
             ) i2$
           ))
           :qid user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_80
           :skolemid skolem_user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_80
        )))
        (=>
         (let
          ((j$ (ite
             (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                 VERUS_ghost_iter$1@0
             ))))
             (let
              ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                    $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                     VERUS_ghost_iter$1@0
              )))))))
              t$
             )
             (%I (vstd!pervasive.arbitrary.? $ USIZE))
          )))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 4)
              ) (Poly%array%. words@0)
             ) (I i@)
            )
           ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
              8
             ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%4 (Mul i@ 8)
                $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
                  bytes!
             )))))
            ) (I j$)
         )))
         (=>
          (let
           ((j$ (ite
              (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                 $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                  VERUS_ghost_iter$1@0
              ))))
              (let
               ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                     $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                      VERUS_ghost_iter$1@0
               )))))))
               t$
              )
              (%I (vstd!pervasive.arbitrary.? $ USIZE))
           )))
           (forall ((i2$ Poly)) (!
             (=>
              (has_type i2$ INT)
              (=>
               (let
                ((tmp%%$9 (%I i2$)))
                (and
                 (<= 0 tmp%%$9)
                 (< tmp%%$9 i@)
               ))
               (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                    (CONST_INT 4)
                   ) (Poly%array%. words@0)
                  ) i2$
                 )
                ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
                   8
                  ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%4 (Mul (%I i2$)
                      8
                     ) $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
                       bytes!
                  )))))
                 ) (I 8)
             ))))
             :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                 $ (CONST_INT 4)
                ) (Poly%array%. words@0)
               ) i2$
             ))
             :qid user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_81
             :skolemid skolem_user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_81
          )))
          (=>
           (= decrease%init1%0 (ite
             (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?
                $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                 VERUS_ghost_iter$1@0
             ))))
             (let
              ((t$ (%I (core!option.Option./Some/0 $ INT (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?
                    $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                     VERUS_ghost_iter$1@0
              )))))))
              t$
             )
             (%I (vstd!pervasive.arbitrary.? $ INT))
           ))
           (=>
            (has_type (Poly%core!ops.range.Range. VERUS_exec_iter$1@1) (TYPE%core!ops.range.Range.
              $ USIZE
            ))
            (=>
             (ens%core!iter.range.impl&%6.next. $ USIZE (Poly%core!ops.range.Range. VERUS_exec_iter$1@0)
              (Poly%core!ops.range.Range. VERUS_exec_iter$1@1) tmp%5
             )
             (=>
              (= tmp%%$4@ (%Poly%core!option.Option. tmp%5))
              (or
               (and
                (=>
                 (is-core!option.Option./Some tmp%%$4@)
                 (=>
                  (= VERUS_loop_val$1@ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option.
                      (Poly%core!option.Option. tmp%%$4@)
                  ))))
                  (=>
                   (= VERUS_loop_next$1@1 VERUS_loop_val$1@)
                   %%switch_label%%0
                )))
                (=>
                 (not (is-core!option.Option./Some tmp%%$4@))
                 (and
                  (=>
                   %%location_label%%0
                   (%B (vstd!pervasive.ForLoopGhostIterator.exec_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
                      $ USIZE
                     ) (Poly%vstd!std_specs.range.RangeGhostIterator. VERUS_ghost_iter$1@0) (Poly%core!ops.range.Range.
                      VERUS_exec_iter$1@1
                  ))))
                  (and
                   (=>
                    %%location_label%%1
                    (%B (vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
                       $ USIZE
                      ) (Poly%vstd!std_specs.range.RangeGhostIterator. VERUS_ghost_iter$1@0) (Poly%core!option.Option.
                       (core!option.Option./Some (vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? $ (TYPE%core!ops.range.Range.
                          $ USIZE
                         ) (vstd!std_specs.core.iter_into_iter_spec.? $ (TYPE%core!ops.range.Range. $ USIZE)
                          (Poly%core!ops.range.Range. (core!ops.range.Range./Range (I 0) (I 8)))
                   )))))))
                   (and
                    (=>
                     %%location_label%%2
                     (let
                      ((j$ (ite
                         (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                            $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                             VERUS_ghost_iter$1@0
                         ))))
                         (let
                          ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                 VERUS_ghost_iter$1@0
                          )))))))
                          t$
                         )
                         (%I (vstd!pervasive.arbitrary.? $ USIZE))
                      )))
                      (and
                       (let
                        ((tmp%%$6 j$))
                        (and
                         (<= 0 tmp%%$6)
                         (<= tmp%%$6 8)
                       ))
                       (let
                        ((tmp%%$7 i@))
                        (and
                         (<= 0 tmp%%$7)
                         (< tmp%%$7 4)
                    )))))
                    (and
                     (=>
                      %%location_label%%3
                      (let
                       ((j$ (ite
                          (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                             $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                              VERUS_ghost_iter$1@0
                          ))))
                          (let
                           ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                 $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                  VERUS_ghost_iter$1@0
                           )))))))
                           t$
                          )
                          (%I (vstd!pervasive.arbitrary.? $ USIZE))
                       )))
                       (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                            (CONST_INT 4)
                           ) (Poly%array%. words@0)
                          ) (I i@)
                         )
                        ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul j$ 8))))
                     )))
                     (and
                      (=>
                       %%location_label%%4
                       (let
                        ((j$ (ite
                           (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                              $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                               VERUS_ghost_iter$1@0
                           ))))
                           (let
                            ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                  $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                   VERUS_ghost_iter$1@0
                            )))))))
                            t$
                           )
                           (%I (vstd!pervasive.arbitrary.? $ USIZE))
                        )))
                        (forall ((i2$ Poly)) (!
                          (=>
                           (has_type i2$ INT)
                           (=>
                            (let
                             ((tmp%%$8 (%I i2$)))
                             (and
                              (<= (Add i@ 1) tmp%%$8)
                              (< tmp%%$8 4)
                            ))
                            (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                                 (CONST_INT 4)
                                ) (Poly%array%. words@0)
                               ) i2$
                              )
                             ) 0
                          )))
                          :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                              $ (CONST_INT 4)
                             ) (Poly%array%. words@0)
                            ) i2$
                          ))
                          :qid user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_80
                          :skolemid skolem_user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_80
                      ))))
                      (and
                       (=>
                        %%location_label%%5
                        (let
                         ((j$ (ite
                            (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                               $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                VERUS_ghost_iter$1@0
                            ))))
                            (let
                             ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                   $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                    VERUS_ghost_iter$1@0
                             )))))))
                             t$
                            )
                            (%I (vstd!pervasive.arbitrary.? $ USIZE))
                         )))
                         (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                              (CONST_INT 4)
                             ) (Poly%array%. words@0)
                            ) (I i@)
                           )
                          ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
                             8
                            ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%4 (Mul i@ 8)
                               $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
                                 bytes!
                            )))))
                           ) (I j$)
                       ))))
                       (and
                        (=>
                         %%location_label%%6
                         (let
                          ((j$ (ite
                             (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                 VERUS_ghost_iter$1@0
                             ))))
                             (let
                              ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                    $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                     VERUS_ghost_iter$1@0
                              )))))))
                              t$
                             )
                             (%I (vstd!pervasive.arbitrary.? $ USIZE))
                          )))
                          (forall ((i2$ Poly)) (!
                            (=>
                             (has_type i2$ INT)
                             (=>
                              (let
                               ((tmp%%$9 (%I i2$)))
                               (and
                                (<= 0 tmp%%$9)
                                (< tmp%%$9 i@)
                              ))
                              (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                                   (CONST_INT 4)
                                  ) (Poly%array%. words@0)
                                 ) i2$
                                )
                               ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
                                  8
                                 ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%4 (Mul (%I i2$)
                                     8
                                    ) $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
                                      bytes!
                                 )))))
                                ) (I 8)
                            ))))
                            :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                                $ (CONST_INT 4)
                               ) (Poly%array%. words@0)
                              ) i2$
                            ))
                            :qid user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_81
                            :skolemid skolem_user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_81
                        ))))
                        (=>
                         %%location_label%%7
                         (%B (vstd!pervasive.ForLoopGhostIterator.ghost_ensures.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
                            $ USIZE
                           ) (Poly%vstd!std_specs.range.RangeGhostIterator. VERUS_ghost_iter$1@0)
               ))))))))))))
               (and
                (not %%switch_label%%0)
                (=>
                 (= j@ VERUS_loop_next$1@1)
                 (and
                  (=>
                   %%location_label%%8
                   (req%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step.
                    bytes! words@0 i@ j@
                  ))
                  (=>
                   (ens%curve25519_dalek!lemmas.scalar_byte_lemmas.bytes_to_scalar_lemmas.lemma_byte_to_word_step.
                    bytes! words@0 i@ j@
                   )
                   (=>
                    (= tmp%12 i@)
                    (and
                     (=>
                      %%location_label%%9
                      (req%vstd!array.array_index_get. $ (UINT 64) $ (CONST_INT 4) words@0 i@)
                     )
                     (=>
                      (ens%vstd!array.array_index_get. $ (UINT 64) $ (CONST_INT 4) words@0 i@ tmp%6)
                      (=>
                       (= tmp%11 tmp%6)
                       (=>
                        (= tmp%7 bytes!)
                        (and
                         (=>
                          %%location_label%%10
                          (uInv SZ (Mul i@ 8))
                         )
                         (=>
                          (uInv SZ (Mul i@ 8))
                          (and
                           (=>
                            %%location_label%%11
                            (uInv SZ (Add (uClip SZ (Mul i@ 8)) j@))
                           )
                           (=>
                            (uInv SZ (Add (uClip SZ (Mul i@ 8)) j@))
                            (=>
                             (= tmp%9 (uClip SZ (Add (uClip SZ (Mul i@ 8)) j@)))
                             (and
                              (=>
                               %%location_label%%12
                               (req%vstd!array.array_index_get. $ (UINT 8) $ (CONST_INT 32) tmp%7 tmp%9)
                              )
                              (=>
                               (ens%vstd!array.array_index_get. $ (UINT 8) $ (CONST_INT 32) tmp%7 tmp%9 tmp%8)
                               (=>
                                (= tmp%10 (uClip 64 (%I tmp%8)))
                                (and
                                 (=>
                                  %%location_label%%13
                                  (uInv SZ (Mul j@ 8))
                                 )
                                 (=>
                                  (uInv SZ (Mul j@ 8))
                                  (and
                                   (=>
                                    %%location_label%%14
                                    (and
                                     (<= 0 (uClip SZ (Mul j@ 8)))
                                     (< (uClip SZ (Mul j@ 8)) 64)
                                   ))
                                   (=>
                                    (and
                                     (<= 0 (uClip SZ (Mul j@ 8)))
                                     (< (uClip SZ (Mul j@ 8)) 64)
                                    )
                                    (=>
                                     (= tmp%13 (uClip 64 (bitor (I (%I tmp%11)) (I (uClip 64 (bitshl (I tmp%10) (I (uClip SZ (
                                              Mul j@ 8
                                     )))))))))
                                     (and
                                      (=>
                                       %%location_label%%15
                                       (req%vstd!std_specs.core.index_set. $ (ARRAY $ (UINT 64) $ (CONST_INT 4)) $ USIZE
                                        $ (UINT 64) (Poly%array%. words@0) (I tmp%12) (I tmp%13)
                                      ))
                                      (=>
                                       (has_type (Poly%array%. words@1) (ARRAY $ (UINT 64) $ (CONST_INT 4)))
                                       (=>
                                        (ens%vstd!std_specs.core.index_set. $ (ARRAY $ (UINT 64) $ (CONST_INT 4)) $ USIZE
                                         $ (UINT 64) (Poly%array%. words@0) (Poly%array%. words@1) (I tmp%12) (I tmp%13)
                                        )
                                        (=>
                                         (= tmp%%$5@ tuple%0./tuple%0)
                                         (=>
                                          (= VERUS_ghost_iter$1@1 (%Poly%vstd!std_specs.range.RangeGhostIterator. (vstd!pervasive.ForLoopGhostIterator.ghost_advance.?
                                             $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                              VERUS_ghost_iter$1@0
                                             ) (Poly%core!ops.range.Range. VERUS_exec_iter$1@1)
                                          )))
                                          (and
                                           (=>
                                            %%location_label%%16
                                            (%B (vstd!pervasive.ForLoopGhostIterator.exec_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
                                               $ USIZE
                                              ) (Poly%vstd!std_specs.range.RangeGhostIterator. VERUS_ghost_iter$1@1) (Poly%core!ops.range.Range.
                                               VERUS_exec_iter$1@1
                                           ))))
                                           (and
                                            (=>
                                             %%location_label%%17
                                             (%B (vstd!pervasive.ForLoopGhostIterator.ghost_invariant.? $ (TYPE%vstd!std_specs.range.RangeGhostIterator.
                                                $ USIZE
                                               ) (Poly%vstd!std_specs.range.RangeGhostIterator. VERUS_ghost_iter$1@1) (Poly%core!option.Option.
                                                (core!option.Option./Some (vstd!pervasive.ForLoopGhostIteratorNew.ghost_iter.? $ (TYPE%core!ops.range.Range.
                                                   $ USIZE
                                                  ) (vstd!std_specs.core.iter_into_iter_spec.? $ (TYPE%core!ops.range.Range. $ USIZE)
                                                   (Poly%core!ops.range.Range. (core!ops.range.Range./Range (I 0) (I 8)))
                                            )))))))
                                            (and
                                             (=>
                                              %%location_label%%18
                                              (let
                                               ((j$ (ite
                                                  (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                                     $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                      VERUS_ghost_iter$1@1
                                                  ))))
                                                  (let
                                                   ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                                         $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                          VERUS_ghost_iter$1@1
                                                   )))))))
                                                   t$
                                                  )
                                                  (%I (vstd!pervasive.arbitrary.? $ USIZE))
                                               )))
                                               (and
                                                (let
                                                 ((tmp%%$6 j$))
                                                 (and
                                                  (<= 0 tmp%%$6)
                                                  (<= tmp%%$6 8)
                                                ))
                                                (let
                                                 ((tmp%%$7 i@))
                                                 (and
                                                  (<= 0 tmp%%$7)
                                                  (< tmp%%$7 4)
                                             )))))
                                             (and
                                              (=>
                                               %%location_label%%19
                                               (let
                                                ((j$ (ite
                                                   (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                                      $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                       VERUS_ghost_iter$1@1
                                                   ))))
                                                   (let
                                                    ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                                          $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                           VERUS_ghost_iter$1@1
                                                    )))))))
                                                    t$
                                                   )
                                                   (%I (vstd!pervasive.arbitrary.? $ USIZE))
                                                )))
                                                (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                                                     (CONST_INT 4)
                                                    ) (Poly%array%. words@1)
                                                   ) (I i@)
                                                  )
                                                 ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul j$ 8))))
                                              )))
                                              (and
                                               (=>
                                                %%location_label%%20
                                                (let
                                                 ((j$ (ite
                                                    (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                                       $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                        VERUS_ghost_iter$1@1
                                                    ))))
                                                    (let
                                                     ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                                           $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                            VERUS_ghost_iter$1@1
                                                     )))))))
                                                     t$
                                                    )
                                                    (%I (vstd!pervasive.arbitrary.? $ USIZE))
                                                 )))
                                                 (forall ((i2$ Poly)) (!
                                                   (=>
                                                    (has_type i2$ INT)
                                                    (=>
                                                     (let
                                                      ((tmp%%$8 (%I i2$)))
                                                      (and
                                                       (<= (Add i@ 1) tmp%%$8)
                                                       (< tmp%%$8 4)
                                                     ))
                                                     (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                                                          (CONST_INT 4)
                                                         ) (Poly%array%. words@1)
                                                        ) i2$
                                                       )
                                                      ) 0
                                                   )))
                                                   :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                                                       $ (CONST_INT 4)
                                                      ) (Poly%array%. words@1)
                                                     ) i2$
                                                   ))
                                                   :qid user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_80
                                                   :skolemid skolem_user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_80
                                               ))))
                                               (and
                                                (=>
                                                 %%location_label%%21
                                                 (let
                                                  ((j$ (ite
                                                     (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                                        $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                         VERUS_ghost_iter$1@1
                                                     ))))
                                                     (let
                                                      ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                                            $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                             VERUS_ghost_iter$1@1
                                                      )))))))
                                                      t$
                                                     )
                                                     (%I (vstd!pervasive.arbitrary.? $ USIZE))
                                                  )))
                                                  (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                                                       (CONST_INT 4)
                                                      ) (Poly%array%. words@1)
                                                     ) (I i@)
                                                    )
                                                   ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
                                                      8
                                                     ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%4 (Mul i@ 8)
                                                        $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
                                                          bytes!
                                                     )))))
                                                    ) (I j$)
                                                ))))
                                                (and
                                                 (=>
                                                  %%location_label%%22
                                                  (let
                                                   ((j$ (ite
                                                      (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                                         $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                          VERUS_ghost_iter$1@1
                                                      ))))
                                                      (let
                                                       ((t$ (%I (core!option.Option./Some/0 $ USIZE (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_peek_next.?
                                                             $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                              VERUS_ghost_iter$1@1
                                                       )))))))
                                                       t$
                                                      )
                                                      (%I (vstd!pervasive.arbitrary.? $ USIZE))
                                                   )))
                                                   (forall ((i2$ Poly)) (!
                                                     (=>
                                                      (has_type i2$ INT)
                                                      (=>
                                                       (let
                                                        ((tmp%%$9 (%I i2$)))
                                                        (and
                                                         (<= 0 tmp%%$9)
                                                         (< tmp%%$9 i@)
                                                       ))
                                                       (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                                                            (CONST_INT 4)
                                                           ) (Poly%array%. words@1)
                                                          ) i2$
                                                         )
                                                        ) (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!seq.Seq.new.? $ (UINT
                                                           8
                                                          ) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%4 (Mul (%I i2$)
                                                              8
                                                             ) $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%.
                                                               bytes!
                                                          )))))
                                                         ) (I 8)
                                                     ))))
                                                     :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                                                         $ (CONST_INT 4)
                                                        ) (Poly%array%. words@1)
                                                       ) i2$
                                                     ))
                                                     :qid user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_81
                                                     :skolemid skolem_user_curve25519_dalek__backend__serial__u64__scalar__Scalar52__from_bytes_81
                                                 ))))
                                                 (=>
                                                  %%location_label%%23
                                                  (check_decrease_int (ite
                                                    (is-core!option.Option./Some (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?
                                                       $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                        VERUS_ghost_iter$1@1
                                                    ))))
                                                    (let
                                                     ((t$ (%I (core!option.Option./Some/0 $ INT (%Poly%core!option.Option. (vstd!pervasive.ForLoopGhostIterator.ghost_decrease.?
                                                           $ (TYPE%vstd!std_specs.range.RangeGhostIterator. $ USIZE) (Poly%vstd!std_specs.range.RangeGhostIterator.
                                                            VERUS_ghost_iter$1@1
                                                     )))))))
                                                     t$
                                                    )
                                                    (%I (vstd!pervasive.arbitrary.? $ INT))
                                                   ) decrease%init1%0 false
 ))))))))))))))))))))))))))))))))))))))))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
