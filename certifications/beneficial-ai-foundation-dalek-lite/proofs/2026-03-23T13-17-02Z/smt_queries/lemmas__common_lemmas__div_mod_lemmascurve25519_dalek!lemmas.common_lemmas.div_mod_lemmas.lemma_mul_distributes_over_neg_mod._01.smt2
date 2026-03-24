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

;; MODULE 'module lemmas::common_lemmas::div_mod_lemmas'
;; curve25519-dalek/src/lemmas/common_lemmas/div_mod_lemmas.rs:295:5: 295:11 (#0)

;; query spun off because: nonlinear

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_is_ordered. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered.
 FuelId
)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_self_0. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_twice. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_sub_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod.
 FuelId
)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_breakdown. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_inequality. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
(declare-const fuel%vstd!bits.lemma_u64_shr_is_div. FuelId)
(declare-const fuel%vstd!bits.lemma_u32_shr_is_div. FuelId)
(declare-const fuel%vstd!bits.lemma_u16_shr_is_div. FuelId)
(declare-const fuel%vstd!bits.lemma_u8_shr_is_div. FuelId)
(declare-const fuel%vstd!bits.low_bits_mask. FuelId)
(declare-const fuel%vstd!bits.lemma_u64_low_bits_mask_is_mod. FuelId)
(declare-const fuel%vstd!bits.lemma_u32_low_bits_mask_is_mod. FuelId)
(declare-const fuel%vstd!bits.lemma_u16_low_bits_mask_is_mod. FuelId)
(declare-const fuel%vstd!bits.lemma_u8_low_bits_mask_is_mod. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_div_is_ordered. fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod.
  fuel%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple.
  fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered. fuel%vstd!arithmetic.div_mod.lemma_mod_self_0.
  fuel%vstd!arithmetic.div_mod.lemma_mod_twice. fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic.
  fuel%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop.
  fuel%vstd!arithmetic.div_mod.lemma_sub_mod_noop. fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod.
  fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. fuel%vstd!arithmetic.div_mod.lemma_mod_breakdown.
  fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. fuel%vstd!arithmetic.mul.lemma_mul_inequality.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub.
  fuel%vstd!arithmetic.power2.lemma_pow2_pos. fuel%vstd!bits.lemma_u64_shr_is_div.
  fuel%vstd!bits.lemma_u32_shr_is_div. fuel%vstd!bits.lemma_u16_shr_is_div. fuel%vstd!bits.lemma_u8_shr_is_div.
  fuel%vstd!bits.low_bits_mask. fuel%vstd!bits.lemma_u64_low_bits_mask_is_mod. fuel%vstd!bits.lemma_u32_low_bits_mask_is_mod.
  fuel%vstd!bits.lemma_u16_low_bits_mask_is_mod. fuel%vstd!bits.lemma_u8_low_bits_mask_is_mod.
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
  (fuel_bool_default fuel%vstd!seq_lib.group_seq_lib_default.)
  (fuel_bool_default fuel%vstd!seq_lib.group_filter_ensures.)
))
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

