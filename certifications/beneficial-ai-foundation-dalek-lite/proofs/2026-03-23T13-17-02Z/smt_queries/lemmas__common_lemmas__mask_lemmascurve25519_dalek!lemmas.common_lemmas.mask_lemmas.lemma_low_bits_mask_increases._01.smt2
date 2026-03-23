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

;; MODULE 'module lemmas::common_lemmas::mask_lemmas'
;; curve25519-dalek/src/lemmas/common_lemmas/mask_lemmas.rs:103:1: 103:59 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_bound. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
(declare-const fuel%vstd!bits.lemma_u64_shl_is_mul. FuelId)
(declare-const fuel%vstd!bits.lemma_u32_shl_is_mul. FuelId)
(declare-const fuel%vstd!bits.lemma_u16_shl_is_mul. FuelId)
(declare-const fuel%vstd!bits.lemma_u8_shl_is_mul. FuelId)
(declare-const fuel%vstd!bits.low_bits_mask. FuelId)
(declare-const fuel%vstd!bits.lemma_low_bits_mask_unfold. FuelId)
(declare-const fuel%vstd!bits.lemma_low_bits_mask_div2. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_mod_bound. fuel%vstd!arithmetic.power2.lemma_pow2_pos.
  fuel%vstd!bits.lemma_u64_shl_is_mul. fuel%vstd!bits.lemma_u32_shl_is_mul. fuel%vstd!bits.lemma_u16_shl_is_mul.
  fuel%vstd!bits.lemma_u8_shl_is_mul. fuel%vstd!bits.low_bits_mask. fuel%vstd!bits.lemma_low_bits_mask_unfold.
  fuel%vstd!bits.lemma_low_bits_mask_div2. fuel%vstd!bits.lemma_u64_low_bits_mask_is_mod.
  fuel%vstd!bits.lemma_u32_low_bits_mask_is_mod. fuel%vstd!bits.lemma_u16_low_bits_mask_is_mod.
  fuel%vstd!bits.lemma_u8_low_bits_mask_is_mod. fuel%vstd!array.group_array_axioms.
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

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_bound
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_bound. (Int Int) Bool)
(declare-const %%global_location_label%%0 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!) (=>
     %%global_location_label%%0
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_bound._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_bound._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_bound. (Int Int) Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!) (let
     ((tmp%%$ (EucMod x! m!)))
     (and
      (<= 0 tmp%%$)
      (< tmp%%$ m!)
   )))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_bound._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_bound._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_bound
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_bound.)
  (forall ((x! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (let
      ((tmp%%$ (EucMod x! m!)))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ m!)
    )))
    :pattern ((EucMod x! m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_bound_0
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_bound_0
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_1
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_1
))))

;; Function-Specs vstd::bits::lemma_u64_shl_is_mul
(declare-fun req%vstd!bits.lemma_u64_shl_is_mul. (Int Int) Bool)
(declare-const %%global_location_label%%1 Bool)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u64_shl_is_mul. x! shift!) (and
     (=>
      %%global_location_label%%1
      (let
       ((tmp%%$ shift!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 64)
     )))
     (=>
      %%global_location_label%%2
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
    :qid user_vstd__bits__lemma_u64_shl_is_mul_2
    :skolemid skolem_user_vstd__bits__lemma_u64_shl_is_mul_2
))))

;; Function-Specs vstd::bits::lemma_u32_shl_is_mul
(declare-fun req%vstd!bits.lemma_u32_shl_is_mul. (Int Int) Bool)
(declare-const %%global_location_label%%3 Bool)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u32_shl_is_mul. x! shift!) (and
     (=>
      %%global_location_label%%3
      (let
       ((tmp%%$ shift!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 32)
     )))
     (=>
      %%global_location_label%%4
      (<= (Mul x! (vstd!arithmetic.power2.pow2.? (I shift!))) 4294967295)
   )))
   :pattern ((req%vstd!bits.lemma_u32_shl_is_mul. x! shift!))
   :qid internal_req__vstd!bits.lemma_u32_shl_is_mul._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u32_shl_is_mul._definition
)))
(declare-fun ens%vstd!bits.lemma_u32_shl_is_mul. (Int Int) Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (ens%vstd!bits.lemma_u32_shl_is_mul. x! shift!) (= (uClip 32 (bitshl (I x!) (I shift!)))
     (Mul x! (vstd!arithmetic.power2.pow2.? (I shift!)))
   ))
   :pattern ((ens%vstd!bits.lemma_u32_shl_is_mul. x! shift!))
   :qid internal_ens__vstd!bits.lemma_u32_shl_is_mul._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u32_shl_is_mul._definition
)))

