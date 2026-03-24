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

;; MODULE 'module core_assumes'
;; curve25519-dalek/src/core_assumes.rs:286:1: 290:2 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!std_specs.result.impl&%0.arrow_Ok_0. FuelId)
(declare-const fuel%vstd!std_specs.result.is_ok. FuelId)
(declare-const fuel%vstd!std_specs.result.spec_unwrap. FuelId)
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
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_subrange_index. FuelId)
(declare-const fuel%vstd!seq.lemma_seq_two_subranges_index. FuelId)
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
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.spec_load8_at. FuelId)
(declare-const fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.field_element_from_bytes. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_fe51_from_bytes. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.field_canonical. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.mask51. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce. FuelId)
(declare-const fuel%curve25519_dalek!core_assumes.seq_from2. FuelId)
(declare-const fuel%curve25519_dalek!core_assumes.seq_from4. FuelId)
(declare-const fuel%curve25519_dalek!core_assumes.seq_from8. FuelId)
(declare-const fuel%curve25519_dalek!core_assumes.seq_from16. FuelId)
(declare-const fuel%curve25519_dalek!core_assumes.seq_from32. FuelId)
(declare-const fuel%curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.
 FuelId
)
(declare-const fuel%curve25519_dalek!core_assumes.seq_to_array_32. FuelId)
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
 (distinct fuel%vstd!std_specs.result.impl&%0.arrow_Ok_0. fuel%vstd!std_specs.result.is_ok.
  fuel%vstd!std_specs.result.spec_unwrap. fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view.
  fuel%vstd!array.impl&%2.spec_index. fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n.
  fuel%vstd!array.axiom_spec_array_as_slice. fuel%vstd!array.axiom_array_ext_equal.
  fuel%vstd!array.axiom_array_has_resolved. fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq.
  fuel%vstd!raw_ptr.ptrs_mut_eq_sized. fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.axiom_seq_index_decreases.
  fuel%vstd!seq.axiom_seq_subrange_decreases. fuel%vstd!seq.axiom_seq_new_len. fuel%vstd!seq.axiom_seq_new_index.
  fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!seq.axiom_seq_subrange_len.
  fuel%vstd!seq.axiom_seq_subrange_index. fuel%vstd!seq.lemma_seq_two_subranges_index.
  fuel%vstd!slice.impl&%2.spec_index. fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal.
  fuel%vstd!slice.axiom_slice_has_resolved. fuel%vstd!string.axiom_str_literal_len.
  fuel%vstd!string.axiom_str_literal_get_char. fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view.
  fuel%vstd!view.impl&%4.view. fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view.
  fuel%vstd!view.impl&%14.view. fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%18.view.
  fuel%vstd!view.impl&%20.view. fuel%vstd!view.impl&%22.view. fuel%vstd!view.impl&%24.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%32.view. fuel%vstd!view.impl&%40.view.
  fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. fuel%curve25519_dalek!specs.core_specs.spec_load8_at.
  fuel%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. fuel%curve25519_dalek!specs.field_specs.field_element_from_bytes.
  fuel%curve25519_dalek!specs.field_specs.spec_fe51_from_bytes. fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.
  fuel%curve25519_dalek!specs.field_specs_u64.p. fuel%curve25519_dalek!specs.field_specs_u64.field_canonical.
  fuel%curve25519_dalek!specs.field_specs_u64.mask51. fuel%curve25519_dalek!specs.field_specs_u64.spec_reduce.
  fuel%curve25519_dalek!core_assumes.seq_from2. fuel%curve25519_dalek!core_assumes.seq_from4.
  fuel%curve25519_dalek!core_assumes.seq_from8. fuel%curve25519_dalek!core_assumes.seq_from16.
  fuel%curve25519_dalek!core_assumes.seq_from32. fuel%curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.
  fuel%curve25519_dalek!core_assumes.seq_to_array_32. fuel%vstd!array.group_array_axioms.
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
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
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
(declare-fun tr_bound%core!fmt.Debug. (Dcr Type) Bool)
(declare-fun tr_bound%core!hash.Hash. (Dcr Type) Bool)
(declare-fun tr_bound%core!ops.arith.Neg. (Dcr Type) Bool)
(declare-fun tr_bound%core!hash.Hasher. (Dcr Type) Bool)
(declare-fun tr_bound%vstd!std_specs.result.ResultAdditionalSpecFns. (Dcr Type Dcr
  Type Dcr Type
 ) Bool
)

;; Associated-Type-Decls
(declare-fun proj%%vstd!view.View./V (Dcr Type) Dcr)
(declare-fun proj%vstd!view.View./V (Dcr Type) Type)
(declare-fun proj%%core!ops.arith.Neg./Output (Dcr Type) Dcr)
(declare-fun proj%core!ops.arith.Neg./Output (Dcr Type) Type)

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
(declare-sort core!array.TryFromSliceError. 0)
(declare-sort core!fmt.Error. 0)
(declare-sort core!fmt.Formatter. 0)
(declare-sort vstd!raw_ptr.Provenance. 0)
(declare-sort vstd!seq.Seq<u8.>. 0)
(declare-sort vstd!seq.Seq<char.>. 0)
(declare-sort slice%<u8.>. 0)
(declare-sort strslice%. 0)
(declare-sort allocator_global%. 0)
(declare-datatypes ((core!result.Result. 0) (vstd!raw_ptr.PtrData. 0) (curve25519_dalek!backend.serial.u64.field.FieldElement51.
   0
  ) (curve25519_dalek!montgomery.MontgomeryPoint. 0) (curve25519_dalek!edwards.CompressedEdwardsY.
   0
  ) (curve25519_dalek!ristretto.CompressedRistretto. 0) (tuple%0. 0)
 ) (((core!result.Result./Ok (core!result.Result./Ok/?0 Poly)) (core!result.Result./Err
    (core!result.Result./Err/?0 Poly)
   )
  ) ((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/?limbs
     %%Function%%
   ))
  ) ((curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/?0
     %%Function%%
   ))
  ) ((curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY (curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/?0
     %%Function%%
   ))
  ) ((curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto (curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/?0
     %%Function%%
   ))
  ) ((tuple%0./tuple%0))
))
(declare-fun core!result.Result./Ok/0 (Dcr Type Dcr Type core!result.Result.) Poly)
(declare-fun core!result.Result./Err/0 (Dcr Type Dcr Type core!result.Result.) Poly)
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
 (curve25519_dalek!backend.serial.u64.field.FieldElement51.) %%Function%%
)
(declare-fun curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0 (curve25519_dalek!montgomery.MontgomeryPoint.)
 %%Function%%
)
(declare-fun curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/0 (curve25519_dalek!edwards.CompressedEdwardsY.)
 %%Function%%
)
(declare-fun curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/0
 (curve25519_dalek!ristretto.CompressedRistretto.) %%Function%%
)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%core!result.Result. (Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51. Type)
(declare-const TYPE%curve25519_dalek!montgomery.MontgomeryPoint. Type)
(declare-const TYPE%curve25519_dalek!edwards.CompressedEdwardsY. Type)
(declare-const TYPE%curve25519_dalek!ristretto.CompressedRistretto. Type)
(declare-const TYPE%core!array.TryFromSliceError. Type)
(declare-const TYPE%core!fmt.Formatter. Type)
(declare-const TYPE%core!fmt.Error. Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%core!array.TryFromSliceError. (core!array.TryFromSliceError.) Poly)
(declare-fun %Poly%core!array.TryFromSliceError. (Poly) core!array.TryFromSliceError.)
(declare-fun Poly%core!fmt.Error. (core!fmt.Error.) Poly)
(declare-fun %Poly%core!fmt.Error. (Poly) core!fmt.Error.)
(declare-fun Poly%core!fmt.Formatter. (core!fmt.Formatter.) Poly)
(declare-fun %Poly%core!fmt.Formatter. (Poly) core!fmt.Formatter.)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq<u8.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u8.>. (Poly) vstd!seq.Seq<u8.>.)
(declare-fun Poly%vstd!seq.Seq<char.>. (vstd!seq.Seq<char.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<char.>. (Poly) vstd!seq.Seq<char.>.)
(declare-fun Poly%slice%<u8.>. (slice%<u8.>.) Poly)
(declare-fun %Poly%slice%<u8.>. (Poly) slice%<u8.>.)
(declare-fun Poly%strslice%. (strslice%.) Poly)
(declare-fun %Poly%strslice%. (Poly) strslice%.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%core!result.Result. (core!result.Result.) Poly)
(declare-fun %Poly%core!result.Result. (Poly) core!result.Result.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!backend.serial.u64.field.FieldElement51.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (Poly)
 curve25519_dalek!backend.serial.u64.field.FieldElement51.
)
(declare-fun Poly%curve25519_dalek!montgomery.MontgomeryPoint. (curve25519_dalek!montgomery.MontgomeryPoint.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!montgomery.MontgomeryPoint. (Poly) curve25519_dalek!montgomery.MontgomeryPoint.)
(declare-fun Poly%curve25519_dalek!edwards.CompressedEdwardsY. (curve25519_dalek!edwards.CompressedEdwardsY.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!edwards.CompressedEdwardsY. (Poly) curve25519_dalek!edwards.CompressedEdwardsY.)
(declare-fun Poly%curve25519_dalek!ristretto.CompressedRistretto. (curve25519_dalek!ristretto.CompressedRistretto.)
 Poly
)
(declare-fun %Poly%curve25519_dalek!ristretto.CompressedRistretto. (Poly) curve25519_dalek!ristretto.CompressedRistretto.)
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
 (forall ((x core!array.TryFromSliceError.)) (!
   (= x (%Poly%core!array.TryFromSliceError. (Poly%core!array.TryFromSliceError. x)))
   :pattern ((Poly%core!array.TryFromSliceError. x))
   :qid internal_core__array__TryFromSliceError_box_axiom_definition
   :skolemid skolem_internal_core__array__TryFromSliceError_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%core!array.TryFromSliceError.)
    (= x (Poly%core!array.TryFromSliceError. (%Poly%core!array.TryFromSliceError. x)))
   )
   :pattern ((has_type x TYPE%core!array.TryFromSliceError.))
   :qid internal_core__array__TryFromSliceError_unbox_axiom_definition
   :skolemid skolem_internal_core__array__TryFromSliceError_unbox_axiom_definition
)))
(assert
 (forall ((x core!array.TryFromSliceError.)) (!
   (has_type (Poly%core!array.TryFromSliceError. x) TYPE%core!array.TryFromSliceError.)
   :pattern ((has_type (Poly%core!array.TryFromSliceError. x) TYPE%core!array.TryFromSliceError.))
   :qid internal_core__array__TryFromSliceError_has_type_always_definition
   :skolemid skolem_internal_core__array__TryFromSliceError_has_type_always_definition
)))
(assert
 (forall ((x core!fmt.Error.)) (!
   (= x (%Poly%core!fmt.Error. (Poly%core!fmt.Error. x)))
   :pattern ((Poly%core!fmt.Error. x))
   :qid internal_core__fmt__Error_box_axiom_definition
   :skolemid skolem_internal_core__fmt__Error_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%core!fmt.Error.)
    (= x (Poly%core!fmt.Error. (%Poly%core!fmt.Error. x)))
   )
   :pattern ((has_type x TYPE%core!fmt.Error.))
   :qid internal_core__fmt__Error_unbox_axiom_definition
   :skolemid skolem_internal_core__fmt__Error_unbox_axiom_definition
)))
(assert
 (forall ((x core!fmt.Error.)) (!
   (has_type (Poly%core!fmt.Error. x) TYPE%core!fmt.Error.)
   :pattern ((has_type (Poly%core!fmt.Error. x) TYPE%core!fmt.Error.))
   :qid internal_core__fmt__Error_has_type_always_definition
   :skolemid skolem_internal_core__fmt__Error_has_type_always_definition
)))
(assert
 (forall ((x core!fmt.Formatter.)) (!
   (= x (%Poly%core!fmt.Formatter. (Poly%core!fmt.Formatter. x)))
   :pattern ((Poly%core!fmt.Formatter. x))
   :qid internal_core__fmt__Formatter_box_axiom_definition
   :skolemid skolem_internal_core__fmt__Formatter_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%core!fmt.Formatter.)
    (= x (Poly%core!fmt.Formatter. (%Poly%core!fmt.Formatter. x)))
   )
   :pattern ((has_type x TYPE%core!fmt.Formatter.))
   :qid internal_core__fmt__Formatter_unbox_axiom_definition
   :skolemid skolem_internal_core__fmt__Formatter_unbox_axiom_definition
)))
(assert
 (forall ((x core!fmt.Formatter.)) (!
   (has_type (Poly%core!fmt.Formatter. x) TYPE%core!fmt.Formatter.)
   :pattern ((has_type (Poly%core!fmt.Formatter. x) TYPE%core!fmt.Formatter.))
   :qid internal_core__fmt__Formatter_has_type_always_definition
   :skolemid skolem_internal_core__fmt__Formatter_has_type_always_definition
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
 (forall ((x core!result.Result.)) (!
   (= x (%Poly%core!result.Result. (Poly%core!result.Result. x)))
   :pattern ((Poly%core!result.Result. x))
   :qid internal_core__result__Result_box_axiom_definition
   :skolemid skolem_internal_core__result__Result_box_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (= x (Poly%core!result.Result. (%Poly%core!result.Result. x)))
   )
   :pattern ((has_type x (TYPE%core!result.Result. T&. T& E&. E&)))
   :qid internal_core__result__Result_unbox_axiom_definition
   :skolemid skolem_internal_core__result__Result_unbox_axiom_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (_0! Poly)) (!
   (=>
    (has_type _0! T&)
    (has_type (Poly%core!result.Result. (core!result.Result./Ok _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((has_type (Poly%core!result.Result. (core!result.Result./Ok _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :qid internal_core!result.Result./Ok_constructor_definition
   :skolemid skolem_internal_core!result.Result./Ok_constructor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Ok x)
    (= (core!result.Result./Ok/0 T&. T& E&. E& x) (core!result.Result./Ok/?0 x))
   )
   :pattern ((core!result.Result./Ok/0 T&. T& E&. E& x))
   :qid internal_core!result.Result./Ok/0_accessor_definition
   :skolemid skolem_internal_core!result.Result./Ok/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (has_type (core!result.Result./Ok/0 T&. T& E&. E& (%Poly%core!result.Result. x)) T&)
   )
   :pattern ((core!result.Result./Ok/0 T&. T& E&. E& (%Poly%core!result.Result. x)) (
     has_type x (TYPE%core!result.Result. T&. T& E&. E&)
   ))
   :qid internal_core!result.Result./Ok/0_invariant_definition
   :skolemid skolem_internal_core!result.Result./Ok/0_invariant_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (_0! Poly)) (!
   (=>
    (has_type _0! E&)
    (has_type (Poly%core!result.Result. (core!result.Result./Err _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :pattern ((has_type (Poly%core!result.Result. (core!result.Result./Err _0!)) (TYPE%core!result.Result.
      T&. T& E&. E&
   )))
   :qid internal_core!result.Result./Err_constructor_definition
   :skolemid skolem_internal_core!result.Result./Err_constructor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Err x)
    (= (core!result.Result./Err/0 T&. T& E&. E& x) (core!result.Result./Err/?0 x))
   )
   :pattern ((core!result.Result./Err/0 T&. T& E&. E& x))
   :qid internal_core!result.Result./Err/0_accessor_definition
   :skolemid skolem_internal_core!result.Result./Err/0_accessor_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x Poly)) (!
   (=>
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
    (has_type (core!result.Result./Err/0 T&. T& E&. E& (%Poly%core!result.Result. x))
     E&
   ))
   :pattern ((core!result.Result./Err/0 T&. T& E&. E& (%Poly%core!result.Result. x))
    (has_type x (TYPE%core!result.Result. T&. T& E&. E&))
   )
   :qid internal_core!result.Result./Err/0_invariant_definition
   :skolemid skolem_internal_core!result.Result./Err/0_invariant_definition
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Ok x)
    (height_lt (height (core!result.Result./Ok/0 T&. T& E&. E& x)) (height (Poly%core!result.Result.
       x
   ))))
   :pattern ((height (core!result.Result./Ok/0 T&. T& E&. E& x)))
   :qid prelude_datatype_height_core!result.Result./Ok/0
   :skolemid skolem_prelude_datatype_height_core!result.Result./Ok/0
)))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (x core!result.Result.)) (!
   (=>
    (is-core!result.Result./Err x)
    (height_lt (height (core!result.Result./Err/0 T&. T& E&. E& x)) (height (Poly%core!result.Result.
       x
   ))))
   :pattern ((height (core!result.Result./Err/0 T&. T& E&. E& x)))
   :qid prelude_datatype_height_core!result.Result./Err/0
   :skolemid skolem_prelude_datatype_height_core!result.Result./Err/0
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
 (forall ((x curve25519_dalek!montgomery.MontgomeryPoint.)) (!
   (= x (%Poly%curve25519_dalek!montgomery.MontgomeryPoint. (Poly%curve25519_dalek!montgomery.MontgomeryPoint.
      x
   )))
   :pattern ((Poly%curve25519_dalek!montgomery.MontgomeryPoint. x))
   :qid internal_curve25519_dalek__montgomery__MontgomeryPoint_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__montgomery__MontgomeryPoint_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!montgomery.MontgomeryPoint.)
    (= x (Poly%curve25519_dalek!montgomery.MontgomeryPoint. (%Poly%curve25519_dalek!montgomery.MontgomeryPoint.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!montgomery.MontgomeryPoint.))
   :qid internal_curve25519_dalek__montgomery__MontgomeryPoint_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__montgomery__MontgomeryPoint_unbox_axiom_definition
)))
(assert
 (forall ((_0! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _0!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (has_type (Poly%curve25519_dalek!montgomery.MontgomeryPoint. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint
       _0!
      )
     ) TYPE%curve25519_dalek!montgomery.MontgomeryPoint.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!montgomery.MontgomeryPoint. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint
       _0!
      )
     ) TYPE%curve25519_dalek!montgomery.MontgomeryPoint.
   ))
   :qid internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!montgomery.MontgomeryPoint.)) (!
   (= (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0 x) (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/?0
     x
   ))
   :pattern ((curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0 x))
   :qid internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!montgomery.MontgomeryPoint.)
    (has_type (Poly%array%. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0
       (%Poly%curve25519_dalek!montgomery.MontgomeryPoint. x)
      )
     ) (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0 (%Poly%curve25519_dalek!montgomery.MontgomeryPoint.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!montgomery.MontgomeryPoint.)
   )
   :qid internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.CompressedEdwardsY.)) (!
   (= x (%Poly%curve25519_dalek!edwards.CompressedEdwardsY. (Poly%curve25519_dalek!edwards.CompressedEdwardsY.
      x
   )))
   :pattern ((Poly%curve25519_dalek!edwards.CompressedEdwardsY. x))
   :qid internal_curve25519_dalek__edwards__CompressedEdwardsY_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__edwards__CompressedEdwardsY_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.CompressedEdwardsY.)
    (= x (Poly%curve25519_dalek!edwards.CompressedEdwardsY. (%Poly%curve25519_dalek!edwards.CompressedEdwardsY.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!edwards.CompressedEdwardsY.))
   :qid internal_curve25519_dalek__edwards__CompressedEdwardsY_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__edwards__CompressedEdwardsY_unbox_axiom_definition
)))
(assert
 (forall ((_0! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _0!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (has_type (Poly%curve25519_dalek!edwards.CompressedEdwardsY. (curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY
       _0!
      )
     ) TYPE%curve25519_dalek!edwards.CompressedEdwardsY.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!edwards.CompressedEdwardsY. (curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY
       _0!
      )
     ) TYPE%curve25519_dalek!edwards.CompressedEdwardsY.
   ))
   :qid internal_curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!edwards.CompressedEdwardsY.)) (!
   (= (curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/0 x) (curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/?0
     x
   ))
   :pattern ((curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/0 x))
   :qid internal_curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/0_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/0_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!edwards.CompressedEdwardsY.)
    (has_type (Poly%array%. (curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/0
       (%Poly%curve25519_dalek!edwards.CompressedEdwardsY. x)
      )
     ) (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/0 (%Poly%curve25519_dalek!edwards.CompressedEdwardsY.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!edwards.CompressedEdwardsY.)
   )
   :qid internal_curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/0_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/0_invariant_definition
)))
(assert
 (forall ((x curve25519_dalek!ristretto.CompressedRistretto.)) (!
   (= x (%Poly%curve25519_dalek!ristretto.CompressedRistretto. (Poly%curve25519_dalek!ristretto.CompressedRistretto.
      x
   )))
   :pattern ((Poly%curve25519_dalek!ristretto.CompressedRistretto. x))
   :qid internal_curve25519_dalek__ristretto__CompressedRistretto_box_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__ristretto__CompressedRistretto_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!ristretto.CompressedRistretto.)
    (= x (Poly%curve25519_dalek!ristretto.CompressedRistretto. (%Poly%curve25519_dalek!ristretto.CompressedRistretto.
       x
   ))))
   :pattern ((has_type x TYPE%curve25519_dalek!ristretto.CompressedRistretto.))
   :qid internal_curve25519_dalek__ristretto__CompressedRistretto_unbox_axiom_definition
   :skolemid skolem_internal_curve25519_dalek__ristretto__CompressedRistretto_unbox_axiom_definition
)))
(assert
 (forall ((_0! %%Function%%)) (!
   (=>
    (has_type (Poly%array%. _0!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (has_type (Poly%curve25519_dalek!ristretto.CompressedRistretto. (curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto
       _0!
      )
     ) TYPE%curve25519_dalek!ristretto.CompressedRistretto.
   ))
   :pattern ((has_type (Poly%curve25519_dalek!ristretto.CompressedRistretto. (curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto
       _0!
      )
     ) TYPE%curve25519_dalek!ristretto.CompressedRistretto.
   ))
   :qid internal_curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto_constructor_definition
   :skolemid skolem_internal_curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto_constructor_definition
)))
(assert
 (forall ((x curve25519_dalek!ristretto.CompressedRistretto.)) (!
   (= (curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/0 x) (curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/?0
     x
   ))
   :pattern ((curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/0 x))
   :qid internal_curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/0_accessor_definition
   :skolemid skolem_internal_curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/0_accessor_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x TYPE%curve25519_dalek!ristretto.CompressedRistretto.)
    (has_type (Poly%array%. (curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/0
       (%Poly%curve25519_dalek!ristretto.CompressedRistretto. x)
      )
     ) (ARRAY $ (UINT 8) $ (CONST_INT 32))
   ))
   :pattern ((curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/0 (%Poly%curve25519_dalek!ristretto.CompressedRistretto.
      x
     )
    ) (has_type x TYPE%curve25519_dalek!ristretto.CompressedRistretto.)
   )
   :qid internal_curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/0_invariant_definition
   :skolemid skolem_internal_curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/0_invariant_definition
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
(declare-fun %%apply%%1 (%%Function%% Int) Poly)
(assert
 (forall ((Tdcr Dcr) (T Type) (N Int) (Fn %%Function%%)) (!
   (=>
    (forall ((i Int)) (!
      (=>
       (and
        (<= 0 i)
        (< i N)
       )
       (has_type (%%apply%%1 Fn i) T)
      )
      :pattern ((has_type (%%apply%%1 Fn i) T))
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
    (= (array_index Tdcr T $ (CONST_INT N) Fn (I i)) (%%apply%%1 Fn i))
    :pattern ((array_new Tdcr T N Fn) (%%apply%%1 Fn i))
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
   true
   :pattern ((tr_bound%core!fmt.Debug. Self%&. Self%&))
   :qid internal_core__fmt__Debug_trait_type_bounds_definition
   :skolemid skolem_internal_core__fmt__Debug_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%core!hash.Hash. Self%&. Self%&))
   :qid internal_core__hash__Hash_trait_type_bounds_definition
   :skolemid skolem_internal_core__hash__Hash_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   (=>
    (tr_bound%core!ops.arith.Neg. Self%&. Self%&)
    (sized (proj%%core!ops.arith.Neg./Output Self%&. Self%&))
   )
   :pattern ((tr_bound%core!ops.arith.Neg. Self%&. Self%&))
   :qid internal_core__ops__arith__Neg_trait_type_bounds_definition
   :skolemid skolem_internal_core__ops__arith__Neg_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type)) (!
   true
   :pattern ((tr_bound%core!hash.Hasher. Self%&. Self%&))
   :qid internal_core__hash__Hasher_trait_type_bounds_definition
   :skolemid skolem_internal_core__hash__Hasher_trait_type_bounds_definition
)))
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (E&. Dcr) (E& Type)) (!
   (=>
    (tr_bound%vstd!std_specs.result.ResultAdditionalSpecFns. Self%&. Self%& T&. T& E&.
     E&
    )
    (and
     (sized T&.)
     (sized E&.)
   ))
   :pattern ((tr_bound%vstd!std_specs.result.ResultAdditionalSpecFns. Self%&. Self%& T&.
     T& E&. E&
   ))
   :qid internal_vstd__std_specs__result__ResultAdditionalSpecFns_trait_type_bounds_definition
   :skolemid skolem_internal_vstd__std_specs__result__ResultAdditionalSpecFns_trait_type_bounds_definition
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
 (= (proj%%core!ops.arith.Neg./Output (REF $) (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Neg./Output (REF $) (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Neg./Output $ (SINT 32)) $)
)
(assert
 (= (proj%core!ops.arith.Neg./Output $ (SINT 32)) (SINT 32))
)
(assert
 (= (proj%%core!ops.arith.Neg./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  $
))
(assert
 (= (proj%core!ops.arith.Neg./Output (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
  TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
))

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::subrange
(declare-fun vstd!seq.Seq.subrange.? (Dcr Type Poly Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::new
(declare-fun vstd!seq.Seq.new.? (Dcr Type Dcr Type Poly Poly) Poly)

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

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::std_specs::result::is_ok
(declare-fun vstd!std_specs.result.is_ok.? (Dcr Type Dcr Type Poly) Bool)

;; Function-Decl vstd::std_specs::result::ResultAdditionalSpecFns::arrow_Ok_0
(declare-fun vstd!std_specs.result.ResultAdditionalSpecFns.arrow_Ok_0.? (Dcr Type Dcr
  Type Dcr Type Poly
 ) Poly
)
(declare-fun vstd!std_specs.result.ResultAdditionalSpecFns.arrow_Ok_0%default%.? (
  Dcr Type Dcr Type Dcr Type Poly
 ) Poly
)

;; Function-Decl vstd::std_specs::result::spec_unwrap
(declare-fun vstd!std_specs.result.spec_unwrap.? (Dcr Type Dcr Type Poly) Poly)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::p
(declare-fun curve25519_dalek!specs.field_specs_u64.p.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::field_canonical
(declare-fun curve25519_dalek!specs.field_specs_u64.field_canonical.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::mask51
(declare-fun curve25519_dalek!specs.field_specs_u64.mask51.? () Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::spec_reduce
(declare-fun curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::specs::proba_specs::is_uniform_bytes
(declare-fun curve25519_dalek!specs.proba_specs.is_uniform_bytes.? (Poly) Bool)

;; Function-Decl curve25519_dalek::specs::core_specs::u8_32_as_nat
(declare-fun curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(declare-fun curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (Poly Poly) Int)
(declare-fun curve25519_dalek!specs.core_specs.rec%bytes_as_nat_prefix.? (Poly Poly
  Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::core_assumes::spec_state_after_hash
(declare-fun curve25519_dalek!core_assumes.spec_state_after_hash.? (Dcr Type Dcr Type
  Dcr Type Poly Poly
 ) Poly
)

;; Function-Decl curve25519_dalek::core_assumes::spec_sha512
(declare-fun curve25519_dalek!core_assumes.spec_sha512.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl curve25519_dalek::core_assumes::spec_sha256
(declare-fun curve25519_dalek!core_assumes.spec_sha256.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl curve25519_dalek::specs::core_specs::spec_load8_at
(declare-fun curve25519_dalek!specs.core_specs.spec_load8_at.? (Poly Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs::field_element_from_bytes
(declare-fun curve25519_dalek!specs.field_specs.field_element_from_bytes.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_fe51_from_bytes
(declare-fun curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.? (Poly) curve25519_dalek!backend.serial.u64.field.FieldElement51.)

;; Function-Decl curve25519_dalek::specs::field_specs::spec_fe51_as_bytes
(declare-fun curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl curve25519_dalek::core_assumes::seq_to_array_32
(declare-fun curve25519_dalek!core_assumes.seq_to_array_32.? (Poly) %%Function%%)

;; Function-Decl curve25519_dalek::core_assumes::seq_from2
(declare-fun curve25519_dalek!core_assumes.seq_from2.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl curve25519_dalek::core_assumes::seq_from4
(declare-fun curve25519_dalek!core_assumes.seq_from4.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl curve25519_dalek::core_assumes::seq_from8
(declare-fun curve25519_dalek!core_assumes.seq_from8.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl curve25519_dalek::core_assumes::seq_from16
(declare-fun curve25519_dalek!core_assumes.seq_from16.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl curve25519_dalek::core_assumes::seq_from32
(declare-fun curve25519_dalek!core_assumes.seq_from32.? (Poly) vstd!seq.Seq<u8.>.)

;; Function-Decl curve25519_dalek::core_assumes::spec_state_after_hash_montgomery
(declare-fun curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.? (Dcr
  Type Poly Poly
 ) Poly
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
    :qid user_vstd__seq__axiom_seq_new_len_2
    :skolemid skolem_user_vstd__seq__axiom_seq_new_len_2
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
    :qid user_vstd__seq__axiom_seq_new_index_3
    :skolemid skolem_user_vstd__seq__axiom_seq_new_index_3
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
          :qid user_vstd__seq__axiom_seq_ext_equal_4
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_4
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_5
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_5
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
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_6
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_6
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_7
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_7
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
    :qid user_vstd__seq__axiom_seq_subrange_len_8
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_len_8
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
    :qid user_vstd__seq__axiom_seq_subrange_index_9
    :skolemid skolem_user_vstd__seq__axiom_seq_subrange_index_9
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
    :qid user_vstd__seq__lemma_seq_two_subranges_index_10
    :skolemid skolem_user_vstd__seq__lemma_seq_two_subranges_index_10
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
    :qid user_vstd__slice__axiom_spec_len_11
    :skolemid skolem_user_vstd__slice__axiom_spec_len_11
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
          :qid user_vstd__slice__axiom_slice_ext_equal_12
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_12
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_13
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_13
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
    :qid user_vstd__slice__axiom_slice_has_resolved_14
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_14
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
    :qid user_vstd__array__array_len_matches_n_15
    :skolemid skolem_user_vstd__array__array_len_matches_n_15
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
    :qid user_vstd__array__lemma_array_index_16
    :skolemid skolem_user_vstd__array__lemma_array_index_16
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
    :qid user_vstd__array__axiom_spec_array_as_slice_17
    :skolemid skolem_user_vstd__array__axiom_spec_array_as_slice_17
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
         :qid user_vstd__array__axiom_array_ext_equal_18
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_18
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_19
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_19
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
    :qid user_vstd__array__axiom_array_has_resolved_20
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_20
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
    :qid user_vstd__string__axiom_str_literal_len_21
    :skolemid skolem_user_vstd__string__axiom_str_literal_len_21
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
    :qid user_vstd__string__axiom_str_literal_get_char_22
    :skolemid skolem_user_vstd__string__axiom_str_literal_get_char_22
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_23
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_23
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_24
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_24
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

;; Function-Axioms vstd::std_specs::result::is_ok
(assert
 (fuel_bool_default fuel%vstd!std_specs.result.is_ok.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.result.is_ok.)
  (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (result! Poly)) (!
    (= (vstd!std_specs.result.is_ok.? T&. T& E&. E& result!) (is-core!result.Result./Ok
      (%Poly%core!result.Result. result!)
    ))
    :pattern ((vstd!std_specs.result.is_ok.? T&. T& E&. E& result!))
    :qid internal_vstd!std_specs.result.is_ok.?_definition
    :skolemid skolem_internal_vstd!std_specs.result.is_ok.?_definition
))))

;; Function-Axioms vstd::std_specs::result::ResultAdditionalSpecFns::arrow_Ok_0
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (self!
    Poly
   )
  ) (!
   (=>
    (has_type self! Self%&)
    (has_type (vstd!std_specs.result.ResultAdditionalSpecFns.arrow_Ok_0.? Self%&. Self%&
      T&. T& E&. E& self!
     ) T&
   ))
   :pattern ((vstd!std_specs.result.ResultAdditionalSpecFns.arrow_Ok_0.? Self%&. Self%&
     T&. T& E&. E& self!
   ))
   :qid internal_vstd!std_specs.result.ResultAdditionalSpecFns.arrow_Ok_0.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.result.ResultAdditionalSpecFns.arrow_Ok_0.?_pre_post_definition
)))

;; Function-Axioms vstd::std_specs::result::impl&%0::arrow_Ok_0
(assert
 (fuel_bool_default fuel%vstd!std_specs.result.impl&%0.arrow_Ok_0.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.result.impl&%0.arrow_Ok_0.)
  (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (self! Poly)) (!
    (=>
     (and
      (sized T&.)
      (sized E&.)
     )
     (= (vstd!std_specs.result.ResultAdditionalSpecFns.arrow_Ok_0.? $ (TYPE%core!result.Result.
        T&. T& E&. E&
       ) T&. T& E&. E& self!
      ) (core!result.Result./Ok/0 T&. T& E&. E& (%Poly%core!result.Result. self!))
    ))
    :pattern ((vstd!std_specs.result.ResultAdditionalSpecFns.arrow_Ok_0.? $ (TYPE%core!result.Result.
       T&. T& E&. E&
      ) T&. T& E&. E& self!
    ))
    :qid internal_vstd!std_specs.result.ResultAdditionalSpecFns.arrow_Ok_0.?_definition
    :skolemid skolem_internal_vstd!std_specs.result.ResultAdditionalSpecFns.arrow_Ok_0.?_definition
))))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized E&.)
    )
    (tr_bound%vstd!std_specs.result.ResultAdditionalSpecFns. $ (TYPE%core!result.Result.
      T&. T& E&. E&
     ) T&. T& E&. E&
   ))
   :pattern ((tr_bound%vstd!std_specs.result.ResultAdditionalSpecFns. $ (TYPE%core!result.Result.
      T&. T& E&. E&
     ) T&. T& E&. E&
   ))
   :qid internal_vstd__std_specs__result__impl&__0_trait_impl_definition
   :skolemid skolem_internal_vstd__std_specs__result__impl&__0_trait_impl_definition
)))

;; Function-Specs vstd::std_specs::result::spec_unwrap
(declare-fun req%vstd!std_specs.result.spec_unwrap. (Dcr Type Dcr Type Poly) Bool)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (result! Poly)) (!
   (= (req%vstd!std_specs.result.spec_unwrap. T&. T& E&. E& result!) (=>
     %%global_location_label%%5
     (is-core!result.Result./Ok (%Poly%core!result.Result. result!))
   ))
   :pattern ((req%vstd!std_specs.result.spec_unwrap. T&. T& E&. E& result!))
   :qid internal_req__vstd!std_specs.result.spec_unwrap._definition
   :skolemid skolem_internal_req__vstd!std_specs.result.spec_unwrap._definition
)))

;; Function-Axioms vstd::std_specs::result::spec_unwrap
(assert
 (fuel_bool_default fuel%vstd!std_specs.result.spec_unwrap.)
)
(assert
 (=>
  (fuel_bool fuel%vstd!std_specs.result.spec_unwrap.)
  (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (result! Poly)) (!
    (= (vstd!std_specs.result.spec_unwrap.? T&. T& E&. E& result!) (core!result.Result./Ok/0
      T&. T& E&. E& (%Poly%core!result.Result. result!)
    ))
    :pattern ((vstd!std_specs.result.spec_unwrap.? T&. T& E&. E& result!))
    :qid internal_vstd!std_specs.result.spec_unwrap.?_definition
    :skolemid skolem_internal_vstd!std_specs.result.spec_unwrap.?_definition
))))
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type) (result! Poly)) (!
   (=>
    (has_type result! (TYPE%core!result.Result. T&. T& E&. E&))
    (has_type (vstd!std_specs.result.spec_unwrap.? T&. T& E&. E& result!) T&)
   )
   :pattern ((vstd!std_specs.result.spec_unwrap.? T&. T& E&. E& result!))
   :qid internal_vstd!std_specs.result.spec_unwrap.?_pre_post_definition
   :skolemid skolem_internal_vstd!std_specs.result.spec_unwrap.?_pre_post_definition
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
     (= (%%apply%%1 %%x%% 0) %%hole%%0)
     (= (%%apply%%1 %%x%% 1) %%hole%%1)
     (= (%%apply%%1 %%x%% 2) %%hole%%2)
     (= (%%apply%%1 %%x%% 3) %%hole%%3)
     (= (%%apply%%1 %%x%% 4) %%hole%%4)
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

;; Function-Specs curve25519_dalek::core_assumes::try_into_32_bytes_array
(declare-fun ens%curve25519_dalek!core_assumes.try_into_32_bytes_array. (slice%<u8.>.
  core!result.Result.
 ) Bool
)
(assert
 (forall ((bytes! slice%<u8.>.) (result! core!result.Result.)) (!
   (= (ens%curve25519_dalek!core_assumes.try_into_32_bytes_array. bytes! result!) (and
     (has_type (Poly%core!result.Result. result!) (TYPE%core!result.Result. $ (ARRAY $ (UINT
         8
        ) $ (CONST_INT 32)
       ) $ TYPE%core!array.TryFromSliceError.
     ))
     (=>
      (= (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) (
          Poly%slice%<u8.>. bytes!
        ))
       ) 32
      )
      (is-core!result.Result./Ok result!)
     )
     (=>
      (not (= (vstd!seq.Seq.len.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8))
          (Poly%slice%<u8.>. bytes!)
         )
        ) 32
      ))
      (is-core!result.Result./Err result!)
     )
     (=>
      (is-core!result.Result./Ok result!)
      (let
       ((arr$ (%Poly%array%. (core!result.Result./Ok/0 $ (ARRAY $ (UINT 8) $ (CONST_INT 32))
           $ TYPE%core!array.TryFromSliceError. (%Poly%core!result.Result. (Poly%core!result.Result.
             result!
       ))))))
       (= (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. arr$))
        (vstd!view.View.view.? $slice (SLICE $ (UINT 8)) (Poly%slice%<u8.>. bytes!))
   )))))
   :pattern ((ens%curve25519_dalek!core_assumes.try_into_32_bytes_array. bytes! result!))
   :qid internal_ens__curve25519_dalek!core_assumes.try_into_32_bytes_array._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.try_into_32_bytes_array._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::compressed_edwards_y_from_array_result
(declare-fun ens%curve25519_dalek!core_assumes.compressed_edwards_y_from_array_result.
 (core!result.Result. core!result.Result.) Bool
)
(assert
 (forall ((arr_result! core!result.Result.) (result! core!result.Result.)) (!
   (= (ens%curve25519_dalek!core_assumes.compressed_edwards_y_from_array_result. arr_result!
     result!
    ) (and
     (has_type (Poly%core!result.Result. result!) (TYPE%core!result.Result. $ TYPE%curve25519_dalek!edwards.CompressedEdwardsY.
       $ TYPE%core!array.TryFromSliceError.
     ))
     (= (is-core!result.Result./Ok arr_result!) (is-core!result.Result./Ok result!))
     (=>
      (is-core!result.Result./Ok arr_result!)
      (= (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. (curve25519_dalek!edwards.CompressedEdwardsY./CompressedEdwardsY/0
          (%Poly%curve25519_dalek!edwards.CompressedEdwardsY. (core!result.Result./Ok/0 $ TYPE%curve25519_dalek!edwards.CompressedEdwardsY.
            $ TYPE%core!array.TryFromSliceError. (%Poly%core!result.Result. (Poly%core!result.Result.
              result!
        ))))))
       ) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (core!result.Result./Ok/0
         $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) $ TYPE%core!array.TryFromSliceError. (%Poly%core!result.Result.
          (Poly%core!result.Result. arr_result!)
   )))))))
   :pattern ((ens%curve25519_dalek!core_assumes.compressed_edwards_y_from_array_result.
     arr_result! result!
   ))
   :qid internal_ens__curve25519_dalek!core_assumes.compressed_edwards_y_from_array_result._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.compressed_edwards_y_from_array_result._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::compressed_ristretto_from_array_result
(declare-fun ens%curve25519_dalek!core_assumes.compressed_ristretto_from_array_result.
 (core!result.Result. core!result.Result.) Bool
)
(assert
 (forall ((arr_result! core!result.Result.) (result! core!result.Result.)) (!
   (= (ens%curve25519_dalek!core_assumes.compressed_ristretto_from_array_result. arr_result!
     result!
    ) (and
     (has_type (Poly%core!result.Result. result!) (TYPE%core!result.Result. $ TYPE%curve25519_dalek!ristretto.CompressedRistretto.
       $ TYPE%core!array.TryFromSliceError.
     ))
     (= (is-core!result.Result./Ok arr_result!) (is-core!result.Result./Ok result!))
     (=>
      (is-core!result.Result./Ok arr_result!)
      (= (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. (curve25519_dalek!ristretto.CompressedRistretto./CompressedRistretto/0
          (%Poly%curve25519_dalek!ristretto.CompressedRistretto. (core!result.Result./Ok/0 $
            TYPE%curve25519_dalek!ristretto.CompressedRistretto. $ TYPE%core!array.TryFromSliceError.
            (%Poly%core!result.Result. (Poly%core!result.Result. result!))
        ))))
       ) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (core!result.Result./Ok/0
         $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) $ TYPE%core!array.TryFromSliceError. (%Poly%core!result.Result.
          (Poly%core!result.Result. arr_result!)
   )))))))
   :pattern ((ens%curve25519_dalek!core_assumes.compressed_ristretto_from_array_result.
     arr_result! result!
   ))
   :qid internal_ens__curve25519_dalek!core_assumes.compressed_ristretto_from_array_result._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.compressed_ristretto_from_array_result._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::first_32_bytes
(declare-fun ens%curve25519_dalek!core_assumes.first_32_bytes. (%%Function%% %%Function%%)
 Bool
)
(assert
 (forall ((bytes! %%Function%%) (result! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.first_32_bytes. bytes! result!) (and
     (has_type (Poly%array%. result!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 32)
         ))
         (= (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
              32
             )
            ) (Poly%array%. result!)
           ) i$
          ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
              64
             )
            ) (Poly%array%. bytes!)
           ) i$
       ))))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
           $ (CONST_INT 32)
          ) (Poly%array%. result!)
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
           $ (CONST_INT 64)
          ) (Poly%array%. bytes!)
         ) i$
       ))
       :qid user_curve25519_dalek__core_assumes__first_32_bytes_25
       :skolemid skolem_user_curve25519_dalek__core_assumes__first_32_bytes_25
     ))
     (= (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. result!))
      (vstd!seq.Seq.subrange.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
          64
         )
        ) (Poly%array%. bytes!)
       ) (I 0) (I 32)
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.first_32_bytes. bytes! result!))
   :qid internal_ens__curve25519_dalek!core_assumes.first_32_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.first_32_bytes._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::last_32_bytes