;; Datatypes
(declare-datatypes ((tuple%0. 0)) (((tuple%0./tuple%0))))
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
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

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::bits::low_bits_mask
(declare-fun vstd!bits.low_bits_mask.? (Poly) Int)

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_is_ordered
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_is_ordered. (Int Int Int) Bool)
(declare-const %%global_location_label%%0 Bool)
(declare-const %%global_location_label%%1 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_is_ordered. x! y! z!) (and
     (=>
      %%global_location_label%%0
      (<= x! y!)
     )
     (=>
      %%global_location_label%%1
      (< 0 z!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_div_is_ordered. x! y! z!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_div_is_ordered._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_div_is_ordered._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_div_is_ordered. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_div_is_ordered. x! y! z!) (<= (EucDiv x! z!)
     (EucDiv y! z!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_div_is_ordered. x! y! z!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_div_is_ordered._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_div_is_ordered._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_div_is_ordered
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_div_is_ordered.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (=>
     (and
      (<= x! y!)
      (< 0 z!)
     )
     (<= (EucDiv x! z!) (EucDiv y! z!))
    )
    :pattern ((EucDiv x! z!) (EucDiv y! z!))
    :qid user_vstd__arithmetic__div_mod__lemma_div_is_ordered_0
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_is_ordered_0
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_small_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(declare-const %%global_location_label%%2 Bool)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (and
     (=>
      %%global_location_label%%2
      (< x! m!)
     )
     (=>
      %%global_location_label%%3
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

;; Function-Specs vstd::arithmetic::div_mod::lemma_fundamental_div_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. (Int Int) Bool)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (=>
     %%global_location_label%%4
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
    :qid user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_1
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_1
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_multiples_vanish_fancy
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. (Int Int
  Int
 ) Bool
)
(declare-const %%global_location_label%%5 Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (b! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. x! b! d!) (and
     (=>
      %%global_location_label%%5
      (< 0 d!)
     )
     (=>
      %%global_location_label%%6
      (let
       ((tmp%%$ b!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ d!)
   )))))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. x! b! d!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. (Int Int
  Int
 ) Bool
)
(assert
 (forall ((x! Int) (b! Int) (d! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. x! b! d!) (= (EucDiv
      (Add (Mul d! x!) b!) d!
     ) x!
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy. x! b! d!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_div_multiples_vanish_fancy
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_div_multiples_vanish_fancy.)
  (forall ((x! Int) (b! Int) (d! Int)) (!
    (=>
     (and
      (< 0 d!)
      (let
       ((tmp%%$ b!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ d!)
     )))
     (= (EucDiv (Add (Mul d! x!) b!) d!) x!)
    )
    :pattern ((EucDiv (Add (Mul d! x!) b!) d!))
    :qid user_vstd__arithmetic__div_mod__lemma_div_multiples_vanish_fancy_2
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_multiples_vanish_fancy_2
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_by_multiple
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_by_multiple. (Int Int) Bool)
(declare-const %%global_location_label%%7 Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((b! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_by_multiple. b! d!) (and
     (=>
      %%global_location_label%%7
      (<= 0 b!)
     )
     (=>
      %%global_location_label%%8
      (< 0 d!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_div_by_multiple. b! d!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_div_by_multiple._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_div_by_multiple._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_div_by_multiple. (Int Int) Bool)
(assert
 (forall ((b! Int) (d! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_div_by_multiple. b! d!) (= (EucDiv (Mul b! d!)
      d!
     ) b!
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_div_by_multiple. b! d!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_div_by_multiple._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_div_by_multiple._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_div_by_multiple
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple.)
  (forall ((b! Int) (d! Int)) (!
    (=>
     (and
      (<= 0 b!)
      (< 0 d!)
     )
     (= (EucDiv (Mul b! d!) d!) b!)
    )
    :pattern ((EucDiv (Mul b! d!) d!))
    :qid user_vstd__arithmetic__div_mod__lemma_div_by_multiple_3
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_by_multiple_3
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_by_multiple_is_strongly_ordered
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%9 Bool)
(declare-const %%global_location_label%%10 Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered. x! y! m!
     z!
    ) (and
     (=>
      %%global_location_label%%9
      (< x! y!)
     )
     (=>
      %%global_location_label%%10
      (= y! (Mul m! z!))
     )
     (=>
      %%global_location_label%%11
      (< 0 z!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered. x!
     y! m! z!
   ))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (y! Int) (m! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered. x! y! m!
     z!
    ) (< (EucDiv x! z!) (EucDiv y! z!))
   )
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered. x!
     y! m! z!
   ))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_div_by_multiple_is_strongly_ordered
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered.)
  (forall ((x! Int) (y! Int) (m! Int) (z! Int)) (!
    (=>
     (and
      (and
       (< x! y!)
       (= y! (Mul m! z!))
      )
      (< 0 z!)
     )
     (< (EucDiv x! z!) (EucDiv y! z!))
    )
    :pattern ((EucDiv x! z!) (Mul m! z!) (EucDiv y! z!))
    :qid user_vstd__arithmetic__div_mod__lemma_div_by_multiple_is_strongly_ordered_4
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_by_multiple_is_strongly_ordered_4
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_self_0
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_self_0. (Int) Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_self_0. m!) (=>
     %%global_location_label%%12
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_self_0. m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_self_0. (Int) Bool)
(assert
 (forall ((m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_self_0. m!) (= (EucMod m! m!) 0))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_self_0. m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_self_0._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_self_0
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_self_0.)
  (forall ((m! Int)) (!
    (=>
     (> m! 0)
     (= (EucMod m! m!) 0)
    )
    :pattern ((EucMod m! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_self_0_5
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_self_0_5
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_twice
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_twice. (Int Int) Bool)
(declare-const %%global_location_label%%13 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!) (=>
     %%global_location_label%%13
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_twice._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_twice._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_twice. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!) (= (EucMod (EucMod x! m!) m!)
     (EucMod x! m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_twice._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_twice._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_twice
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_twice.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (> m! 0)
     (= (EucMod (EucMod x! m!) m!) (EucMod x! m!))
    )
    :pattern ((EucMod (EucMod x! m!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_twice_6
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_twice_6
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_multiples_basic
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. (Int Int) Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!) (=>
     %%global_location_label%%14
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!) (= (EucMod (Mul x!
       m!
      ) m!
     ) 0
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_multiples_basic._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_multiples_basic
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (> m! 0)
     (= (EucMod (Mul x! m!) m!) 0)
    )
    :pattern ((EucMod (Mul x! m!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_multiples_basic_7
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_multiples_basic_7
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_add_multiples_vanish
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. (Int Int)
 Bool
)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((b! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. b! m!) (=>
     %%global_location_label%%15
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. b! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. (Int Int)
 Bool
)
(assert
 (forall ((b! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. b! m!) (= (EucMod (Add
       m! b!
      ) m!
     ) (EucMod b! m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. b! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_add_multiples_vanish
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish.)
  (forall ((b! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Add m! b!) m!) (EucMod b! m!))
    )
    :pattern ((EucMod b! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_add_multiples_vanish_8
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_add_multiples_vanish_8
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_add_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_add_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%16 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!) (=>
     %%global_location_label%%16
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_add_mod_noop. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!) (= (EucMod (Add (EucMod
        x! m!
       ) (EucMod y! m!)
      ) m!
     ) (EucMod (Add x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_add_mod_noop._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_add_mod_noop
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Add (EucMod x! m!) (EucMod y! m!)) m!) (EucMod (Add x! y!) m!))
    )
    :pattern ((EucMod (Add x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_add_mod_noop_9
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_add_mod_noop_9
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_sub_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_sub_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_sub_mod_noop. x! y! m!) (=>
     %%global_location_label%%17
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_sub_mod_noop. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_sub_mod_noop._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_sub_mod_noop._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_sub_mod_noop. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_sub_mod_noop. x! y! m!) (= (EucMod (Sub (EucMod
        x! m!
       ) (EucMod y! m!)
      ) m!
     ) (EucMod (Sub x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_sub_mod_noop. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_sub_mod_noop._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_sub_mod_noop._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_sub_mod_noop
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_sub_mod_noop.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Sub (EucMod x! m!) (EucMod y! m!)) m!) (EucMod (Sub x! y!) m!))
    )
    :pattern ((EucMod (Sub x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_sub_mod_noop_10
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_sub_mod_noop_10
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_fundamental_div_mod_converse_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod. (
  Int Int Int Int
 ) Bool
)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(declare-const %%global_location_label%%20 Bool)
(assert
 (forall ((x! Int) (d! Int) (q! Int) (r! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod. x! d! q! r!)
    (and
     (=>
      %%global_location_label%%18
      (not (= d! 0))
     )
     (=>
      %%global_location_label%%19
      (let
       ((tmp%%$ r!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ d!)
     )))
     (=>
      %%global_location_label%%20
      (= x! (Add (Mul q! d!) r!))
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod. x! d!
     q! r!
   ))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod. (
  Int Int Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (d! Int) (q! Int) (r! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod. x! d! q! r!)
    (= r! (EucMod x! d!))
   )
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod. x! d!
     q! r!
   ))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_fundamental_div_mod_converse_mod
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod.)
  (forall ((x! Int) (d! Int) (q! Int) (r! Int)) (!
    (=>
     (and
      (and
       (not (= d! 0))
       (let
        ((tmp%%$ r!))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ d!)
      )))
      (= x! (Add (Mul q! d!) r!))
     )
     (= r! (EucMod x! d!))
    )
    :pattern ((Add (Mul q! d!) r!) (EucMod x! d!))
    :qid user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_converse_mod_11
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_converse_mod_11
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_right
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. (Int Int Int) Bool)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!) (=>
     %%global_location_label%%21
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!) (= (EucMod (Mul x!
       (EucMod y! m!)
      ) m!
     ) (EucMod (Mul x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_right._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mul_mod_noop_right
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Mul x! (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
    )
    :pattern ((EucMod (Mul x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_12
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_12
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_breakdown
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_breakdown. (Int Int Int) Bool)
(declare-const %%global_location_label%%22 Bool)
(declare-const %%global_location_label%%23 Bool)
(declare-const %%global_location_label%%24 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_breakdown. x! y! z!) (and
     (=>
      %%global_location_label%%22
      (<= 0 x!)
     )
     (=>
      %%global_location_label%%23
      (< 0 y!)
     )
     (=>
      %%global_location_label%%24
      (< 0 z!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_breakdown. x! y! z!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_breakdown._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_breakdown._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_breakdown. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_breakdown. x! y! z!) (and
     (> (Mul y! z!) 0)
     (= (EucMod x! (Mul y! z!)) (Add (Mul y! (EucMod (EucDiv x! y!) z!)) (EucMod x! y!)))
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_breakdown. x! y! z!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_breakdown._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_breakdown._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_breakdown
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_breakdown.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (=>
     (and
      (and
       (<= 0 x!)
       (< 0 y!)
      )
      (< 0 z!)
     )
     (and
      (> (Mul y! z!) 0)
      (= (EucMod x! (Mul y! z!)) (Add (Mul y! (EucMod (EucDiv x! y!) z!)) (EucMod x! y!)))
    ))
    :pattern ((EucMod x! (Mul y! z!)))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_breakdown_13
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_breakdown_13
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_14
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_14
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_inequality
(declare-fun req%vstd!arithmetic.mul.lemma_mul_inequality. (Int Int Int) Bool)
(declare-const %%global_location_label%%25 Bool)
(declare-const %%global_location_label%%26 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_inequality. x! y! z!) (and
     (=>
      %%global_location_label%%25
      (<= x! y!)
     )
     (=>
      %%global_location_label%%26
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
    :qid user_vstd__arithmetic__mul__lemma_mul_inequality_15
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_inequality_15
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_16
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_16
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_distributive_sub
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. (Int Int Int)
 Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. x! y! z!) (= (Mul x! (Sub
       y! z!
      )
     ) (Sub (Mul x! y!) (Mul x! z!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_distributive_sub
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul x! (Sub y! z!)) (Sub (Mul x! y!) (Mul x! z!)))
    :pattern ((Mul x! (Sub y! z!)))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_17
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_17
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_18
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_18
))))

;; Function-Specs vstd::bits::lemma_u64_shr_is_div
(declare-fun req%vstd!bits.lemma_u64_shr_is_div. (Int Int) Bool)
(declare-const %%global_location_label%%27 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u64_shr_is_div. x! shift!) (=>
     %%global_location_label%%27
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
    :qid user_vstd__bits__lemma_u64_shr_is_div_19
    :skolemid skolem_user_vstd__bits__lemma_u64_shr_is_div_19
))))

;; Function-Specs vstd::bits::lemma_u32_shr_is_div
(declare-fun req%vstd!bits.lemma_u32_shr_is_div. (Int Int) Bool)
(declare-const %%global_location_label%%28 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u32_shr_is_div. x! shift!) (=>
     %%global_location_label%%28
     (let
      ((tmp%%$ shift!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ 32)
   ))))
   :pattern ((req%vstd!bits.lemma_u32_shr_is_div. x! shift!))
   :qid internal_req__vstd!bits.lemma_u32_shr_is_div._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u32_shr_is_div._definition
)))
(declare-fun ens%vstd!bits.lemma_u32_shr_is_div. (Int Int) Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (ens%vstd!bits.lemma_u32_shr_is_div. x! shift!) (= (uClip 32 (bitshr (I x!) (I shift!)))
     (EucDiv x! (vstd!arithmetic.power2.pow2.? (I shift!)))
   ))
   :pattern ((ens%vstd!bits.lemma_u32_shr_is_div. x! shift!))
   :qid internal_ens__vstd!bits.lemma_u32_shr_is_div._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u32_shr_is_div._definition
)))

;; Broadcast vstd::bits::lemma_u32_shr_is_div
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u32_shr_is_div.)
  (forall ((x! Poly) (shift! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 32))
      (has_type shift! (UINT 32))
     )
     (=>
      (let
       ((tmp%%$ (%I shift!)))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 32)
      ))
      (= (uClip 32 (bitshr (I (%I x!)) (I (%I shift!)))) (EucDiv (%I x!) (vstd!arithmetic.power2.pow2.?
         shift!
    )))))
    :pattern ((uClip 32 (bitshr (I (%I x!)) (I (%I shift!)))))
    :qid user_vstd__bits__lemma_u32_shr_is_div_20
    :skolemid skolem_user_vstd__bits__lemma_u32_shr_is_div_20
))))

;; Function-Specs vstd::bits::lemma_u16_shr_is_div
(declare-fun req%vstd!bits.lemma_u16_shr_is_div. (Int Int) Bool)
(declare-const %%global_location_label%%29 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u16_shr_is_div. x! shift!) (=>
     %%global_location_label%%29
     (let
      ((tmp%%$ shift!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ 16)
   ))))
   :pattern ((req%vstd!bits.lemma_u16_shr_is_div. x! shift!))
   :qid internal_req__vstd!bits.lemma_u16_shr_is_div._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u16_shr_is_div._definition
)))
(declare-fun ens%vstd!bits.lemma_u16_shr_is_div. (Int Int) Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (ens%vstd!bits.lemma_u16_shr_is_div. x! shift!) (= (uClip 16 (bitshr (I x!) (I shift!)))
     (EucDiv x! (vstd!arithmetic.power2.pow2.? (I shift!)))
   ))
   :pattern ((ens%vstd!bits.lemma_u16_shr_is_div. x! shift!))
   :qid internal_ens__vstd!bits.lemma_u16_shr_is_div._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u16_shr_is_div._definition
)))

;; Broadcast vstd::bits::lemma_u16_shr_is_div
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u16_shr_is_div.)
  (forall ((x! Poly) (shift! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 16))
      (has_type shift! (UINT 16))
     )
     (=>
      (let
       ((tmp%%$ (%I shift!)))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 16)
      ))
      (= (uClip 16 (bitshr (I (%I x!)) (I (%I shift!)))) (EucDiv (%I x!) (vstd!arithmetic.power2.pow2.?
         shift!
    )))))
    :pattern ((uClip 16 (bitshr (I (%I x!)) (I (%I shift!)))))
    :qid user_vstd__bits__lemma_u16_shr_is_div_21
    :skolemid skolem_user_vstd__bits__lemma_u16_shr_is_div_21
))))

;; Function-Specs vstd::bits::lemma_u8_shr_is_div
(declare-fun req%vstd!bits.lemma_u8_shr_is_div. (Int Int) Bool)
(declare-const %%global_location_label%%30 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u8_shr_is_div. x! shift!) (=>
     %%global_location_label%%30
     (let
      ((tmp%%$ shift!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ 8)
   ))))
   :pattern ((req%vstd!bits.lemma_u8_shr_is_div. x! shift!))
   :qid internal_req__vstd!bits.lemma_u8_shr_is_div._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u8_shr_is_div._definition
)))
(declare-fun ens%vstd!bits.lemma_u8_shr_is_div. (Int Int) Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (ens%vstd!bits.lemma_u8_shr_is_div. x! shift!) (= (uClip 8 (bitshr (I x!) (I shift!)))
     (EucDiv x! (vstd!arithmetic.power2.pow2.? (I shift!)))
   ))
   :pattern ((ens%vstd!bits.lemma_u8_shr_is_div. x! shift!))
   :qid internal_ens__vstd!bits.lemma_u8_shr_is_div._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u8_shr_is_div._definition
)))