;; Broadcast vstd::bits::lemma_u32_shl_is_mul
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u32_shl_is_mul.)
  (forall ((x! Poly) (shift! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 32))
      (has_type shift! (UINT 32))
     )
     (=>
      (and
       (let
        ((tmp%%$ (%I shift!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ 32)
       ))
       (<= (Mul (%I x!) (vstd!arithmetic.power2.pow2.? shift!)) 4294967295)
      )
      (= (uClip 32 (bitshl (I (%I x!)) (I (%I shift!)))) (Mul (%I x!) (vstd!arithmetic.power2.pow2.?
         shift!
    )))))
    :pattern ((uClip 32 (bitshl (I (%I x!)) (I (%I shift!)))))
    :qid user_vstd__bits__lemma_u32_shl_is_mul_3
    :skolemid skolem_user_vstd__bits__lemma_u32_shl_is_mul_3
))))

;; Function-Specs vstd::bits::lemma_u16_shl_is_mul
(declare-fun req%vstd!bits.lemma_u16_shl_is_mul. (Int Int) Bool)
(declare-const %%global_location_label%%5 Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u16_shl_is_mul. x! shift!) (and
     (=>
      %%global_location_label%%5
      (let
       ((tmp%%$ shift!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 16)
     )))
     (=>
      %%global_location_label%%6
      (<= (Mul x! (vstd!arithmetic.power2.pow2.? (I shift!))) 65535)
   )))
   :pattern ((req%vstd!bits.lemma_u16_shl_is_mul. x! shift!))
   :qid internal_req__vstd!bits.lemma_u16_shl_is_mul._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u16_shl_is_mul._definition
)))
(declare-fun ens%vstd!bits.lemma_u16_shl_is_mul. (Int Int) Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (ens%vstd!bits.lemma_u16_shl_is_mul. x! shift!) (= (uClip 16 (bitshl (I x!) (I shift!)))
     (Mul x! (vstd!arithmetic.power2.pow2.? (I shift!)))
   ))
   :pattern ((ens%vstd!bits.lemma_u16_shl_is_mul. x! shift!))
   :qid internal_ens__vstd!bits.lemma_u16_shl_is_mul._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u16_shl_is_mul._definition
)))

;; Broadcast vstd::bits::lemma_u16_shl_is_mul
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u16_shl_is_mul.)
  (forall ((x! Poly) (shift! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 16))
      (has_type shift! (UINT 16))
     )
     (=>
      (and
       (let
        ((tmp%%$ (%I shift!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ 16)
       ))
       (<= (Mul (%I x!) (vstd!arithmetic.power2.pow2.? shift!)) 65535)
      )
      (= (uClip 16 (bitshl (I (%I x!)) (I (%I shift!)))) (Mul (%I x!) (vstd!arithmetic.power2.pow2.?
         shift!
    )))))
    :pattern ((uClip 16 (bitshl (I (%I x!)) (I (%I shift!)))))
    :qid user_vstd__bits__lemma_u16_shl_is_mul_4
    :skolemid skolem_user_vstd__bits__lemma_u16_shl_is_mul_4
))))

;; Function-Specs vstd::bits::lemma_u8_shl_is_mul
(declare-fun req%vstd!bits.lemma_u8_shl_is_mul. (Int Int) Bool)
(declare-const %%global_location_label%%7 Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u8_shl_is_mul. x! shift!) (and
     (=>
      %%global_location_label%%7
      (let
       ((tmp%%$ shift!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 8)
     )))
     (=>
      %%global_location_label%%8
      (<= (Mul x! (vstd!arithmetic.power2.pow2.? (I shift!))) 255)
   )))
   :pattern ((req%vstd!bits.lemma_u8_shl_is_mul. x! shift!))
   :qid internal_req__vstd!bits.lemma_u8_shl_is_mul._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u8_shl_is_mul._definition
)))
(declare-fun ens%vstd!bits.lemma_u8_shl_is_mul. (Int Int) Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (ens%vstd!bits.lemma_u8_shl_is_mul. x! shift!) (= (uClip 8 (bitshl (I x!) (I shift!)))
     (Mul x! (vstd!arithmetic.power2.pow2.? (I shift!)))
   ))
   :pattern ((ens%vstd!bits.lemma_u8_shl_is_mul. x! shift!))
   :qid internal_ens__vstd!bits.lemma_u8_shl_is_mul._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u8_shl_is_mul._definition
)))