(declare-fun ens%curve25519_dalek!core_assumes.last_32_bytes. (%%Function%% %%Function%%)
 Bool
)
(assert
 (forall ((bytes! %%Function%%) (result! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.last_32_bytes. bytes! result!) (and
     (has_type (Poly%array%. result!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 32)
         ))
         (= (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
              32
             )
            ) (Poly%array%. result!)
           ) i$
          ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
              64
             )
            ) (Poly%array%. bytes!)
           ) (I (Add 32 (%I i$)))
       ))))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
           $ (CONST_INT 32)
          ) (Poly%array%. result!)
         ) i$
       ))
       :qid user_curve25519_dalek__core_assumes__last_32_bytes_26
       :skolemid skolem_user_curve25519_dalek__core_assumes__last_32_bytes_26
     ))
     (= (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (Poly%array%. result!))
      (vstd!seq.Seq.subrange.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
          64
         )
        ) (Poly%array%. bytes!)
       ) (I 32) (I 64)
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.last_32_bytes. bytes! result!))
   :qid internal_ens__curve25519_dalek!core_assumes.last_32_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.last_32_bytes._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::bytes32_8_to_24
(declare-fun ens%curve25519_dalek!core_assumes.bytes32_8_to_24. (%%Function%% %%Function%%)
 Bool
)
(assert
 (forall ((bytes! %%Function%%) (result! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.bytes32_8_to_24. bytes! result!) (and
     (has_type (Poly%array%. result!) (ARRAY $ (UINT 8) $ (CONST_INT 16)))
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 16)
         ))
         (= (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
              16
             )
            ) (Poly%array%. result!)
           ) i$
          ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
              32
             )
            ) (Poly%array%. bytes!)
           ) (I (Add 8 (%I i$)))
       ))))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
           $ (CONST_INT 16)
          ) (Poly%array%. result!)
         ) i$
       ))
       :qid user_curve25519_dalek__core_assumes__bytes32_8_to_24_27
       :skolemid skolem_user_curve25519_dalek__core_assumes__bytes32_8_to_24_27
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.bytes32_8_to_24. bytes! result!))
   :qid internal_ens__curve25519_dalek!core_assumes.bytes32_8_to_24._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.bytes32_8_to_24._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::write_bytes32_8_to_24