;; Broadcast vstd::bits::lemma_u8_shr_is_div
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u8_shr_is_div.)
  (forall ((x! Poly) (shift! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 8))
      (has_type shift! (UINT 8))
     )
     (=>
      (let
       ((tmp%%$ (%I shift!)))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 8)
      ))
      (= (uClip 8 (bitshr (I (%I x!)) (I (%I shift!)))) (EucDiv (%I x!) (vstd!arithmetic.power2.pow2.?
         shift!
    )))))
    :pattern ((uClip 8 (bitshr (I (%I x!)) (I (%I shift!)))))
    :qid user_vstd__bits__lemma_u8_shr_is_div_22
    :skolemid skolem_user_vstd__bits__lemma_u8_shr_is_div_22
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
(declare-const %%global_location_label%%31 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%vstd!bits.lemma_u64_low_bits_mask_is_mod. x! n!) (=>
     %%global_location_label%%31
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
    :qid user_vstd__bits__lemma_u64_low_bits_mask_is_mod_23
    :skolemid skolem_user_vstd__bits__lemma_u64_low_bits_mask_is_mod_23
))))

;; Function-Specs vstd::bits::lemma_u32_low_bits_mask_is_mod
(declare-fun req%vstd!bits.lemma_u32_low_bits_mask_is_mod. (Int Int) Bool)
(declare-const %%global_location_label%%32 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%vstd!bits.lemma_u32_low_bits_mask_is_mod. x! n!) (=>
     %%global_location_label%%32
     (< n! 32)
   ))
   :pattern ((req%vstd!bits.lemma_u32_low_bits_mask_is_mod. x! n!))
   :qid internal_req__vstd!bits.lemma_u32_low_bits_mask_is_mod._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u32_low_bits_mask_is_mod._definition
)))
(declare-fun ens%vstd!bits.lemma_u32_low_bits_mask_is_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (ens%vstd!bits.lemma_u32_low_bits_mask_is_mod. x! n!) (= (uClip 32 (bitand (I x!)
       (I (uClip 32 (vstd!bits.low_bits_mask.? (I n!))))
      )
     ) (EucMod x! (uClip 32 (vstd!arithmetic.power2.pow2.? (I n!))))
   ))
   :pattern ((ens%vstd!bits.lemma_u32_low_bits_mask_is_mod. x! n!))
   :qid internal_ens__vstd!bits.lemma_u32_low_bits_mask_is_mod._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u32_low_bits_mask_is_mod._definition
)))