;; Broadcast vstd::bits::lemma_u8_shl_is_mul
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u8_shl_is_mul.)
  (forall ((x! Poly) (shift! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 8))
      (has_type shift! (UINT 8))
     )
     (=>
      (and
       (let
        ((tmp%%$ (%I shift!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ 8)
       ))
       (<= (Mul (%I x!) (vstd!arithmetic.power2.pow2.? shift!)) 255)
      )
      (= (uClip 8 (bitshl (I (%I x!)) (I (%I shift!)))) (Mul (%I x!) (vstd!arithmetic.power2.pow2.?
         shift!
    )))))
    :pattern ((uClip 8 (bitshl (I (%I x!)) (I (%I shift!)))))
    :qid user_vstd__bits__lemma_u8_shl_is_mul_5
    :skolemid skolem_user_vstd__bits__lemma_u8_shl_is_mul_5
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

;; Function-Specs vstd::bits::lemma_low_bits_mask_unfold
(declare-fun req%vstd!bits.lemma_low_bits_mask_unfold. (Int) Bool)
(declare-const %%global_location_label%%9 Bool)
(assert
 (forall ((n! Int)) (!
   (= (req%vstd!bits.lemma_low_bits_mask_unfold. n!) (=>
     %%global_location_label%%9
     (> n! 0)
   ))
   :pattern ((req%vstd!bits.lemma_low_bits_mask_unfold. n!))
   :qid internal_req__vstd!bits.lemma_low_bits_mask_unfold._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_low_bits_mask_unfold._definition
)))
(declare-fun ens%vstd!bits.lemma_low_bits_mask_unfold. (Int) Bool)
(assert
 (forall ((n! Int)) (!
   (= (ens%vstd!bits.lemma_low_bits_mask_unfold. n!) (= (vstd!bits.low_bits_mask.? (I n!))
     (nClip (Add (nClip (Mul 2 (vstd!bits.low_bits_mask.? (I (nClip (Sub n! 1)))))) 1))
   ))
   :pattern ((ens%vstd!bits.lemma_low_bits_mask_unfold. n!))
   :qid internal_ens__vstd!bits.lemma_low_bits_mask_unfold._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_low_bits_mask_unfold._definition
)))

;; Broadcast vstd::bits::lemma_low_bits_mask_unfold
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_low_bits_mask_unfold.)
  (forall ((n! Poly)) (!
    (=>
     (has_type n! NAT)
     (=>
      (> (%I n!) 0)
      (= (vstd!bits.low_bits_mask.? n!) (nClip (Add (nClip (Mul 2 (vstd!bits.low_bits_mask.?
            (I (nClip (Sub (%I n!) 1)))
          ))
         ) 1
    )))))
    :pattern ((vstd!bits.low_bits_mask.? n!))
    :qid user_vstd__bits__lemma_low_bits_mask_unfold_6
    :skolemid skolem_user_vstd__bits__lemma_low_bits_mask_unfold_6
))))

;; Function-Specs vstd::bits::lemma_low_bits_mask_div2
(declare-fun req%vstd!bits.lemma_low_bits_mask_div2. (Int) Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((n! Int)) (!
   (= (req%vstd!bits.lemma_low_bits_mask_div2. n!) (=>
     %%global_location_label%%10
     (> n! 0)
   ))
   :pattern ((req%vstd!bits.lemma_low_bits_mask_div2. n!))
   :qid internal_req__vstd!bits.lemma_low_bits_mask_div2._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_low_bits_mask_div2._definition
)))
(declare-fun ens%vstd!bits.lemma_low_bits_mask_div2. (Int) Bool)
(assert
 (forall ((n! Int)) (!
   (= (ens%vstd!bits.lemma_low_bits_mask_div2. n!) (= (EucDiv (vstd!bits.low_bits_mask.?
       (I n!)
      ) 2
     ) (vstd!bits.low_bits_mask.? (I (nClip (Sub n! 1))))
   ))
   :pattern ((ens%vstd!bits.lemma_low_bits_mask_div2. n!))
   :qid internal_ens__vstd!bits.lemma_low_bits_mask_div2._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_low_bits_mask_div2._definition
)))