(declare-fun ens%curve25519_dalek!core_assumes.write_bytes32_8_to_24. (%%Function%%
  %%Function%% %%Function%%
 ) Bool
)
(assert
 (forall ((pre%dst! %%Function%%) (dst! %%Function%%) (src! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.write_bytes32_8_to_24. pre%dst! dst! src!) (
     and
     (has_type (Poly%array%. dst!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 16)
         ))
         (= (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
              32
             )
            ) (Poly%array%. dst!)
           ) (I (Add 8 (%I i$)))
          ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
              16
             )
            ) (Poly%array%. src!)
           ) i$
       ))))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
           $ (CONST_INT 16)
          ) (Poly%array%. src!)
         ) i$
       ))
       :qid user_curve25519_dalek__core_assumes__write_bytes32_8_to_24_28
       :skolemid skolem_user_curve25519_dalek__core_assumes__write_bytes32_8_to_24_28
     ))
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (or
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 8)
          ))
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 24 tmp%%$)
            (< tmp%%$ 32)
         )))
         (= (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
              32
             )
            ) (Poly%array%. dst!)
           ) i$
          ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
              32
             )
            ) (Poly%array%. pre%dst!)
           ) i$
       ))))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
           $ (CONST_INT 32)
          ) (Poly%array%. dst!)
         ) i$
       ))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
           $ (CONST_INT 32)
          ) (Poly%array%. pre%dst!)
         ) i$
       ))
       :qid user_curve25519_dalek__core_assumes__write_bytes32_8_to_24_29
       :skolemid skolem_user_curve25519_dalek__core_assumes__write_bytes32_8_to_24_29
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.write_bytes32_8_to_24. pre%dst! dst! src!))
   :qid internal_ens__curve25519_dalek!core_assumes.write_bytes32_8_to_24._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.write_bytes32_8_to_24._definition
)))