;; Broadcast vstd::bits::lemma_u32_low_bits_mask_is_mod
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u32_low_bits_mask_is_mod.)
  (forall ((x! Poly) (n! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 32))
      (has_type n! NAT)
     )
     (=>
      (< (%I n!) 32)
      (= (uClip 32 (bitand (I (%I x!)) (I (uClip 32 (vstd!bits.low_bits_mask.? n!))))) (
        EucMod (%I x!) (uClip 32 (vstd!arithmetic.power2.pow2.? n!))
    ))))
    :pattern ((uClip 32 (bitand (I (%I x!)) (I (uClip 32 (vstd!bits.low_bits_mask.? n!))))))
    :qid user_vstd__bits__lemma_u32_low_bits_mask_is_mod_24
    :skolemid skolem_user_vstd__bits__lemma_u32_low_bits_mask_is_mod_24
))))

;; Function-Specs vstd::bits::lemma_u16_low_bits_mask_is_mod
(declare-fun req%vstd!bits.lemma_u16_low_bits_mask_is_mod. (Int Int) Bool)
(declare-const %%global_location_label%%33 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%vstd!bits.lemma_u16_low_bits_mask_is_mod. x! n!) (=>
     %%global_location_label%%33
     (< n! 16)
   ))
   :pattern ((req%vstd!bits.lemma_u16_low_bits_mask_is_mod. x! n!))
   :qid internal_req__vstd!bits.lemma_u16_low_bits_mask_is_mod._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u16_low_bits_mask_is_mod._definition
)))
(declare-fun ens%vstd!bits.lemma_u16_low_bits_mask_is_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (ens%vstd!bits.lemma_u16_low_bits_mask_is_mod. x! n!) (= (uClip 16 (bitand (I x!)
       (I (uClip 16 (vstd!bits.low_bits_mask.? (I n!))))
      )
     ) (EucMod x! (uClip 16 (vstd!arithmetic.power2.pow2.? (I n!))))
   ))
   :pattern ((ens%vstd!bits.lemma_u16_low_bits_mask_is_mod. x! n!))
   :qid internal_ens__vstd!bits.lemma_u16_low_bits_mask_is_mod._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u16_low_bits_mask_is_mod._definition
)))