;; Broadcast vstd::bits::lemma_low_bits_mask_div2
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_low_bits_mask_div2.)
  (forall ((n! Poly)) (!
    (=>
     (has_type n! NAT)
     (=>
      (> (%I n!) 0)
      (= (EucDiv (vstd!bits.low_bits_mask.? n!) 2) (vstd!bits.low_bits_mask.? (I (nClip (Sub
           (%I n!) 1
    )))))))
    :pattern ((EucDiv (vstd!bits.low_bits_mask.? n!) 2))
    :qid user_vstd__bits__lemma_low_bits_mask_div2_7
    :skolemid skolem_user_vstd__bits__lemma_low_bits_mask_div2_7
))))

;; Function-Specs vstd::bits::lemma_low_bits_mask_values
(declare-fun ens%vstd!bits.lemma_low_bits_mask_values. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%vstd!bits.lemma_low_bits_mask_values. no%param) (and
     (= (vstd!bits.low_bits_mask.? (I 0)) 0)
     (= (vstd!bits.low_bits_mask.? (I 1)) 1)
     (= (vstd!bits.low_bits_mask.? (I 2)) 3)
     (= (vstd!bits.low_bits_mask.? (I 3)) 7)
     (= (vstd!bits.low_bits_mask.? (I 4)) 15)
     (= (vstd!bits.low_bits_mask.? (I 5)) 31)
     (= (vstd!bits.low_bits_mask.? (I 6)) 63)
     (= (vstd!bits.low_bits_mask.? (I 7)) 127)
     (= (vstd!bits.low_bits_mask.? (I 8)) 255)
     (= (vstd!bits.low_bits_mask.? (I 9)) 511)
     (= (vstd!bits.low_bits_mask.? (I 10)) 1023)
     (= (vstd!bits.low_bits_mask.? (I 11)) 2047)
     (= (vstd!bits.low_bits_mask.? (I 12)) 4095)
     (= (vstd!bits.low_bits_mask.? (I 13)) 8191)
     (= (vstd!bits.low_bits_mask.? (I 14)) 16383)
     (= (vstd!bits.low_bits_mask.? (I 15)) 32767)
     (= (vstd!bits.low_bits_mask.? (I 16)) 65535)
     (= (vstd!bits.low_bits_mask.? (I 17)) 131071)
     (= (vstd!bits.low_bits_mask.? (I 18)) 262143)
     (= (vstd!bits.low_bits_mask.? (I 19)) 524287)
     (= (vstd!bits.low_bits_mask.? (I 20)) 1048575)
     (= (vstd!bits.low_bits_mask.? (I 21)) 2097151)
     (= (vstd!bits.low_bits_mask.? (I 22)) 4194303)
     (= (vstd!bits.low_bits_mask.? (I 23)) 8388607)
     (= (vstd!bits.low_bits_mask.? (I 24)) 16777215)
     (= (vstd!bits.low_bits_mask.? (I 25)) 33554431)
     (= (vstd!bits.low_bits_mask.? (I 26)) 67108863)
     (= (vstd!bits.low_bits_mask.? (I 27)) 134217727)
     (= (vstd!bits.low_bits_mask.? (I 28)) 268435455)
     (= (vstd!bits.low_bits_mask.? (I 29)) 536870911)
     (= (vstd!bits.low_bits_mask.? (I 30)) 1073741823)
     (= (vstd!bits.low_bits_mask.? (I 31)) 2147483647)
     (= (vstd!bits.low_bits_mask.? (I 32)) 4294967295)
     (= (vstd!bits.low_bits_mask.? (I 64)) 18446744073709551615)
   ))
   :pattern ((ens%vstd!bits.lemma_low_bits_mask_values. no%param))
   :qid internal_ens__vstd!bits.lemma_low_bits_mask_values._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_low_bits_mask_values._definition
)))

;; Function-Specs vstd::bits::lemma_u64_low_bits_mask_is_mod
(declare-fun req%vstd!bits.lemma_u64_low_bits_mask_is_mod. (Int Int) Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%vstd!bits.lemma_u64_low_bits_mask_is_mod. x! n!) (=>
     %%global_location_label%%11
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
    :qid user_vstd__bits__lemma_u64_low_bits_mask_is_mod_8
    :skolemid skolem_user_vstd__bits__lemma_u64_low_bits_mask_is_mod_8
))))

;; Function-Specs vstd::bits::lemma_u32_low_bits_mask_is_mod
(declare-fun req%vstd!bits.lemma_u32_low_bits_mask_is_mod. (Int Int) Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%vstd!bits.lemma_u32_low_bits_mask_is_mod. x! n!) (=>
     %%global_location_label%%12
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
    :qid user_vstd__bits__lemma_u32_low_bits_mask_is_mod_9
    :skolemid skolem_user_vstd__bits__lemma_u32_low_bits_mask_is_mod_9
))))

