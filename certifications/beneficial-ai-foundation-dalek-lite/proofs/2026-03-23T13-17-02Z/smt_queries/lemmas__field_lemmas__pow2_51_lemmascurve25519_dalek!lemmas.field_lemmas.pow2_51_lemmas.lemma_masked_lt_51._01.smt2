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

;; MODULE 'module lemmas::field_lemmas::pow2_51_lemmas'
;; curve25519-dalek/src/lemmas/field_lemmas/pow2_51_lemmas.rs:104:1: 104:40 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_is_ordered. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_associative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_adds. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_subtracts. FuelId)
(declare-const fuel%vstd!bits.lemma_u128_shr_is_div. FuelId)
(declare-const fuel%vstd!bits.lemma_u64_shr_is_div. FuelId)
(declare-const fuel%vstd!bits.low_bits_mask. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_cast_then_mask_51.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.mask51. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_div_is_ordered. fuel%vstd!arithmetic.div_mod.lemma_multiply_divide_lt.
  fuel%vstd!arithmetic.mul.lemma_mul_is_associative. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub.
  fuel%vstd!arithmetic.power2.lemma_pow2_pos. fuel%vstd!arithmetic.power2.lemma_pow2_adds.
  fuel%vstd!arithmetic.power2.lemma_pow2_subtracts. fuel%vstd!bits.lemma_u128_shr_is_div.
  fuel%vstd!bits.lemma_u64_shr_is_div. fuel%vstd!bits.low_bits_mask. fuel%curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_cast_then_mask_51.
  fuel%curve25519_dalek!specs.field_specs_u64.mask51. fuel%vstd!array.group_array_axioms.
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

;; Function-Decl curve25519_dalek::specs::field_specs_u64::mask51
(declare-fun curve25519_dalek!specs.field_specs_u64.mask51.? () Int)

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

;; Function-Specs vstd::arithmetic::div_mod::lemma_multiply_divide_lt
(declare-fun req%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. (Int Int Int) Bool)
(declare-const %%global_location_label%%2 Bool)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. a! b! c!) (and
     (=>
      %%global_location_label%%2
      (< 0 b!)
     )
     (=>
      %%global_location_label%%3
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
    :qid user_vstd__arithmetic__div_mod__lemma_multiply_divide_lt_1
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_multiply_divide_lt_1
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_associative_2
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_associative_2
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_3
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_3
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_4
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_4
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_adds_5
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_adds_5
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_subtracts
(declare-fun req%vstd!arithmetic.power2.lemma_pow2_subtracts. (Int Int) Bool)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (req%vstd!arithmetic.power2.lemma_pow2_subtracts. e1! e2!) (=>
     %%global_location_label%%4
     (<= e1! e2!)
   ))
   :pattern ((req%vstd!arithmetic.power2.lemma_pow2_subtracts. e1! e2!))
   :qid internal_req__vstd!arithmetic.power2.lemma_pow2_subtracts._definition
   :skolemid skolem_internal_req__vstd!arithmetic.power2.lemma_pow2_subtracts._definition
)))
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_subtracts. (Int Int) Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_subtracts. e1! e2!) (let
     ((tmp%%$ (EucDiv (vstd!arithmetic.power2.pow2.? (I e2!)) (vstd!arithmetic.power2.pow2.?
         (I e1!)
     ))))
     (and
      (= (vstd!arithmetic.power2.pow2.? (I (nClip (Sub e2! e1!)))) tmp%%$)
      (> tmp%%$ 0)
   )))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_subtracts. e1! e2!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_subtracts._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_subtracts._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_subtracts
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_subtracts.)
  (forall ((e1! Int) (e2! Int)) (!
    (=>
     (and
      (<= 0 e1!)
      (<= 0 e2!)
     )
     (=>
      (<= e1! e2!)
      (let
       ((tmp%%$ (EucDiv (vstd!arithmetic.power2.pow2.? (I e2!)) (vstd!arithmetic.power2.pow2.?
           (I e1!)
       ))))
       (and
        (= (vstd!arithmetic.power2.pow2.? (I (nClip (Sub e2! e1!)))) tmp%%$)
        (> tmp%%$ 0)
    ))))
    :pattern ((vstd!arithmetic.power2.pow2.? (I (nClip (Sub e2! e1!)))))
    :qid user_vstd__arithmetic__power2__lemma_pow2_subtracts_6
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_subtracts_6
))))

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

;; Function-Specs vstd::bits::lemma_u128_shr_is_div
(declare-fun req%vstd!bits.lemma_u128_shr_is_div. (Int Int) Bool)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u128_shr_is_div. x! shift!) (=>
     %%global_location_label%%5
     (let
      ((tmp%%$ shift!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ 128)
   ))))
   :pattern ((req%vstd!bits.lemma_u128_shr_is_div. x! shift!))
   :qid internal_req__vstd!bits.lemma_u128_shr_is_div._definition
   :skolemid skolem_internal_req__vstd!bits.lemma_u128_shr_is_div._definition
)))
(declare-fun ens%vstd!bits.lemma_u128_shr_is_div. (Int Int) Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (ens%vstd!bits.lemma_u128_shr_is_div. x! shift!) (= (uClip 128 (bitshr (I x!) (I shift!)))
     (EucDiv x! (vstd!arithmetic.power2.pow2.? (I shift!)))
   ))
   :pattern ((ens%vstd!bits.lemma_u128_shr_is_div. x! shift!))
   :qid internal_ens__vstd!bits.lemma_u128_shr_is_div._definition
   :skolemid skolem_internal_ens__vstd!bits.lemma_u128_shr_is_div._definition
)))