;; Broadcast vstd::bits::lemma_u16_low_bits_mask_is_mod
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u16_low_bits_mask_is_mod.)
  (forall ((x! Poly) (n! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 16))
      (has_type n! NAT)
     )
     (=>
      (< (%I n!) 16)
      (= (uClip 16 (bitand (I (%I x!)) (I (uClip 16 (vstd!bits.low_bits_mask.? n!))))) (
        EucMod (%I x!) (uClip 16 (vstd!arithmetic.power2.pow2.? n!))
    ))))
    :pattern ((uClip 16 (bitand (I (%I x!)) (I (uClip 16 (vstd!bits.low_bits_mask.? n!))))))
    :qid user_vstd__bits__lemma_u16_low_bits_mask_is_mod_25
    :skolemid skolem_user_vstd__bits__lemma_u16_low_bits_mask_is_mod_25
))))

;; Function-Specs vstd::bits::lemma_u8_low_bits_mask_is_mod
(declare-fun req%vstd!bits.lemma_u8_low_bits_mask_is_mod. (Int Int) Bool)
(declare-const %%global_location_label%%34 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%vstd!bits.lemma_u8_low_bits_mask_is_mod. x! n!) (=>
     %%global_location_label%%34
     (< n! 8)
   ))
   :pattern ((req%vstd!bits.lemma_u8_low_bits_mask_is_mod. x! n!))
   :qid internal_req__vstd!bits.lemma_u8_low_bits_mask_is_mod._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u8_low_bits_mask_is_mod._definition
)))
(declare-fun ens%vstd!bits.lemma_u8_low_bits_mask_is_mod. (Int Int) Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (ens%vstd!bits.lemma_u8_low_bits_mask_is_mod. x! n!) (= (uClip 8 (bitand (I x!) (I
        (uClip 8 (vstd!bits.low_bits_mask.? (I n!)))
      ))
     ) (EucMod x! (uClip 8 (vstd!arithmetic.power2.pow2.? (I n!))))
   ))
   :pattern ((ens%vstd!bits.lemma_u8_low_bits_mask_is_mod. x! n!))
   :qid internal_ens__vstd!bits.lemma_u8_low_bits_mask_is_mod._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u8_low_bits_mask_is_mod._definition
)))