;; Function-Specs core::fmt::impl&%11::write_str
(declare-fun ens%core!fmt.impl&%11.write_str. (core!fmt.Formatter. core!fmt.Formatter.
  strslice%. core!result.Result.
 ) Bool
)
(assert
 (forall ((pre%_0! core!fmt.Formatter.) (_0! core!fmt.Formatter.) (_1! strslice%.) (
    %return! core!result.Result.
   )
  ) (!
   (= (ens%core!fmt.impl&%11.write_str. pre%_0! _0! _1! %return!) (has_type (Poly%core!result.Result.
      %return!
     ) (TYPE%core!result.Result. $ TYPE%tuple%0. $ TYPE%core!fmt.Error.)
   ))
   :pattern ((ens%core!fmt.impl&%11.write_str. pre%_0! _0! _1! %return!))
   :qid internal_ens__core!fmt.impl&__11.write_str._definition
   :skolemid skolem_internal_ens__core!fmt.impl&__11.write_str._definition
)))

;; Function-Specs curve25519_dalek::specs::core_specs::bytes_as_nat_prefix
(declare-fun req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. (Poly Poly)
 Bool
)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((bytes! Poly) (j! Poly)) (!
   (= (req%curve25519_dalek!specs.core_specs.bytes_as_nat_prefix. bytes! j!) (=>
     %%global_location_label%%6
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

;; Function-Specs curve25519_dalek::core_assumes::u16_to_le_bytes
(declare-fun ens%curve25519_dalek!core_assumes.u16_to_le_bytes. (Int %%Function%%)
 Bool
)
(assert
 (forall ((x! Int) (bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.u16_to_le_bytes. x! bytes!) (and
     (has_type (Poly%array%. bytes!) (ARRAY $ (UINT 8) $ (CONST_INT 2)))
     (= (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.? $
        (ARRAY $ (UINT 8) $ (CONST_INT 2)) (Poly%array%. bytes!)
       ) (I 2)
      ) x!
   )))
   :pattern ((ens%curve25519_dalek!core_assumes.u16_to_le_bytes. x! bytes!))
   :qid internal_ens__curve25519_dalek!core_assumes.u16_to_le_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.u16_to_le_bytes._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::u32_to_le_bytes
(declare-fun ens%curve25519_dalek!core_assumes.u32_to_le_bytes. (Int %%Function%%)
 Bool
)
(assert
 (forall ((x! Int) (bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.u32_to_le_bytes. x! bytes!) (and
     (has_type (Poly%array%. bytes!) (ARRAY $ (UINT 8) $ (CONST_INT 4)))
     (= (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.? $
        (ARRAY $ (UINT 8) $ (CONST_INT 4)) (Poly%array%. bytes!)
       ) (I 4)
      ) x!
   )))
   :pattern ((ens%curve25519_dalek!core_assumes.u32_to_le_bytes. x! bytes!))
   :qid internal_ens__curve25519_dalek!core_assumes.u32_to_le_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.u32_to_le_bytes._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::u64_to_le_bytes
(declare-fun ens%curve25519_dalek!core_assumes.u64_to_le_bytes. (Int %%Function%%)
 Bool
)
(assert
 (forall ((x! Int) (bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.u64_to_le_bytes. x! bytes!) (and
     (has_type (Poly%array%. bytes!) (ARRAY $ (UINT 8) $ (CONST_INT 8)))
     (= (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.? $
        (ARRAY $ (UINT 8) $ (CONST_INT 8)) (Poly%array%. bytes!)
       ) (I 8)
      ) x!
   )))
   :pattern ((ens%curve25519_dalek!core_assumes.u64_to_le_bytes. x! bytes!))
   :qid internal_ens__curve25519_dalek!core_assumes.u64_to_le_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.u64_to_le_bytes._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::u128_to_le_bytes
(declare-fun ens%curve25519_dalek!core_assumes.u128_to_le_bytes. (Int %%Function%%)
 Bool
)
(assert
 (forall ((x! Int) (bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.u128_to_le_bytes. x! bytes!) (and
     (has_type (Poly%array%. bytes!) (ARRAY $ (UINT 8) $ (CONST_INT 16)))
     (= (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.? $
        (ARRAY $ (UINT 8) $ (CONST_INT 16)) (Poly%array%. bytes!)
       ) (I 16)
      ) x!
   )))
   :pattern ((ens%curve25519_dalek!core_assumes.u128_to_le_bytes. x! bytes!))
   :qid internal_ens__curve25519_dalek!core_assumes.u128_to_le_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.u128_to_le_bytes._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::u16_from_le_bytes
(declare-fun ens%curve25519_dalek!core_assumes.u16_from_le_bytes. (%%Function%% Int)
 Bool
)
(assert
 (forall ((bytes! %%Function%%) (x! Int)) (!
   (= (ens%curve25519_dalek!core_assumes.u16_from_le_bytes. bytes! x!) (and
     (uInv 16 x!)
     (= x! (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
        $ (ARRAY $ (UINT 8) $ (CONST_INT 2)) (Poly%array%. bytes!)
       ) (I 2)
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.u16_from_le_bytes. bytes! x!))
   :qid internal_ens__curve25519_dalek!core_assumes.u16_from_le_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.u16_from_le_bytes._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::u32_from_le_bytes
(declare-fun ens%curve25519_dalek!core_assumes.u32_from_le_bytes. (%%Function%% Int)
 Bool
)
(assert
 (forall ((bytes! %%Function%%) (x! Int)) (!
   (= (ens%curve25519_dalek!core_assumes.u32_from_le_bytes. bytes! x!) (and
     (uInv 32 x!)
     (= x! (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
        $ (ARRAY $ (UINT 8) $ (CONST_INT 4)) (Poly%array%. bytes!)
       ) (I 4)
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.u32_from_le_bytes. bytes! x!))
   :qid internal_ens__curve25519_dalek!core_assumes.u32_from_le_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.u32_from_le_bytes._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::u64_from_le_bytes
(declare-fun ens%curve25519_dalek!core_assumes.u64_from_le_bytes. (%%Function%% Int)
 Bool
)
(assert
 (forall ((bytes! %%Function%%) (x! Int)) (!
   (= (ens%curve25519_dalek!core_assumes.u64_from_le_bytes. bytes! x!) (and
     (uInv 64 x!)
     (= x! (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
        $ (ARRAY $ (UINT 8) $ (CONST_INT 8)) (Poly%array%. bytes!)
       ) (I 8)
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.u64_from_le_bytes. bytes! x!))
   :qid internal_ens__curve25519_dalek!core_assumes.u64_from_le_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.u64_from_le_bytes._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::u128_from_le_bytes
(declare-fun ens%curve25519_dalek!core_assumes.u128_from_le_bytes. (%%Function%% Int)
 Bool
)
(assert
 (forall ((bytes! %%Function%%) (x! Int)) (!
   (= (ens%curve25519_dalek!core_assumes.u128_from_le_bytes. bytes! x!) (and
     (uInv 128 x!)
     (= x! (curve25519_dalek!specs.core_specs.bytes_as_nat_prefix.? (vstd!view.View.view.?
        $ (ARRAY $ (UINT 8) $ (CONST_INT 16)) (Poly%array%. bytes!)
       ) (I 16)
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.u128_from_le_bytes. bytes! x!))
   :qid internal_ens__curve25519_dalek!core_assumes.u128_from_le_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.u128_from_le_bytes._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::negate_field
(declare-fun ens%curve25519_dalek!core_assumes.negate_field. (Dcr Type Poly Poly)
 Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (a! Poly) (%return! Poly)) (!
   (= (ens%curve25519_dalek!core_assumes.negate_field. T&. T& a! %return!) (has_type %return!
     T&
   ))
   :pattern ((ens%curve25519_dalek!core_assumes.negate_field. T&. T& a! %return!))
   :qid internal_ens__curve25519_dalek!core_assumes.negate_field._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.negate_field._definition
)))

;; Function-Axioms curve25519_dalek::core_assumes::spec_state_after_hash
(assert
 (forall ((H&. Dcr) (H& Type) (T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (initial_state!
    Poly
   ) (bytes! Poly)
  ) (!
   (=>
    (and
     (has_type initial_state! H&)
     (has_type bytes! (ARRAY T&. T& N&. N&))
    )
    (has_type (curve25519_dalek!core_assumes.spec_state_after_hash.? H&. H& T&. T& N&.
      N& initial_state! bytes!
     ) H&
   ))
   :pattern ((curve25519_dalek!core_assumes.spec_state_after_hash.? H&. H& T&. T& N&.
     N& initial_state! bytes!
   ))
   :qid internal_curve25519_dalek!core_assumes.spec_state_after_hash.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!core_assumes.spec_state_after_hash.?_pre_post_definition
)))

;; Function-Specs core::array::impl&%11::hash
(declare-fun ens%core!array.impl&%11.hash. (Dcr Type Dcr Type Dcr Type %%Function%%
  Poly Poly
 ) Bool
)
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type) (H&. Dcr) (H& Type) (bytes! %%Function%%)
   (pre%state! Poly) (state! Poly)
  ) (!
   (= (ens%core!array.impl&%11.hash. T&. T& N&. N& H&. H& bytes! pre%state! state!) (
     and
     (has_type state! H&)
     (= state! (curve25519_dalek!core_assumes.spec_state_after_hash.? H&. H& T&. T& N&.
       N& pre%state! (Poly%array%. bytes!)
   ))))
   :pattern ((ens%core!array.impl&%11.hash. T&. T& N&. N& H&. H& bytes! pre%state! state!))
   :qid internal_ens__core!array.impl&__11.hash._definition
   :skolemid skolem_internal_ens__core!array.impl&__11.hash._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::zeroize_bytes32
(declare-fun ens%curve25519_dalek!core_assumes.zeroize_bytes32. (%%Function%% %%Function%%)
 Bool
)
(assert
 (forall ((pre%bytes! %%Function%%) (bytes! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.zeroize_bytes32. pre%bytes! bytes!) (and
     (has_type (Poly%array%. bytes!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ 32)
         ))
         (= (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (
               CONST_INT 32
              )
             ) (Poly%array%. bytes!)
            ) i$
           )
          ) 0
       )))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
           $ (CONST_INT 32)
          ) (Poly%array%. bytes!)
         ) i$
       ))
       :qid user_curve25519_dalek__core_assumes__zeroize_bytes32_30
       :skolemid skolem_user_curve25519_dalek__core_assumes__zeroize_bytes32_30
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.zeroize_bytes32. pre%bytes! bytes!))
   :qid internal_ens__curve25519_dalek!core_assumes.zeroize_bytes32._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.zeroize_bytes32._definition
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
       :qid user_curve25519_dalek__core_assumes__zeroize_limbs5_31
       :skolemid skolem_user_curve25519_dalek__core_assumes__zeroize_limbs5_31
   ))))
   :pattern ((ens%curve25519_dalek!core_assumes.zeroize_limbs5. pre%limbs! limbs!))
   :qid internal_ens__curve25519_dalek!core_assumes.zeroize_limbs5._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.zeroize_limbs5._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::zeroize_bool
(declare-fun ens%curve25519_dalek!core_assumes.zeroize_bool. (Bool Bool) Bool)
(assert
 (forall ((pre%b! Bool) (b! Bool)) (!
   (= (ens%curve25519_dalek!core_assumes.zeroize_bool. pre%b! b!) (= b! false))
   :pattern ((ens%curve25519_dalek!core_assumes.zeroize_bool. pre%b! b!))
   :qid internal_ens__curve25519_dalek!core_assumes.zeroize_bool._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.zeroize_bool._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::sha512_hash_bytes
(declare-fun ens%curve25519_dalek!core_assumes.sha512_hash_bytes. (slice%<u8.>. %%Function%%)
 Bool
)
(assert
 (forall ((input! slice%<u8.>.) (result! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.sha512_hash_bytes. input! result!) (and
     (has_type (Poly%array%. result!) (ARRAY $ (UINT 8) $ (CONST_INT 64)))
     (= (%Poly%vstd!seq.Seq<u8.>. (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 64))
        (Poly%array%. result!)
       )
      ) (curve25519_dalek!core_assumes.spec_sha512.? (vstd!view.View.view.? $slice (SLICE
         $ (UINT 8)
        ) (Poly%slice%<u8.>. input!)
     )))
     (=>
      (curve25519_dalek!specs.proba_specs.is_uniform_bytes.? (Poly%slice%<u8.>. input!))
      (curve25519_dalek!specs.proba_specs.is_uniform_bytes.? (vstd!array.spec_array_as_slice.?
        $ (UINT 8) $ (CONST_INT 64) (Poly%array%. result!)
   )))))
   :pattern ((ens%curve25519_dalek!core_assumes.sha512_hash_bytes. input! result!))
   :qid internal_ens__curve25519_dalek!core_assumes.sha512_hash_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.sha512_hash_bytes._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::sha256_hash_bytes
(declare-fun ens%curve25519_dalek!core_assumes.sha256_hash_bytes. (slice%<u8.>. %%Function%%)
 Bool
)
(assert
 (forall ((input! slice%<u8.>.) (result! %%Function%%)) (!
   (= (ens%curve25519_dalek!core_assumes.sha256_hash_bytes. input! result!) (and
     (has_type (Poly%array%. result!) (ARRAY $ (UINT 8) $ (CONST_INT 32)))
     (= (%Poly%vstd!seq.Seq<u8.>. (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32))
        (Poly%array%. result!)
       )
      ) (curve25519_dalek!core_assumes.spec_sha256.? (vstd!view.View.view.? $slice (SLICE
         $ (UINT 8)
        ) (Poly%slice%<u8.>. input!)
   )))))
   :pattern ((ens%curve25519_dalek!core_assumes.sha256_hash_bytes. input! result!))
   :qid internal_ens__curve25519_dalek!core_assumes.sha256_hash_bytes._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.sha256_hash_bytes._definition
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

;; Function-Axioms curve25519_dalek::specs::field_specs::field_element_from_bytes
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.field_element_from_bytes.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.field_element_from_bytes.)
  (forall ((bytes! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.field_element_from_bytes.? bytes!) (curve25519_dalek!specs.field_specs_u64.field_canonical.?
      (I (EucMod (curve25519_dalek!specs.core_specs.u8_32_as_nat.? bytes!) (vstd!arithmetic.power2.pow2.?
         (I 255)
    )))))
    :pattern ((curve25519_dalek!specs.field_specs.field_element_from_bytes.? bytes!))
    :qid internal_curve25519_dalek!specs.field_specs.field_element_from_bytes.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_element_from_bytes.?_definition
))))
(assert
 (forall ((bytes! Poly)) (!
   (=>
    (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (<= 0 (curve25519_dalek!specs.field_specs.field_element_from_bytes.? bytes!))
   )
   :pattern ((curve25519_dalek!specs.field_specs.field_element_from_bytes.? bytes!))
   :qid internal_curve25519_dalek!specs.field_specs.field_element_from_bytes.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.field_element_from_bytes.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_fe51_from_bytes
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.)
  (forall ((bytes! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.? bytes!) (let
      ((low_51_bit_mask$ curve25519_dalek!specs.field_specs_u64.mask51.?))
      (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51 (%Poly%array%.
        (array_new $ (UINT 64) 5 (%%array%%0 (I (uClip 64 (bitand (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) bytes!) (I 0)
              ))
             ) (I low_51_bit_mask$)
           ))
          ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                   (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) bytes!) (I 6)
                 ))
                ) (I 3)
              ))
             ) (I low_51_bit_mask$)
           ))
          ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                   (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) bytes!) (I 12)
                 ))
                ) (I 6)
              ))
             ) (I low_51_bit_mask$)
           ))
          ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                   (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) bytes!) (I 19)
                 ))
                ) (I 1)
              ))
             ) (I low_51_bit_mask$)
           ))
          ) (I (uClip 64 (bitand (I (uClip 64 (bitshr (I (uClip 64 (curve25519_dalek!specs.core_specs.spec_load8_at.?
                   (vstd!array.spec_array_as_slice.? $ (UINT 8) $ (CONST_INT 32) bytes!) (I 24)
                 ))
                ) (I 12)
              ))
             ) (I low_51_bit_mask$)
    )))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.? bytes!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.?_definition
))))
(assert
 (forall ((bytes! Poly)) (!
   (=>
    (has_type bytes! (ARRAY $ (UINT 8) $ (CONST_INT 32)))
    (has_type (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. (curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.?
       bytes!
      )
     ) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.
   ))
   :pattern ((curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.? bytes!))
   :qid internal_curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::field_specs::spec_fe51_as_bytes
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.)
)
(declare-fun %%array%%1 (Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly
  Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly Poly
  Poly Poly Poly
 ) %%Function%%
)
(assert
 (forall ((%%hole%%0 Poly) (%%hole%%1 Poly) (%%hole%%2 Poly) (%%hole%%3 Poly) (%%hole%%4
    Poly
   ) (%%hole%%5 Poly) (%%hole%%6 Poly) (%%hole%%7 Poly) (%%hole%%8 Poly) (%%hole%%9 Poly)
   (%%hole%%10 Poly) (%%hole%%11 Poly) (%%hole%%12 Poly) (%%hole%%13 Poly) (%%hole%%14
    Poly
   ) (%%hole%%15 Poly) (%%hole%%16 Poly) (%%hole%%17 Poly) (%%hole%%18 Poly) (%%hole%%19
    Poly
   ) (%%hole%%20 Poly) (%%hole%%21 Poly) (%%hole%%22 Poly) (%%hole%%23 Poly) (%%hole%%24
    Poly
   ) (%%hole%%25 Poly) (%%hole%%26 Poly) (%%hole%%27 Poly) (%%hole%%28 Poly) (%%hole%%29
    Poly
   ) (%%hole%%30 Poly) (%%hole%%31 Poly)
  ) (!
   (let
    ((%%x%% (%%array%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
       %%hole%%7 %%hole%%8 %%hole%%9 %%hole%%10 %%hole%%11 %%hole%%12 %%hole%%13 %%hole%%14
       %%hole%%15 %%hole%%16 %%hole%%17 %%hole%%18 %%hole%%19 %%hole%%20 %%hole%%21 %%hole%%22
       %%hole%%23 %%hole%%24 %%hole%%25 %%hole%%26 %%hole%%27 %%hole%%28 %%hole%%29 %%hole%%30
       %%hole%%31
    )))
    (and
     (= (%%apply%%1 %%x%% 0) %%hole%%0)
     (= (%%apply%%1 %%x%% 1) %%hole%%1)
     (= (%%apply%%1 %%x%% 2) %%hole%%2)
     (= (%%apply%%1 %%x%% 3) %%hole%%3)
     (= (%%apply%%1 %%x%% 4) %%hole%%4)
     (= (%%apply%%1 %%x%% 5) %%hole%%5)
     (= (%%apply%%1 %%x%% 6) %%hole%%6)
     (= (%%apply%%1 %%x%% 7) %%hole%%7)
     (= (%%apply%%1 %%x%% 8) %%hole%%8)
     (= (%%apply%%1 %%x%% 9) %%hole%%9)
     (= (%%apply%%1 %%x%% 10) %%hole%%10)
     (= (%%apply%%1 %%x%% 11) %%hole%%11)
     (= (%%apply%%1 %%x%% 12) %%hole%%12)
     (= (%%apply%%1 %%x%% 13) %%hole%%13)
     (= (%%apply%%1 %%x%% 14) %%hole%%14)
     (= (%%apply%%1 %%x%% 15) %%hole%%15)
     (= (%%apply%%1 %%x%% 16) %%hole%%16)
     (= (%%apply%%1 %%x%% 17) %%hole%%17)
     (= (%%apply%%1 %%x%% 18) %%hole%%18)
     (= (%%apply%%1 %%x%% 19) %%hole%%19)
     (= (%%apply%%1 %%x%% 20) %%hole%%20)
     (= (%%apply%%1 %%x%% 21) %%hole%%21)
     (= (%%apply%%1 %%x%% 22) %%hole%%22)
     (= (%%apply%%1 %%x%% 23) %%hole%%23)
     (= (%%apply%%1 %%x%% 24) %%hole%%24)
     (= (%%apply%%1 %%x%% 25) %%hole%%25)
     (= (%%apply%%1 %%x%% 26) %%hole%%26)
     (= (%%apply%%1 %%x%% 27) %%hole%%27)
     (= (%%apply%%1 %%x%% 28) %%hole%%28)
     (= (%%apply%%1 %%x%% 29) %%hole%%29)
     (= (%%apply%%1 %%x%% 30) %%hole%%30)
     (= (%%apply%%1 %%x%% 31) %%hole%%31)
   ))
   :pattern ((%%array%%1 %%hole%%0 %%hole%%1 %%hole%%2 %%hole%%3 %%hole%%4 %%hole%%5 %%hole%%6
     %%hole%%7 %%hole%%8 %%hole%%9 %%hole%%10 %%hole%%11 %%hole%%12 %%hole%%13 %%hole%%14
     %%hole%%15 %%hole%%16 %%hole%%17 %%hole%%18 %%hole%%19 %%hole%%20 %%hole%%21 %%hole%%22
     %%hole%%23 %%hole%%24 %%hole%%25 %%hole%%26 %%hole%%27 %%hole%%28 %%hole%%29 %%hole%%30
     %%hole%%31
   ))
   :qid __AIR_ARRAY_QID__
   :skolemid skolem___AIR_ARRAY_QID__
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.)
  (forall ((fe! Poly)) (!
    (= (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? fe!) (%Poly%vstd!seq.Seq<u8.>.
      (let
       ((limbs$ (curve25519_dalek!specs.field_specs_u64.spec_reduce.? (Poly%array%. (curve25519_dalek!backend.serial.u64.field.FieldElement51./FieldElement51/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51. fe!)
       )))))
       (let
        ((q0$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                  $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                 ) (I 0)
                )
               ) 19
             ))
            ) (I 51)
        ))))
        (let
         ((q1$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                   $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                  ) (I 1)
                 )
                ) q0$
              ))
             ) (I 51)
         ))))
         (let
          ((q2$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                   ) (I 2)
                  )
                 ) q1$
               ))
              ) (I 51)
          ))))
          (let
           ((q3$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                    ) (I 3)
                   )
                  ) q2$
                ))
               ) (I 51)
           ))))
           (let
            ((q$ (uClip 64 (bitshr (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                      $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                     ) (I 4)
                    )
                   ) q3$
                 ))
                ) (I 51)
            ))))
            (let
             ((limbs0_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                    $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                   ) (I 0)
                  )
                 ) (Mul 19 q$)
             ))))
             (let
              ((limbs1_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                     $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                    ) (I 1)
                   )
                  ) (uClip 64 (bitshr (I limbs0_adj$) (I 51)))
              ))))
              (let
               ((limbs0_canon$ (uClip 64 (uClip 64 (bitand (I limbs0_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
               (let
                ((limbs2_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                       $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                      ) (I 2)
                     )
                    ) (uClip 64 (bitshr (I limbs1_adj$) (I 51)))
                ))))
                (let
                 ((limbs1_canon$ (uClip 64 (uClip 64 (bitand (I limbs1_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                 (let
                  ((limbs3_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                         $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                        ) (I 3)
                       )
                      ) (uClip 64 (bitshr (I limbs2_adj$) (I 51)))
                  ))))
                  (let
                   ((limbs2_canon$ (uClip 64 (uClip 64 (bitand (I limbs2_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                   (let
                    ((limbs4_adj$ (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                           $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. limbs$)
                          ) (I 4)
                         )
                        ) (uClip 64 (bitshr (I limbs3_adj$) (I 51)))
                    ))))
                    (let
                     ((limbs3_canon$ (uClip 64 (uClip 64 (bitand (I limbs3_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                     (let
                      ((limbs4_canon$ (uClip 64 (uClip 64 (bitand (I limbs4_adj$) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))))
                      (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) (array_new $ (UINT 8)
                        32 (%%array%%1 (I (uClip 8 limbs0_canon$)) (I (uClip 8 (uClip 64 (bitshr (I limbs0_canon$)
                             (I 8)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs0_canon$) (I 16))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs0_canon$) (I 24)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs0_canon$) (I 32))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs0_canon$) (I 40)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I limbs0_canon$) (I 48)))) (I (uClip
                               64 (bitshl (I limbs1_canon$) (I 3))
                          )))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs1_canon$) (I 5))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs1_canon$) (I 13)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs1_canon$) (I 21))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs1_canon$) (I 29)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs1_canon$) (I 37))))) (I (uClip 8 (uClip 64 (
                             bitor (I (uClip 64 (bitshr (I limbs1_canon$) (I 45)))) (I (uClip 64 (bitshl (I limbs2_canon$)
                                (I 6)
                          ))))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs2_canon$) (I 2))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs2_canon$) (I 10)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs2_canon$) (I 18))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs2_canon$) (I 26)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs2_canon$) (I 34))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs2_canon$) (I 42)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitor (I (uClip 64 (bitshr (I limbs2_canon$) (I 50)))) (I (uClip
                               64 (bitshl (I limbs3_canon$) (I 1))
                          )))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs3_canon$) (I 7))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs3_canon$) (I 15)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs3_canon$) (I 23))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs3_canon$) (I 31)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs3_canon$) (I 39))))) (I (uClip 8 (uClip 64 (
                             bitor (I (uClip 64 (bitshr (I limbs3_canon$) (I 47)))) (I (uClip 64 (bitshl (I limbs4_canon$)
                                (I 4)
                          ))))))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs4_canon$) (I 4))))) (I (uClip 8 (uClip 64 (bitshr
                             (I limbs4_canon$) (I 12)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs4_canon$) (I 20))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs4_canon$) (I 28)
                          )))
                         ) (I (uClip 8 (uClip 64 (bitshr (I limbs4_canon$) (I 36))))) (I (uClip 8 (uClip 64 (
                             bitshr (I limbs4_canon$) (I 44)
    )))))))))))))))))))))))))
    :pattern ((curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? fe!))
    :qid internal_curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.?_definition
))))