;; Broadcast vstd::bits::lemma_u128_shr_is_div
(assert
 (=>
  (fuel_bool fuel%vstd!bits.lemma_u128_shr_is_div.)
  (forall ((x! Poly) (shift! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 128))
      (has_type shift! (UINT 128))
     )
     (=>
      (let
       ((tmp%%$ (%I shift!)))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 128)
      ))
      (= (uClip 128 (bitshr (I (%I x!)) (I (%I shift!)))) (EucDiv (%I x!) (vstd!arithmetic.power2.pow2.?
         shift!
    )))))
    :pattern ((uClip 128 (bitshr (I (%I x!)) (I (%I shift!)))))
    :qid user_vstd__bits__lemma_u128_shr_is_div_7
    :skolemid skolem_user_vstd__bits__lemma_u128_shr_is_div_7
))))

;; Function-Specs vstd::bits::lemma_u64_shr_is_div
(declare-fun req%vstd!bits.lemma_u64_shr_is_div. (Int Int) Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u64_shr_is_div. x! shift!) (=>
     %%global_location_label%%6
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
    :qid user_vstd__bits__lemma_u64_shr_is_div_8
    :skolemid skolem_user_vstd__bits__lemma_u64_shr_is_div_8
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::shift_lemmas::lemma_u64_shift_is_pow2
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
 (Int) Bool
)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
     k!
    ) (=>
     %%global_location_label%%7
     (< k! 64)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
     k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
 (Int) Bool
)
(assert
 (forall ((k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
     k!
    ) (= (uClip 64 (bitshl (I (uClip 64 1)) (I k!))) (vstd!arithmetic.power2.pow2.? (I k!)))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
     k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2._definition
)))

;; Function-Specs curve25519_dalek::specs::field_specs_u64::l51_bit_mask_lt
(declare-fun ens%curve25519_dalek!specs.field_specs_u64.l51_bit_mask_lt. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!specs.field_specs_u64.l51_bit_mask_lt. no%param) (and
     (= curve25519_dalek!specs.field_specs_u64.mask51.? (vstd!bits.low_bits_mask.? (I 51)))
     (< curve25519_dalek!specs.field_specs_u64.mask51.? (uClip 64 (bitshl (I 1) (I 51))))
   ))
   :pattern ((ens%curve25519_dalek!specs.field_specs_u64.l51_bit_mask_lt. no%param))
   :qid internal_ens__curve25519_dalek!specs.field_specs_u64.l51_bit_mask_lt._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.field_specs_u64.l51_bit_mask_lt._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::mask_lemmas::lemma_u64_masked_lt
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt.
 (Int Int) Bool
)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((v! Int) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt. v! k!)
    (=>
     %%global_location_label%%8
     (< k! 64)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt.
     v! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt.
 (Int Int) Bool
)
(assert
 (forall ((v! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt. v! k!)
    (< (uClip 64 (bitand (I v!) (I (uClip 64 (vstd!bits.low_bits_mask.? (I k!)))))) (uClip
      64 (bitshl (I (uClip 64 1)) (I k!))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt.
     v! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::pow2_51_lemmas::lemma_masked_lt_51
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_masked_lt_51.
 (Int) Bool
)
(assert
 (forall ((v! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_masked_lt_51. v!)
    (< (uClip 64 (bitand (I v!) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))
     (uClip 64 (bitshl (I 1) (I 51)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_masked_lt_51.
     v!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_masked_lt_51._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_masked_lt_51._definition
)))

;; Function-Def curve25519_dalek::lemmas::field_lemmas::pow2_51_lemmas::lemma_masked_lt_51
;; curve25519-dalek/src/lemmas/field_lemmas/pow2_51_lemmas.rs:104:1: 104:40 (#0)
(get-info :all-statistics)
(push)
 (declare-const v! Int)
 (assert
  fuel_defaults
 )
 (assert
  (uInv 64 v!)
 )
 ;; precondition not satisfied
 (declare-const %%location_label%%0 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%1 Bool)
 (assert
  (not (=>
    (ens%curve25519_dalek!specs.field_specs_u64.l51_bit_mask_lt. 0)
    (and
     (=>
      %%location_label%%0
      (req%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt. v! 51)
     )
     (=>
      (ens%curve25519_dalek!lemmas.common_lemmas.mask_lemmas.lemma_u64_masked_lt. v! 51)
      (=>
       %%location_label%%1
       (< (uClip 64 (bitand (I v!) (I curve25519_dalek!specs.field_specs_u64.mask51.?)))
        (uClip 64 (bitshl (I 1) (I 51)))
 )))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