;; Broadcast vstd::bits::lemma_u8_low_bits_mask_is_mod
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u8_low_bits_mask_is_mod.)
  (forall ((x! Poly) (n! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 8))
      (has_type n! NAT)
     )
     (=>
      (< (%I n!) 8)
      (= (uClip 8 (bitand (I (%I x!)) (I (uClip 8 (vstd!bits.low_bits_mask.? n!))))) (EucMod
        (%I x!) (uClip 8 (vstd!arithmetic.power2.pow2.? n!))
    ))))
    :pattern ((uClip 8 (bitand (I (%I x!)) (I (uClip 8 (vstd!bits.low_bits_mask.? n!))))))
    :qid user_vstd__bits__lemma_u8_low_bits_mask_is_mod_26
    :skolemid skolem_user_vstd__bits__lemma_u8_low_bits_mask_is_mod_26
))))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u64_pow2_le_max
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max.
 (Int) Bool
)
(declare-const %%global_location_label%%35 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max. k!)
    (=>
     %%global_location_label%%35
     (< k! 64)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max.
     k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max.
 (Int) Bool
)
(assert
 (forall ((k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max. k!)
    (<= (vstd!arithmetic.power2.pow2.? (I k!)) 18446744073709551615)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max.
     k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_u128_cast_64_is_mod
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod.
 (Int) Bool
)
(declare-const %%global_location_label%%36 Bool)
(assert
 (forall ((x! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod.
     x!
    ) (=>
     %%global_location_label%%36
     (> 128 64)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod.
     x!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod.
     x!
    ) (= (uClip 64 x!) (EucMod x! 18446744073709551616))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_mod_add_eq
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq. a! b!
     c! m!
    ) (and
     (=>
      %%global_location_label%%37
      (> m! 0)
     )
     (=>
      %%global_location_label%%38
      (= (EucMod a! m!) (EucMod b! m!))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq.
     a! b! c! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq.
 (Int Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq. a! b!
     c! m!
    ) (= (EucMod (Add a! c!) m!) (EucMod (Add b! c!) m!))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq.
     a! b! c! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_div_strictly_bounded
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(declare-const %%global_location_label%%41 Bool)
(assert
 (forall ((x! Int) (a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded.
     x! a! b!
    ) (and
     (=>
      %%global_location_label%%39
      (> a! 0)
     )
     (=>
      %%global_location_label%%40
      (>= b! 0)
     )
     (=>
      %%global_location_label%%41
      (< x! (Mul a! b!))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded.
     x! a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded.
     x! a! b!
    ) (< (EucDiv x! a!) b!)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded.
     x! a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_mul_le_implies_div_le
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_le_implies_div_le.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%42 Bool)
(declare-const %%global_location_label%%43 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_le_implies_div_le.
     a! b! c!
    ) (and
     (=>
      %%global_location_label%%42
      (> b! 0)
     )
     (=>
      %%global_location_label%%43
      (<= (nClip (Mul a! b!)) c!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_le_implies_div_le.
     a! b! c!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_le_implies_div_le._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_le_implies_div_le._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_le_implies_div_le.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_le_implies_div_le.
     a! b! c!
    ) (<= a! (EucDiv c! b!))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_le_implies_div_le.
     a! b! c!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_le_implies_div_le._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_le_implies_div_le._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_int_nat_mod_equiv
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv.
 (Int Int) Bool
)
(declare-const %%global_location_label%%44 Bool)
(declare-const %%global_location_label%%45 Bool)
(assert
 (forall ((v! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv.
     v! m!
    ) (and
     (=>
      %%global_location_label%%44
      (>= v! 0)
     )
     (=>
      %%global_location_label%%45
      (> m! 0)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv.
     v! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv.
 (Int Int) Bool
)
(assert
 (forall ((v! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv.
     v! m!
    ) (= (EucMod v! m!) (EucMod (nClip v!) m!))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv.
     v! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_u64_cast_u8_is_mod
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_cast_u8_is_mod.
 (Int) Bool
)
(declare-const %%global_location_label%%46 Bool)
(assert
 (forall ((x! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_cast_u8_is_mod.
     x!
    ) (=>
     %%global_location_label%%46
     (> 64 8)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_cast_u8_is_mod.
     x!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_cast_u8_is_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_cast_u8_is_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_cast_u8_is_mod.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_cast_u8_is_mod.
     x!
    ) (= (uClip 8 x!) (EucMod x! 256))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_cast_u8_is_mod.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_cast_u8_is_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_cast_u8_is_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_u64_div_and_mod
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_div_and_mod.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(declare-const %%global_location_label%%49 Bool)
(assert
 (forall ((ai! Int) (bi! Int) (v! Int) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_div_and_mod.
     ai! bi! v! k!
    ) (and
     (=>
      %%global_location_label%%47
      (< k! 64)
     )
     (=>
      %%global_location_label%%48
      (= ai! (uClip 64 (bitshr (I v!) (I k!))))
     )
     (=>
      %%global_location_label%%49
      (= bi! (uClip 64 (bitand (I v!) (I (uClip 64 (vstd!bits.low_bits_mask.? (I k!)))))))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_div_and_mod.
     ai! bi! v! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_div_and_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_div_and_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_div_and_mod.
 (Int Int Int Int) Bool
)
(assert
 (forall ((ai! Int) (bi! Int) (v! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_div_and_mod.
     ai! bi! v! k!
    ) (and
     (= ai! (EucDiv v! (uClip 64 (vstd!arithmetic.power2.pow2.? (I k!)))))
     (= bi! (EucMod v! (uClip 64 (vstd!arithmetic.power2.pow2.? (I k!)))))
     (= v! (Add (Mul ai! (vstd!arithmetic.power2.pow2.? (I k!))) bi!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_div_and_mod.
     ai! bi! v! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_div_and_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u64_div_and_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_mod_sum_both_divisible
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%50 Bool)
(declare-const %%global_location_label%%51 Bool)
(declare-const %%global_location_label%%52 Bool)
(assert
 (forall ((a! Int) (b! Int) (d! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
     a! b! d!
    ) (and
     (=>
      %%global_location_label%%50
      (> d! 0)
     )
     (=>
      %%global_location_label%%51
      (= (EucMod a! d!) 0)
     )
     (=>
      %%global_location_label%%52
      (= (EucMod b! d!) 0)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
     a! b! d!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (d! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
     a! b! d!
    ) (= (EucMod (nClip (Add a! b!)) d!) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible.
     a! b! d!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_both_divisible._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_mod_sum_factor
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%53 Bool)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
    ) (=>
     %%global_location_label%%53
     (> m! 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
    ) (= (EucMod (Add (Mul a! m!) b!) m!) (EucMod b! m!))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor.
     a! b! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_sum_factor._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u8_pow2_le_max
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max.
 (Int) Bool
)
(declare-const %%global_location_label%%54 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max. k!)
    (=>
     %%global_location_label%%54
     (< k! 8)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max.
     k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max.
 (Int) Bool
)
(assert
 (forall ((k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max. k!)
    (<= (vstd!arithmetic.power2.pow2.? (I k!)) 255)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max.
     k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_mod_diff_factor
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_diff_factor.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%55 Bool)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_diff_factor.
     a! b! m!
    ) (=>
     %%global_location_label%%55
     (> m! 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_diff_factor.
     a! b! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_diff_factor._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_diff_factor._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_diff_factor.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_diff_factor.
     a! b! m!
    ) (= (EucMod (Sub b! (Mul a! m!)) m!) (EucMod b! m!))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_diff_factor.
     a! b! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_diff_factor._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_diff_factor._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_mul_distributes_over_neg_mod
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_distributes_over_neg_mod.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%56 Bool)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_distributes_over_neg_mod.
     a! b! m!
    ) (=>
     %%global_location_label%%56
     (> m! 1)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_distributes_over_neg_mod.
     a! b! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_distributes_over_neg_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_distributes_over_neg_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_distributes_over_neg_mod.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_distributes_over_neg_mod.
     a! b! m!
    ) (= (EucMod (nClip (Mul a! (nClip (Sub m! (EucMod b! m!))))) m!) (EucMod (nClip (Sub
        m! (EucMod (nClip (Mul a! b!)) m!)
       )
      ) m!
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_distributes_over_neg_mod.
     a! b! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_distributes_over_neg_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_distributes_over_neg_mod._definition
)))

;; Function-Def curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_mul_distributes_over_neg_mod
;; curve25519-dalek/src/lemmas/common_lemmas/div_mod_lemmas.rs:295:5: 295:11 (#0)
(set-option :smt.arith.solver 6)
(get-info :all-statistics)
(push)
 (declare-const a! Int)
 (declare-const b! Int)
 (declare-const m! Int)
 (declare-const tmp%1 Int)
 (declare-const tmp%2 Int)
 (declare-const tmp%3 Int)
 (declare-const tmp%4 Int)
 (declare-const b_mod@ Int)
 (declare-const neg_b@ Int)
 (declare-const ab_mod@ Int)
 (declare-const neg_ab@ Int)
 (assert
  fuel_defaults
 )
 (assert
  (<= 0 a!)
 )
 (assert
  (<= 0 b_mod@)
 )
 ;; assertion failed
 (declare-const %%location_label%%0 Bool)
 (assert
  (not (=>
    %%location_label%%0
    (= (Mul a! (Sub 0 b_mod@)) (Sub 0 (Mul a! b_mod@)))
 )))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