;; Function-Specs vstd::bits::lemma_u16_low_bits_mask_is_mod
(declare-fun req%vstd!bits.lemma_u16_low_bits_mask_is_mod. (Int Int) Bool)
(declare-const %%global_location_label%%13 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%vstd!bits.lemma_u16_low_bits_mask_is_mod. x! n!) (=>
     %%global_location_label%%13
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
    :qid user_vstd__bits__lemma_u16_low_bits_mask_is_mod_10
    :skolemid skolem_user_vstd__bits__lemma_u16_low_bits_mask_is_mod_10
))))

;; Function-Specs vstd::bits::lemma_u8_low_bits_mask_is_mod
(declare-fun req%vstd!bits.lemma_u8_low_bits_mask_is_mod. (Int Int) Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%vstd!bits.lemma_u8_low_bits_mask_is_mod. x! n!) (=>
     %%global_location_label%%14
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
    :qid user_vstd__bits__lemma_u8_low_bits_mask_is_mod_11
    :skolemid skolem_user_vstd__bits__lemma_u8_low_bits_mask_is_mod_11
))))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u64_pow2_le_max
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max.
 (Int) Bool
)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max. k!)
    (=>
     %%global_location_label%%15
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::mask_lemmas::lemma_low_bits_mask_increases
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases.
 (Int Int) Bool
)
(declare-const %%global_location_label%%16 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases.
     a! b!
    ) (=>
     %%global_location_label%%16
     (< a! b!)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases.
     a! b!
    ) (< (vstd!bits.low_bits_mask.? (I a!)) (vstd!bits.low_bits_mask.? (I b!)))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases._definition
)))

;; Function-Def curve25519_dalek::lemmas::common_lemmas::mask_lemmas::lemma_low_bits_mask_increases
;; curve25519-dalek/src/lemmas/common_lemmas/mask_lemmas.rs:103:1: 103:59 (#0)
(get-info :all-statistics)
(push)
 (declare-const a! Int)
 (declare-const b! Int)
 (declare-const tmp%1 Int)
 (declare-const tmp%2 Int)
 (declare-const decrease%init0 Int)
 (assert
  fuel_defaults
 )
 (assert
  (<= 0 a!)
 )
 (assert
  (<= 0 b!)
 )
 (assert
  (< a! b!)
 )
 (declare-const %%switch_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%1 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%2 Bool)
 ;; could not prove termination
 (declare-const %%location_label%%3 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%4 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%5 Bool)
 (assert
  (not (=>
    (= decrease%init0 (nClip (Add a! b!)))
    (or
     (and
      (=>
       (= a! 0)
       (=>
        (ens%vstd!bits.lemma_low_bits_mask_values. 0)
        (and
         (=>
          %%location_label%%0
          (req%vstd!bits.lemma_low_bits_mask_unfold. b!)
         )
         (=>
          (ens%vstd!bits.lemma_low_bits_mask_unfold. b!)
          %%switch_label%%0
      ))))
      (=>
       (not (= a! 0))
       (and
        (=>
         %%location_label%%1
         (req%vstd!bits.lemma_low_bits_mask_div2. b!)
        )
        (=>
         (ens%vstd!bits.lemma_low_bits_mask_div2. b!)
         (and
          (=>
           %%location_label%%2
           (req%vstd!bits.lemma_low_bits_mask_div2. a!)
          )
          (=>
           (ens%vstd!bits.lemma_low_bits_mask_div2. a!)
           (=>
            (= tmp%1 (nClip (Sub a! 1)))
            (=>
             (= tmp%2 (nClip (Sub b! 1)))
             (and
              (=>
               %%location_label%%3
               (check_decrease_int (let
                 ((a!$0 tmp%1) (b!$1 tmp%2))
                 (nClip (Add a!$0 b!$1))
                ) decrease%init0 false
              ))
              (and
               (=>
                %%location_label%%4
                (req%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases.
                 tmp%1 tmp%2
               ))
               (=>
                (ens%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_low_bits_mask_increases.
                 tmp%1 tmp%2
                )
                %%switch_label%%0
     )))))))))))
     (and
      (not %%switch_label%%0)
      (=>
       %%location_label%%5
       (< (vstd!bits.low_bits_mask.? (I a!)) (vstd!bits.low_bits_mask.? (I b!)))
 ))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