;; Function-Axioms curve25519_dalek::core_assumes::seq_to_array_32
(assert
 (fuel_bool_default fuel%curve25519_dalek!core_assumes.seq_to_array_32.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!core_assumes.seq_to_array_32.)
  (forall ((s! Poly)) (!
    (= (curve25519_dalek!core_assumes.seq_to_array_32.? s!) (%Poly%array%. (array_new $
       (UINT 8) 32 (%%array%%1 (vstd!seq.Seq.index.? $ (UINT 8) s! (I 0)) (vstd!seq.Seq.index.?
         $ (UINT 8) s! (I 1)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 2)) (vstd!seq.Seq.index.? $ (UINT 8) s! (
          I 3
         )
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 4)) (vstd!seq.Seq.index.? $ (UINT 8) s! (
          I 5
         )
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 6)) (vstd!seq.Seq.index.? $ (UINT 8) s! (
          I 7
         )
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 8)) (vstd!seq.Seq.index.? $ (UINT 8) s! (
          I 9
         )
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 10)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 11)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 12)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 13)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 14)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 15)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 16)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 17)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 18)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 19)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 20)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 21)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 22)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 23)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 24)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 25)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 26)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 27)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 28)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 29)
        ) (vstd!seq.Seq.index.? $ (UINT 8) s! (I 30)) (vstd!seq.Seq.index.? $ (UINT 8) s!
         (I 31)
    )))))
    :pattern ((curve25519_dalek!core_assumes.seq_to_array_32.? s!))
    :qid internal_curve25519_dalek!core_assumes.seq_to_array_32.?_definition
    :skolemid skolem_internal_curve25519_dalek!core_assumes.seq_to_array_32.?_definition
))))
(assert
 (forall ((s! Poly)) (!
   (=>
    (has_type s! (TYPE%vstd!seq.Seq. $ (UINT 8)))
    (has_type (Poly%array%. (curve25519_dalek!core_assumes.seq_to_array_32.? s!)) (ARRAY
      $ (UINT 8) $ (CONST_INT 32)
   )))
   :pattern ((curve25519_dalek!core_assumes.seq_to_array_32.? s!))
   :qid internal_curve25519_dalek!core_assumes.seq_to_array_32.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!core_assumes.seq_to_array_32.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::core_assumes::seq_from2
(assert
 (fuel_bool_default fuel%curve25519_dalek!core_assumes.seq_from2.)
)
(declare-fun %%lambda%%1 (Dcr Type Poly) %%Function%%)
(assert
 (forall ((%%hole%%0 Dcr) (%%hole%%1 Type) (%%hole%%2 Poly) (i$ Poly)) (!
   (= (%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2) i$) (vstd!seq.Seq.index.?
     %%hole%%0 %%hole%%1 %%hole%%2 i$
   ))
   :pattern ((%%apply%%0 (%%lambda%%1 %%hole%%0 %%hole%%1 %%hole%%2) i$))
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!core_assumes.seq_from2.)
  (forall ((b! Poly)) (!
    (= (curve25519_dalek!core_assumes.seq_from2.? b!) (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.new.?
       $ (UINT 8) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 2) (Poly%fun%1. (mk_fun (%%lambda%%1
          $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 2)) b!)
    ))))))
    :pattern ((curve25519_dalek!core_assumes.seq_from2.? b!))
    :qid internal_curve25519_dalek!core_assumes.seq_from2.?_definition
    :skolemid skolem_internal_curve25519_dalek!core_assumes.seq_from2.?_definition
))))

;; Function-Axioms curve25519_dalek::core_assumes::seq_from4
(assert
 (fuel_bool_default fuel%curve25519_dalek!core_assumes.seq_from4.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!core_assumes.seq_from4.)
  (forall ((b! Poly)) (!
    (= (curve25519_dalek!core_assumes.seq_from4.? b!) (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.new.?
       $ (UINT 8) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 4) (Poly%fun%1. (mk_fun (%%lambda%%1
          $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 4)) b!)
    ))))))
    :pattern ((curve25519_dalek!core_assumes.seq_from4.? b!))
    :qid internal_curve25519_dalek!core_assumes.seq_from4.?_definition
    :skolemid skolem_internal_curve25519_dalek!core_assumes.seq_from4.?_definition
))))

;; Function-Axioms curve25519_dalek::core_assumes::seq_from8
(assert
 (fuel_bool_default fuel%curve25519_dalek!core_assumes.seq_from8.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!core_assumes.seq_from8.)
  (forall ((b! Poly)) (!
    (= (curve25519_dalek!core_assumes.seq_from8.? b!) (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.new.?
       $ (UINT 8) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 8) (Poly%fun%1. (mk_fun (%%lambda%%1
          $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 8)) b!)
    ))))))
    :pattern ((curve25519_dalek!core_assumes.seq_from8.? b!))
    :qid internal_curve25519_dalek!core_assumes.seq_from8.?_definition
    :skolemid skolem_internal_curve25519_dalek!core_assumes.seq_from8.?_definition
))))

;; Function-Axioms curve25519_dalek::core_assumes::seq_from16
(assert
 (fuel_bool_default fuel%curve25519_dalek!core_assumes.seq_from16.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!core_assumes.seq_from16.)
  (forall ((b! Poly)) (!
    (= (curve25519_dalek!core_assumes.seq_from16.? b!) (%Poly%vstd!seq.Seq<u8.>. (vstd!seq.Seq.new.?
       $ (UINT 8) $ (TYPE%fun%1. $ INT $ (UINT 8)) (I 16) (Poly%fun%1. (mk_fun (%%lambda%%1
          $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT 16)) b!)
    ))))))
    :pattern ((curve25519_dalek!core_assumes.seq_from16.? b!))
    :qid internal_curve25519_dalek!core_assumes.seq_from16.?_definition
    :skolemid skolem_internal_curve25519_dalek!core_assumes.seq_from16.?_definition
))))

;; Function-Axioms curve25519_dalek::core_assumes::seq_from32
(assert
 (fuel_bool_default fuel%curve25519_dalek!core_assumes.seq_from32.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!core_assumes.seq_from32.)
  (forall ((b! Poly)) (!
    (= (curve25519_dalek!core_assumes.seq_from32.? b!) (%Poly%vstd!seq.Seq<u8.>. (vstd!view.View.view.?
       $ (ARRAY $ (UINT 8) $ (CONST_INT 32)) b!
    )))
    :pattern ((curve25519_dalek!core_assumes.seq_from32.? b!))
    :qid internal_curve25519_dalek!core_assumes.seq_from32.?_definition
    :skolemid skolem_internal_curve25519_dalek!core_assumes.seq_from32.?_definition
))))

;; Function-Axioms curve25519_dalek::core_assumes::spec_state_after_hash_montgomery
(assert
 (fuel_bool_default fuel%curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.)
  (forall ((H&. Dcr) (H& Type) (initial_state! Poly) (point! Poly)) (!
    (= (curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.? H&. H& initial_state!
      point!
     ) (let
      ((canonical_seq$ (curve25519_dalek!specs.field_specs.spec_fe51_as_bytes.? (Poly%curve25519_dalek!backend.serial.u64.field.FieldElement51.
          (curve25519_dalek!specs.field_specs.spec_fe51_from_bytes.? (Poly%array%. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0
             (%Poly%curve25519_dalek!montgomery.MontgomeryPoint. point!)
      )))))))
      (let
       ((canonical_bytes$ (curve25519_dalek!core_assumes.seq_to_array_32.? (Poly%vstd!seq.Seq<u8.>.
           canonical_seq$
       ))))
       (curve25519_dalek!core_assumes.spec_state_after_hash.? H&. H& $ (UINT 8) $ (CONST_INT
         32
        ) initial_state! (Poly%array%. canonical_bytes$)
    ))))
    :pattern ((curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.? H&. H&
      initial_state! point!
    ))
    :qid internal_curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.?_definition
    :skolemid skolem_internal_curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.?_definition
))))
(assert
 (forall ((H&. Dcr) (H& Type) (initial_state! Poly) (point! Poly)) (!
   (=>
    (and
     (has_type initial_state! H&)
     (has_type point! TYPE%curve25519_dalek!montgomery.MontgomeryPoint.)
    )
    (has_type (curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.? H&. H&
      initial_state! point!
     ) H&
   ))
   :pattern ((curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.? H&. H&
     initial_state! point!
   ))
   :qid internal_curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.?_pre_post_definition
)))

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
 (tr_bound%core!ops.arith.Neg. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Neg. (REF $) (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!fmt.Debug. T&. T&)
    )
    (tr_bound%core!fmt.Debug. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!fmt.Debug. $ (ARRAY T&. T& N&. N&)))
   :qid internal_core__array__impl&__12_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__12_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized E&.)
     (tr_bound%core!fmt.Debug. T&. T&)
     (tr_bound%core!fmt.Debug. E&. E&)
    )
    (tr_bound%core!fmt.Debug. $ (TYPE%core!result.Result. T&. T& E&. E&))
   )
   :pattern ((tr_bound%core!fmt.Debug. $ (TYPE%core!result.Result. T&. T& E&. E&)))
   :qid internal_core__result__impl&__31_trait_impl_definition
   :skolemid skolem_internal_core__result__impl&__31_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%core!fmt.Debug. T&. T&)
    (tr_bound%core!fmt.Debug. (REF T&.) T&)
   )
   :pattern ((tr_bound%core!fmt.Debug. (REF T&.) T&))
   :qid internal_core__fmt__impl&__73_trait_impl_definition
   :skolemid skolem_internal_core__fmt__impl&__73_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $slice STRSLICE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!fmt.Debug. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!fmt.Debug. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_core__fmt__impl&__26_trait_impl_definition
   :skolemid skolem_internal_core__fmt__impl&__26_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!fmt.Debug. $ (PTR T&. T&))
   :pattern ((tr_bound%core!fmt.Debug. $ (PTR T&. T&)))
   :qid internal_core__fmt__impl&__27_trait_impl_definition
   :skolemid skolem_internal_core__fmt__impl&__27_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!fmt.Debug. T&. T&)
    )
    (tr_bound%core!fmt.Debug. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!fmt.Debug. $slice (SLICE T&. T&)))
   :qid internal_core__fmt__impl&__28_trait_impl_definition
   :skolemid skolem_internal_core__fmt__impl&__28_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ ALLOCATOR_GLOBAL)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (N&. Dcr) (N& Type)) (!
   (=>
    (and
     (sized T&.)
     (uInv SZ (const_int N&))
     (tr_bound%core!hash.Hash. T&. T&)
    )
    (tr_bound%core!hash.Hash. $ (ARRAY T&. T& N&. N&))
   )
   :pattern ((tr_bound%core!hash.Hash. $ (ARRAY T&. T& N&. N&)))
   :qid internal_core__array__impl&__11_trait_impl_definition
   :skolemid skolem_internal_core__array__impl&__11_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type) (E&. Dcr) (E& Type)) (!
   (=>
    (and
     (sized T&.)
     (sized E&.)
     (tr_bound%core!hash.Hash. T&. T&)
     (tr_bound%core!hash.Hash. E&. E&)
    )
    (tr_bound%core!hash.Hash. $ (TYPE%core!result.Result. T&. T& E&. E&))
   )
   :pattern ((tr_bound%core!hash.Hash. $ (TYPE%core!result.Result. T&. T& E&. E&)))
   :qid internal_core__result__impl&__32_trait_impl_definition
   :skolemid skolem_internal_core__result__impl&__32_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ (UINT 8))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ (UINT 16))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ (UINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ (UINT 64))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ USIZE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ (SINT 32))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ (UINT 128))
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ BOOL)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ CHAR)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $slice STRSLICE)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ TYPE%tuple%0.)
)

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (and
     (sized T&.)
     (tr_bound%core!hash.Hash. T&. T&)
    )
    (tr_bound%core!hash.Hash. $slice (SLICE T&. T&))
   )
   :pattern ((tr_bound%core!hash.Hash. $slice (SLICE T&. T&)))
   :qid internal_core__hash__impls__impl&__4_trait_impl_definition
   :skolemid skolem_internal_core__hash__impls__impl&__4_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (=>
    (tr_bound%core!hash.Hash. T&. T&)
    (tr_bound%core!hash.Hash. (REF T&.) T&)
   )
   :pattern ((tr_bound%core!hash.Hash. (REF T&.) T&))
   :qid internal_core__hash__impls__impl&__5_trait_impl_definition
   :skolemid skolem_internal_core__hash__impls__impl&__5_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!hash.Hash. (CONST_PTR $) (PTR T&. T&))
   :pattern ((tr_bound%core!hash.Hash. (CONST_PTR $) (PTR T&. T&)))
   :qid internal_core__hash__impls__impl&__7_trait_impl_definition
   :skolemid skolem_internal_core__hash__impls__impl&__7_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (forall ((T&. Dcr) (T& Type)) (!
   (tr_bound%core!hash.Hash. $ (PTR T&. T&))
   :pattern ((tr_bound%core!hash.Hash. $ (PTR T&. T&)))
   :qid internal_core__hash__impls__impl&__8_trait_impl_definition
   :skolemid skolem_internal_core__hash__impls__impl&__8_trait_impl_definition
)))

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ TYPE%curve25519_dalek!montgomery.MontgomeryPoint.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ TYPE%curve25519_dalek!edwards.CompressedEdwardsY.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!ops.arith.Neg. (REF $) TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ TYPE%curve25519_dalek!backend.serial.u64.field.FieldElement51.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ TYPE%curve25519_dalek!montgomery.MontgomeryPoint.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!fmt.Debug. $ TYPE%curve25519_dalek!ristretto.CompressedRistretto.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ TYPE%curve25519_dalek!edwards.CompressedEdwardsY.)
)

;; Trait-Impl-Axiom
(assert
 (tr_bound%core!hash.Hash. $ TYPE%curve25519_dalek!ristretto.CompressedRistretto.)
)

;; Function-Specs curve25519_dalek::core_assumes::axiom_sha256_output_length
(declare-fun ens%curve25519_dalek!core_assumes.axiom_sha256_output_length. (vstd!seq.Seq<u8.>.)
 Bool
)
(assert
 (forall ((input! vstd!seq.Seq<u8.>.)) (!
   (= (ens%curve25519_dalek!core_assumes.axiom_sha256_output_length. input!) (= (vstd!seq.Seq.len.?
      $ (UINT 8) (Poly%vstd!seq.Seq<u8.>. (curve25519_dalek!core_assumes.spec_sha256.? (Poly%vstd!seq.Seq<u8.>.
         input!
      )))
     ) 32
   ))
   :pattern ((ens%curve25519_dalek!core_assumes.axiom_sha256_output_length. input!))
   :qid internal_ens__curve25519_dalek!core_assumes.axiom_sha256_output_length._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.axiom_sha256_output_length._definition
)))

;; Function-Specs curve25519_dalek::core_assumes::axiom_hash_is_canonical
(declare-fun req%curve25519_dalek!core_assumes.axiom_hash_is_canonical. (Dcr Type curve25519_dalek!montgomery.MontgomeryPoint.
  curve25519_dalek!montgomery.MontgomeryPoint. Poly
 ) Bool
)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((H&. Dcr) (H& Type) (point1! curve25519_dalek!montgomery.MontgomeryPoint.)
   (point2! curve25519_dalek!montgomery.MontgomeryPoint.) (state! Poly)
  ) (!
   (= (req%curve25519_dalek!core_assumes.axiom_hash_is_canonical. H&. H& point1! point2!
     state!
    ) (=>
     %%global_location_label%%7
     (= (curve25519_dalek!specs.field_specs.field_element_from_bytes.? (Poly%array%. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0
         (%Poly%curve25519_dalek!montgomery.MontgomeryPoint. (Poly%curve25519_dalek!montgomery.MontgomeryPoint.
           point1!
       ))))
      ) (curve25519_dalek!specs.field_specs.field_element_from_bytes.? (Poly%array%. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0
         (%Poly%curve25519_dalek!montgomery.MontgomeryPoint. (Poly%curve25519_dalek!montgomery.MontgomeryPoint.
           point2!
   ))))))))
   :pattern ((req%curve25519_dalek!core_assumes.axiom_hash_is_canonical. H&. H& point1!
     point2! state!
   ))
   :qid internal_req__curve25519_dalek!core_assumes.axiom_hash_is_canonical._definition
   :skolemid skolem_internal_req__curve25519_dalek!core_assumes.axiom_hash_is_canonical._definition
)))
(declare-fun ens%curve25519_dalek!core_assumes.axiom_hash_is_canonical. (Dcr Type curve25519_dalek!montgomery.MontgomeryPoint.
  curve25519_dalek!montgomery.MontgomeryPoint. Poly
 ) Bool
)
(assert
 (forall ((H&. Dcr) (H& Type) (point1! curve25519_dalek!montgomery.MontgomeryPoint.)
   (point2! curve25519_dalek!montgomery.MontgomeryPoint.) (state! Poly)
  ) (!
   (= (ens%curve25519_dalek!core_assumes.axiom_hash_is_canonical. H&. H& point1! point2!
     state!
    ) (= (curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.? H&. H& state!
      (Poly%curve25519_dalek!montgomery.MontgomeryPoint. point1!)
     ) (curve25519_dalek!core_assumes.spec_state_after_hash_montgomery.? H&. H& state!
      (Poly%curve25519_dalek!montgomery.MontgomeryPoint. point2!)
   )))
   :pattern ((ens%curve25519_dalek!core_assumes.axiom_hash_is_canonical. H&. H& point1!
     point2! state!
   ))
   :qid internal_ens__curve25519_dalek!core_assumes.axiom_hash_is_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!core_assumes.axiom_hash_is_canonical._definition
)))

;; Function-Def curve25519_dalek::core_assumes::axiom_hash_is_canonical
;; curve25519-dalek/src/core_assumes.rs:286:1: 290:2 (#0)
(get-info :all-statistics)
(push)
 (declare-const H&. Dcr)
 (declare-const H& Type)
 (declare-const point1! curve25519_dalek!montgomery.MontgomeryPoint.)
 (declare-const point2! curve25519_dalek!montgomery.MontgomeryPoint.)
 (declare-const state! Poly)
 (assert
  fuel_defaults
 )
 (assert
  (sized H&.)
 )
 (assert
  (has_type (Poly%curve25519_dalek!montgomery.MontgomeryPoint. point1!) TYPE%curve25519_dalek!montgomery.MontgomeryPoint.)
 )
 (assert
  (has_type (Poly%curve25519_dalek!montgomery.MontgomeryPoint. point2!) TYPE%curve25519_dalek!montgomery.MontgomeryPoint.)
 )
 (assert
  (has_type state! H&)
 )
 (assert
  (= (curve25519_dalek!specs.field_specs.field_element_from_bytes.? (Poly%array%. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0
      (%Poly%curve25519_dalek!montgomery.MontgomeryPoint. (Poly%curve25519_dalek!montgomery.MontgomeryPoint.
        point1!
    ))))
   ) (curve25519_dalek!specs.field_specs.field_element_from_bytes.? (Poly%array%. (curve25519_dalek!montgomery.MontgomeryPoint./MontgomeryPoint/0
      (%Poly%curve25519_dalek!montgomery.MontgomeryPoint. (Poly%curve25519_dalek!montgomery.MontgomeryPoint.
        point2!
 )))))))
 (assert
  (not true)
 )
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
