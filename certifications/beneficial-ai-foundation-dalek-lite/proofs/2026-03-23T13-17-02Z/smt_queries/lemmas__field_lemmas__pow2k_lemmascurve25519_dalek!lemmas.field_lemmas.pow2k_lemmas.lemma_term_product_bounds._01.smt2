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

;; MODULE 'module lemmas::field_lemmas::pow2k_lemmas'
;; curve25519-dalek/src/lemmas/field_lemmas/pow2k_lemmas.rs:125:1: 125:64 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_associative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_adds. FuelId)
(declare-const fuel%vstd!array.array_view. FuelId)
(declare-const fuel%vstd!array.impl&%0.view. FuelId)
(declare-const fuel%vstd!array.impl&%2.spec_index. FuelId)
(declare-const fuel%vstd!array.lemma_array_index. FuelId)
(declare-const fuel%vstd!array.array_len_matches_n. FuelId)
(declare-const fuel%vstd!array.axiom_array_ext_equal. FuelId)
(declare-const fuel%vstd!array.axiom_array_has_resolved. FuelId)
(declare-const fuel%vstd!bits.lemma_u128_shr_is_div. FuelId)
(declare-const fuel%vstd!bits.lemma_u64_shr_is_div. FuelId)
(declare-const fuel%vstd!bits.low_bits_mask. FuelId)
(declare-const fuel%vstd!bits.lemma_u64_low_bits_mask_is_mod. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_empty. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_new_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_len. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_index_same. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_push_index_different. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_ext_equal_deep. FuelId)
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
(declare-const fuel%vstd!view.impl&%20.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%24.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.p. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.mask51. FuelId)
(declare-const fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop.
  fuel%vstd!arithmetic.mul.lemma_mul_is_associative. fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way.
  fuel%vstd!arithmetic.power2.lemma_pow2_adds. fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view.
  fuel%vstd!array.impl&%2.spec_index. fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n.
  fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!bits.lemma_u128_shr_is_div. fuel%vstd!bits.lemma_u64_shr_is_div. fuel%vstd!bits.low_bits_mask.
  fuel%vstd!bits.lemma_u64_low_bits_mask_is_mod. fuel%vstd!raw_ptr.impl&%3.view. fuel%vstd!raw_ptr.ptrs_mut_eq.
  fuel%vstd!raw_ptr.ptrs_mut_eq_sized. fuel%vstd!seq.impl&%0.spec_index. fuel%vstd!seq.axiom_seq_index_decreases.
  fuel%vstd!seq.axiom_seq_empty. fuel%vstd!seq.axiom_seq_new_len. fuel%vstd!seq.axiom_seq_new_index.
  fuel%vstd!seq.axiom_seq_push_len. fuel%vstd!seq.axiom_seq_push_index_same. fuel%vstd!seq.axiom_seq_push_index_different.
  fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!slice.impl&%2.spec_index.
  fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal. fuel%vstd!slice.axiom_slice_has_resolved.
  fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view. fuel%vstd!view.impl&%4.view.
  fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view. fuel%vstd!view.impl&%14.view.
  fuel%vstd!view.impl&%20.view. fuel%vstd!view.impl&%22.view. fuel%vstd!view.impl&%24.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%32.view. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries. fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.
  fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.
  fuel%curve25519_dalek!specs.field_specs_u64.p. fuel%curve25519_dalek!specs.field_specs_u64.mask51.
  fuel%curve25519_dalek!specs.field_specs_u64.u64_5_as_nat. fuel%vstd!array.group_array_axioms.
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
   (fuel_bool_default fuel%vstd!seq.axiom_seq_empty.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_new_index.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_len.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_index_same.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_push_index_different.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal.)
   (fuel_bool_default fuel%vstd!seq.axiom_seq_ext_equal_deep.)
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
(declare-sort allocator_global%. 0)
(declare-datatypes ((vstd!raw_ptr.PtrData. 0) (tuple%0. 0)) (((vstd!raw_ptr.PtrData./PtrData
    (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((tuple%0./tuple%0))
))
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-fun Poly%fun%1. (%%Function%%) Poly)
(declare-fun %Poly%fun%1. (Poly) %%Function%%)
(declare-fun Poly%array%. (%%Function%%) Poly)
(declare-fun %Poly%array%. (Poly) %%Function%%)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
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

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

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

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::arithmetic::power::pow
(declare-fun vstd!arithmetic.power.pow.? (Poly Poly) Int)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::bits::low_bits_mask
(declare-fun vstd!bits.low_bits_mask.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::p
(declare-fun curve25519_dalek!specs.field_specs_u64.p.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::u64_5_as_nat
(declare-fun curve25519_dalek!specs.field_specs_u64.u64_5_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::field_specs_u64::mask51
(declare-fun curve25519_dalek!specs.field_specs_u64.mask51.? () Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c0_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c1_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c2_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c3_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c4_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c1_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c2_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c3_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c4_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::carry_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a1_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a2_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a3_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a4_0_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_1_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a1_1_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_2_val
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::term_product_bounds_spec
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ci_0_val_boundaries
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.?
 (Poly Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ci_val_boundaries
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ai_val_boundaries
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.?
 (Poly) Bool
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::pow2k_loop_return
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
 (Poly) %%Function%%
)

;; Function-Decl curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::pow2k_loop_boundary_spec
(declare-fun curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.?
 (Poly) Bool
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
    :qid user_vstd__seq__axiom_seq_empty_1
    :skolemid skolem_user_vstd__seq__axiom_seq_empty_1
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
    :qid user_vstd__seq__axiom_seq_push_len_4
    :skolemid skolem_user_vstd__seq__axiom_seq_push_len_4
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
    :qid user_vstd__seq__axiom_seq_push_index_same_5
    :skolemid skolem_user_vstd__seq__axiom_seq_push_index_same_5
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
    :qid user_vstd__seq__axiom_seq_push_index_different_6
    :skolemid skolem_user_vstd__seq__axiom_seq_push_index_different_6
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
          :qid user_vstd__seq__axiom_seq_ext_equal_7
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_7
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_8
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_8
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
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_9
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_9
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_10
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_10
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
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!slice.SliceAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%2
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
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((Self%&. Dcr) (Self%& Type) (T&. Dcr) (T& Type) (self! Poly) (i! Poly)) (
   !
   (= (req%vstd!array.ArrayAdditionalSpecFns.spec_index. Self%&. Self%& T&. T& self! i!)
    (=>
     %%global_location_label%%3
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
         :qid user_vstd__array__axiom_array_ext_equal_17
         :skolemid skolem_user_vstd__array__axiom_array_ext_equal_17
    )))))
    :pattern ((ext_eq false (ARRAY T&. T& N&. N&) a1! a2!))
    :qid user_vstd__array__axiom_array_ext_equal_18
    :skolemid skolem_user_vstd__array__axiom_array_ext_equal_18
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
    :qid user_vstd__array__axiom_array_has_resolved_19
    :skolemid skolem_user_vstd__array__axiom_array_has_resolved_19
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_20
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_20
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_21
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_21
))))

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
    :qid user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_22
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_22
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!) (=>
     %%global_location_label%%5
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!) (= (EucMod (Mul (EucMod
        x! m!
       ) (EucMod y! m!)
      ) m!
     ) (EucMod (Mul x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mul_mod_noop
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Mul (EucMod x! m!) (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
    )
    :pattern ((EucMod (Mul x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_23
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_23
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_associative_24
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_associative_24
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_25
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_25
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_26
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_26
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_is_distributive_sub_other_way
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. (Int
  Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. x! y! z!) (= (
      Mul (Sub y! z!) x!
     ) (Sub (Mul y! x!) (Mul z! x!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_is_distributive_sub_other_way
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (= (Mul (Sub y! z!) x!) (Sub (Mul y! x!) (Mul z! x!)))
    :pattern ((Mul (Sub y! z!) x!))
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_other_way_27
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_other_way_27
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_adds_28
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_adds_28
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
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u128_shr_is_div. x! shift!) (=>
     %%global_location_label%%6
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
    :qid user_vstd__bits__lemma_u128_shr_is_div_29
    :skolemid skolem_user_vstd__bits__lemma_u128_shr_is_div_29
))))

;; Function-Specs vstd::bits::lemma_u64_shr_is_div
(declare-fun req%vstd!bits.lemma_u64_shr_is_div. (Int Int) Bool)
(declare-const %%global_location_label%%7 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u64_shr_is_div. x! shift!) (=>
     %%global_location_label%%7
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
    :qid user_vstd__bits__lemma_u64_shr_is_div_30
    :skolemid skolem_user_vstd__bits__lemma_u64_shr_is_div_30
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
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%vstd!bits.lemma_u64_low_bits_mask_is_mod. x! n!) (=>
     %%global_location_label%%8
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
    :qid user_vstd__bits__lemma_u64_low_bits_mask_is_mod_31
    :skolemid skolem_user_vstd__bits__lemma_u64_low_bits_mask_is_mod_31
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

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c0_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? a!) (uClip 128 (Add
       (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 0)
         )
        ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) a!
          ) (I 0)
        ))
       ) (Mul 2 (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 1)
           )
          ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                64
               ) $ (CONST_INT 5)
              ) a!
             ) (I 4)
          )))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 2)
           )
          ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                64
               ) $ (CONST_INT 5)
              ) a!
             ) (I 3)
    )))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c1_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!) (uClip 128 (Add
       (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 3)
         )
        ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
              64
             ) $ (CONST_INT 5)
            ) a!
           ) (I 3)
        )))
       ) (Mul 2 (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 0)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 1)
          ))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 2)
           )
          ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                64
               ) $ (CONST_INT 5)
              ) a!
             ) (I 4)
    )))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c2_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!) (uClip 128 (Add
       (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 1)
         )
        ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) a!
          ) (I 1)
        ))
       ) (Mul 2 (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 0)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 2)
          ))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 4)
           )
          ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                64
               ) $ (CONST_INT 5)
              ) a!
             ) (I 3)
    )))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c3_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!) (uClip 128 (Add
       (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 4)
         )
        ) (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
              64
             ) $ (CONST_INT 5)
            ) a!
           ) (I 4)
        )))
       ) (Mul 2 (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 0)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 3)
          ))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 1)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 2)
    ))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c4_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!) (uClip 128 (Add
       (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) a!
          ) (I 2)
         )
        ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) a!
          ) (I 2)
        ))
       ) (Mul 2 (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 0)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 4)
          ))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) a!
            ) (I 1)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) a!
            ) (I 3)
    ))))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? a!) (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.?
      a!
    ))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c1_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? a!) (uClip 128 (Add (
        curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!
       ) (uClip 128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?
             a!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c2_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? a!) (uClip 128 (Add (
        curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!
       ) (uClip 128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?
             a!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c3_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? a!) (uClip 128 (Add (
        curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!
       ) (uClip 128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?
             a!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::c4_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!) (uClip 128 (Add (
        curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!
       ) (uClip 128 (uClip 64 (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?
             a!
            )
           ) (I 51)
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 128 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::carry_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? a!) (uClip 64 (uClip
       128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!)) (I
         51
    )))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!) (uClip 64 (bitand
       (I (uClip 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.? a!))) (I
        curve25519_dalek!specs.field_specs_u64.mask51.?
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a1_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!) (uClip 64 (bitand
       (I (uClip 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.? a!))) (I
        curve25519_dalek!specs.field_specs_u64.mask51.?
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a2_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!) (uClip 64 (bitand
       (I (uClip 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.? a!))) (I
        curve25519_dalek!specs.field_specs_u64.mask51.?
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a3_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!) (uClip 64 (bitand
       (I (uClip 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.? a!))) (I
        curve25519_dalek!specs.field_specs_u64.mask51.?
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a4_0_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!) (uClip 64 (bitand
       (I (uClip 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.? a!))) (I
        curve25519_dalek!specs.field_specs_u64.mask51.?
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_1_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!) (uClip 64 (Add
       (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!) (Mul (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?
         a!
        ) 19
    ))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a1_1_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? a!) (uClip 64 (Add
       (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!) (uClip 64 (bitshr
         (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!)) (I 51)
    )))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::a0_2_val
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!) (uClip 64 (bitand
       (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!)) (I curve25519_dalek!specs.field_specs_u64.mask51.?)
    )))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (uInv 64 (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!))
   )
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::term_product_bounds_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.)
  (forall ((a! Poly) (bound! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.? a!
      bound!
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
                   (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                          $ (UINT 64) $ (CONST_INT 5)
                         ) a!
                        ) (I 0)
                      ))
                     ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                           UINT 64
                          ) $ (CONST_INT 5)
                         ) a!
                        ) (I 0)
                     )))
                    ) (Mul (%I bound!) (%I bound!))
                   )
                   (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                          $ (UINT 64) $ (CONST_INT 5)
                         ) a!
                        ) (I 1)
                      ))
                     ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                           $ (UINT 64) $ (CONST_INT 5)
                          ) a!
                         ) (I 4)
                     ))))
                    ) (Mul 19 (Mul (%I bound!) (%I bound!)))
                  ))
                  (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                         $ (UINT 64) $ (CONST_INT 5)
                        ) a!
                       ) (I 2)
                     ))
                    ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                          $ (UINT 64) $ (CONST_INT 5)
                         ) a!
                        ) (I 3)
                    ))))
                   ) (Mul 19 (Mul (%I bound!) (%I bound!)))
                 ))
                 (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                        $ (UINT 64) $ (CONST_INT 5)
                       ) a!
                      ) (I 3)
                    ))
                   ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                         $ (UINT 64) $ (CONST_INT 5)
                        ) a!
                       ) (I 3)
                   ))))
                  ) (Mul 19 (Mul (%I bound!) (%I bound!)))
                ))
                (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                       $ (UINT 64) $ (CONST_INT 5)
                      ) a!
                     ) (I 0)
                   ))
                  ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                        UINT 64
                       ) $ (CONST_INT 5)
                      ) a!
                     ) (I 1)
                  )))
                 ) (Mul (%I bound!) (%I bound!))
               ))
               (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                      $ (UINT 64) $ (CONST_INT 5)
                     ) a!
                    ) (I 2)
                  ))
                 ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                       $ (UINT 64) $ (CONST_INT 5)
                      ) a!
                     ) (I 4)
                 ))))
                ) (Mul 19 (Mul (%I bound!) (%I bound!)))
              ))
              (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                     $ (UINT 64) $ (CONST_INT 5)
                    ) a!
                   ) (I 1)
                 ))
                ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                      UINT 64
                     ) $ (CONST_INT 5)
                    ) a!
                   ) (I 1)
                )))
               ) (Mul (%I bound!) (%I bound!))
             ))
             (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                    $ (UINT 64) $ (CONST_INT 5)
                   ) a!
                  ) (I 0)
                ))
               ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                     UINT 64
                    ) $ (CONST_INT 5)
                   ) a!
                  ) (I 2)
               )))
              ) (Mul (%I bound!) (%I bound!))
            ))
            (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                   $ (UINT 64) $ (CONST_INT 5)
                  ) a!
                 ) (I 4)
               ))
              ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                    $ (UINT 64) $ (CONST_INT 5)
                   ) a!
                  ) (I 3)
              ))))
             ) (Mul 19 (Mul (%I bound!) (%I bound!)))
           ))
           (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                  $ (UINT 64) $ (CONST_INT 5)
                 ) a!
                ) (I 4)
              ))
             ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                   $ (UINT 64) $ (CONST_INT 5)
                  ) a!
                 ) (I 4)
             ))))
            ) (Mul 19 (Mul (%I bound!) (%I bound!)))
          ))
          (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) a!
               ) (I 0)
             ))
            ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                  UINT 64
                 ) $ (CONST_INT 5)
                ) a!
               ) (I 3)
            )))
           ) (Mul (%I bound!) (%I bound!))
         ))
         (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                $ (UINT 64) $ (CONST_INT 5)
               ) a!
              ) (I 1)
            ))
           ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                 UINT 64
                ) $ (CONST_INT 5)
               ) a!
              ) (I 2)
           )))
          ) (Mul (%I bound!) (%I bound!))
        ))
        (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) a!
             ) (I 2)
           ))
          ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                UINT 64
               ) $ (CONST_INT 5)
              ) a!
             ) (I 2)
          )))
         ) (Mul (%I bound!) (%I bound!))
       ))
       (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
              $ (UINT 64) $ (CONST_INT 5)
             ) a!
            ) (I 0)
          ))
         ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
               UINT 64
              ) $ (CONST_INT 5)
             ) a!
            ) (I 4)
         )))
        ) (Mul (%I bound!) (%I bound!))
      ))
      (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
             $ (UINT 64) $ (CONST_INT 5)
            ) a!
           ) (I 1)
         ))
        ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
              UINT 64
             ) $ (CONST_INT 5)
            ) a!
           ) (I 3)
        )))
       ) (Mul (%I bound!) (%I bound!))
    )))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.?
      a! bound!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ci_0_val_boundaries
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.)
  (forall ((a! Poly) (bound! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.? a! bound!)
     (and
      (and
       (and
        (and
         (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_0_val.? a!) (Mul 77 (Mul (%I
             bound!
            ) (%I bound!)
         )))
         (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_0_val.? a!) (Mul 59 (Mul (%I
             bound!
            ) (%I bound!)
        ))))
        (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_0_val.? a!) (Mul 41 (Mul (%I
            bound!
           ) (%I bound!)
       ))))
       (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_0_val.? a!) (Mul 23 (Mul (%I
           bound!
          ) (%I bound!)
      ))))
      (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_0_val.? a!) (Mul 5 (Mul (%I
          bound!
         ) (%I bound!)
    )))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.?
      a! bound!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ci_val_boundaries
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.? a!) (and
      (and
       (and
        (and
         (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c0_val.?
              a!
             )
            ) (I 51)
           )
          ) (uClip 128 18446744073709551615)
         )
         (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c1_val.?
              a!
             )
            ) (I 51)
           )
          ) (uClip 128 18446744073709551615)
        ))
        (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c2_val.?
             a!
            )
           ) (I 51)
          )
         ) (uClip 128 18446744073709551615)
       ))
       (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c3_val.?
            a!
           )
          ) (I 51)
         )
        ) (uClip 128 18446744073709551615)
      ))
      (<= (uClip 128 (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.c4_val.?
           a!
          )
         ) (I 51)
        )
       ) (uClip 128 18446744073709551615)
    )))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::ai_val_boundaries
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.? a!) (and
      (and
       (and
        (and
         (and
          (and
           (and
            (and
             (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!) (uClip 64 (bitshl
                (I 1) (I 51)
             )))
             (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!) (uClip 64 (bitshl
                (I 1) (I 51)
            ))))
            (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!) (uClip 64 (bitshl
               (I 1) (I 51)
           ))))
           (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!) (uClip 64 (bitshl
              (I 1) (I 51)
          ))))
          (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!) (uClip 64 (bitshl
             (I 1) (I 51)
         ))))
         (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.? a!) 724618875532318195)
        )
        (< (Add (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_0_val.? a!) (Mul (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.carry_val.?
            a!
           ) 19
          )
         ) 18446744073709551615
       ))
       (< (Add (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_0_val.? a!) (uClip 64
          (bitshr (I (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_1_val.? a!)) (I 51))
         )
        ) (uClip 64 (bitshl (I 1) (I 52)))
      ))
      (< (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!) (uClip 64 (bitshl
         (I 1) (I 51)
    )))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.?_definition
))))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::pow2k_loop_return
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.)
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
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.? a!) (let
      ((a0$ (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a0_2_val.? a!)))
      (let
       ((a1$ (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a1_1_val.? a!)))
       (let
        ((a2$ (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a2_0_val.? a!)))
        (let
         ((a3$ (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a3_0_val.? a!)))
         (let
          ((a4$ (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.a4_0_val.? a!)))
          (let
           ((r$ (%Poly%array%. (array_new $ (UINT 64) 5 (%%array%%0 (I a0$) (I a1$) (I a2$) (I a3$)
                (I a4$)
           )))))
           r$
    )))))))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.? a!))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?_definition
))))
(assert
 (forall ((a! Poly)) (!
   (=>
    (has_type a! (ARRAY $ (UINT 64) $ (CONST_INT 5)))
    (has_type (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
       a!
      )
     ) (ARRAY $ (UINT 64) $ (CONST_INT 5))
   ))
   :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.? a!))
   :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::pow2k_loop_boundary_spec
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.)
  (forall ((a! Poly)) (!
    (= (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.? a!)
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
                (<= (Mul 19 (uClip 64 (bitshl (I 1) (I 54)))) 18446744073709551615)
                (<= (Mul 77 (Mul (uClip 64 (bitshl (I 1) (I 54))) (uClip 64 (bitshl (I 1) (I 54)))))
                 340282366920938463463374607431768211455
               ))
               (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.? a! (
                 I (uClip 64 (bitshl (I 1) (I 54)))
              )))
              (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_0_val_boundaries.? a! (I (uClip
                 64 (bitshl (I 1) (I 54))
             ))))
             (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ci_val_boundaries.? a!)
            )
            (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.ai_val_boundaries.? a!)
           )
           (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
                 a!
               ))
              ) (I 0)
             )
            ) (uClip 64 (bitshl (I 1) (I 52)))
          ))
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
                a!
              ))
             ) (I 1)
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
               a!
             ))
            ) (I 2)
           )
          ) (uClip 64 (bitshl (I 1) (I 52)))
        ))
        (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
              a!
            ))
           ) (I 3)
          )
         ) (uClip 64 (bitshl (I 1) (I 52)))
       ))
       (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_return.?
             a!
           ))
          ) (I 4)
         )
        ) (uClip 64 (bitshl (I 1) (I 52)))
      ))
      (< (uClip 64 (bitshl (I 1) (I 52))) (uClip 64 (bitshl (I 1) (I 54))))
    ))
    :pattern ((curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.?
      a!
    ))
    :qid internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.pow2k_loop_boundary_spec.?_definition
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::mul_lemmas::lemma_m
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m. (Int Int
  Int Int
 ) Bool
)
(declare-const %%global_location_label%%9 Bool)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((x! Int) (y! Int) (bx! Int) (by! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m. x! y! bx! by!) (
     and
     (=>
      %%global_location_label%%9
      (< x! bx!)
     )
     (=>
      %%global_location_label%%10
      (< y! by!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m. x! y! bx!
     by!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m. (Int Int
  Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (y! Int) (bx! Int) (by! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m. x! y! bx! by!) (
     < (Mul (uClip 128 x!) (uClip 128 y!)) (Mul (uClip 128 bx!) (uClip 128 by!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m. x! y! bx!
     by!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m._definition
)))

;; Function-Specs curve25519_dalek::specs::field_specs_u64::pow255_gt_19
(declare-fun ens%curve25519_dalek!specs.field_specs_u64.pow255_gt_19. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!specs.field_specs_u64.pow255_gt_19. no%param) (> (vstd!arithmetic.power2.pow2.?
      (I 255)
     ) 19
   ))
   :pattern ((ens%curve25519_dalek!specs.field_specs_u64.pow255_gt_19. no%param))
   :qid internal_ens__curve25519_dalek!specs.field_specs_u64.pow255_gt_19._definition
   :skolemid skolem_internal_ens__curve25519_dalek!specs.field_specs_u64.pow255_gt_19._definition
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

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::pow2_51_lemmas::lemma_u64_div_and_mod_51
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_u64_div_and_mod_51.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%11 Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((ai! Int) (bi! Int) (v! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_u64_div_and_mod_51.
     ai! bi! v!
    ) (and
     (=>
      %%global_location_label%%11
      (= ai! (uClip 64 (bitshr (I v!) (I 51))))
     )
     (=>
      %%global_location_label%%12
      (= bi! (uClip 64 (bitand (I v!) (I curve25519_dalek!specs.field_specs_u64.mask51.?))))
   )))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_u64_div_and_mod_51.
     ai! bi! v!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_u64_div_and_mod_51._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_u64_div_and_mod_51._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_u64_div_and_mod_51.
 (Int Int Int) Bool
)
(assert
 (forall ((ai! Int) (bi! Int) (v! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_u64_div_and_mod_51.
     ai! bi! v!
    ) (and
     (= ai! (EucDiv v! (uClip 64 (vstd!arithmetic.power2.pow2.? (I 51)))))
     (= bi! (EucMod v! (uClip 64 (vstd!arithmetic.power2.pow2.? (I 51)))))
     (= v! (Add (Mul ai! (vstd!arithmetic.power2.pow2.? (I 51))) bi!))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_u64_div_and_mod_51.
     ai! bi! v!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_u64_div_and_mod_51._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.pow2_51_lemmas.lemma_u64_div_and_mod_51._definition
)))

;; Function-Specs curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::lemma_term_product_bounds
(declare-fun req%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_term_product_bounds.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((a! %%Function%%) (bound! Int)) (!
   (= (req%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_term_product_bounds.
     a! bound!
    ) (and
     (=>
      %%global_location_label%%13
      (<= (Mul 19 bound!) 18446744073709551615)
     )
     (=>
      %%global_location_label%%14
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
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. a!)
             ) i$
            )
           ) bound!
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. a!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__field_lemmas__pow2k_lemmas__lemma_term_product_bounds_32
        :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__pow2k_lemmas__lemma_term_product_bounds_32
   )))))
   :pattern ((req%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_term_product_bounds.
     a! bound!
   ))
   :qid internal_req__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_term_product_bounds._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_term_product_bounds._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_term_product_bounds.
 (%%Function%% Int) Bool
)
(assert
 (forall ((a! %%Function%%) (bound! Int)) (!
   (= (ens%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_term_product_bounds.
     a! bound!
    ) (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.? (Poly%array%.
      a!
     ) (I bound!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_term_product_bounds.
     a! bound!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_term_product_bounds._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.lemma_term_product_bounds._definition
)))

;; Function-Def curve25519_dalek::lemmas::field_lemmas::pow2k_lemmas::lemma_term_product_bounds
;; curve25519-dalek/src/lemmas/field_lemmas/pow2k_lemmas.rs:125:1: 125:64 (#0)
(get-info :all-statistics)
(push)
 (declare-const a! %%Function%%)
 (declare-const bound! Int)
 (declare-const i@ Poly)
 (declare-const j@ Poly)
 (declare-const tmp%1 Int)
 (declare-const tmp%2 Int)
 (declare-const tmp%3 Int)
 (declare-const tmp%4 Int)
 (declare-const bound19@ Int)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%array%. a!) (ARRAY $ (UINT 64) $ (CONST_INT 5)))
 )
 (assert
  (uInv 64 bound!)
 )
 (assert
  (<= (Mul 19 bound!) 18446744073709551615)
 )
 (assert
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
      (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. a!)
         ) i$
        )
       ) bound!
    )))
    :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
        $ (CONST_INT 5)
       ) (Poly%array%. a!)
      ) i$
    ))
    :qid user_curve25519_dalek__lemmas__field_lemmas__pow2k_lemmas__lemma_term_product_bounds_35
    :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__pow2k_lemmas__lemma_term_product_bounds_35
 )))
 ;; assertion failed
 (declare-const %%location_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%1 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%2 Bool)
 ;; assertion failed
 (declare-const %%location_label%%3 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%4 Bool)
 (assert
  (not (=>
    (= bound19@ (uClip 64 (Mul 19 bound!)))
    (and
     (=>
      (ens%vstd!arithmetic.mul.lemma_mul_is_associative. 19 bound! bound!)
      (=>
       %%location_label%%0
       (= (Mul bound! (Mul 19 bound!)) (Mul 19 (Mul bound! bound!)))
     ))
     (=>
      (= (Mul bound! (Mul 19 bound!)) (Mul 19 (Mul bound! bound!)))
      (and
       (=>
        (has_type i@ INT)
        (=>
         (has_type j@ INT)
         (=>
          (and
           (let
            ((tmp%%$ (%I i@)))
            (and
             (<= 0 tmp%%$)
             (<= tmp%%$ 4)
           ))
           (let
            ((tmp%%$ (%I j@)))
            (and
             (<= 0 tmp%%$)
             (<= tmp%%$ 4)
          )))
          (=>
           (= tmp%1 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                 64
                ) $ (CONST_INT 5)
               ) (Poly%array%. a!)
              ) i@
           )))
           (=>
            (= tmp%2 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                  64
                 ) $ (CONST_INT 5)
                ) (Poly%array%. a!)
               ) j@
            )))
            (and
             (=>
              %%location_label%%1
              (req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m. tmp%1 tmp%2 bound!
               bound!
             ))
             (=>
              (ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m. tmp%1 tmp%2 bound!
               bound!
              )
              (=>
               (= tmp%3 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
                     64
                    ) $ (CONST_INT 5)
                   ) (Poly%array%. a!)
                  ) i@
               )))
               (=>
                (= tmp%4 (uClip 64 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
                      $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. a!)
                     ) j@
                )))))
                (and
                 (=>
                  %%location_label%%2
                  (req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m. tmp%3 tmp%4 bound!
                   bound19@
                 ))
                 (=>
                  (ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_m. tmp%3 tmp%4 bound!
                   bound19@
                  )
                  (=>
                   %%location_label%%3
                   (and
                    (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                           $ (UINT 64) $ (CONST_INT 5)
                          ) (Poly%array%. a!)
                         ) i@
                       ))
                      ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                            UINT 64
                           ) $ (CONST_INT 5)
                          ) (Poly%array%. a!)
                         ) j@
                      )))
                     ) (Mul bound! bound!)
                    )
                    (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                           $ (UINT 64) $ (CONST_INT 5)
                          ) (Poly%array%. a!)
                         ) i@
                       ))
                      ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                            $ (UINT 64) $ (CONST_INT 5)
                           ) (Poly%array%. a!)
                          ) j@
                      ))))
                     ) (Mul 19 (Mul bound! bound!))
       ))))))))))))))
       (=>
        (forall ((i$ Poly) (j$ Poly)) (!
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
               (<= tmp%%$ 4)
             ))
             (let
              ((tmp%%$ (%I j$)))
              (and
               (<= 0 tmp%%$)
               (<= tmp%%$ 4)
            )))
            (and
             (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                    $ (UINT 64) $ (CONST_INT 5)
                   ) (Poly%array%. a!)
                  ) i$
                ))
               ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                     UINT 64
                    ) $ (CONST_INT 5)
                   ) (Poly%array%. a!)
                  ) j$
               )))
              ) (Mul bound! bound!)
             )
             (< (Mul (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                    $ (UINT 64) $ (CONST_INT 5)
                   ) (Poly%array%. a!)
                  ) i$
                ))
               ) (uClip 128 (Mul 19 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                     $ (UINT 64) $ (CONST_INT 5)
                    ) (Poly%array%. a!)
                   ) j$
               ))))
              ) (Mul 19 (Mul bound! bound!))
          ))))
          :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) (Poly%array%. a!)
            ) i$
           ) (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT
               5
              )
             ) (Poly%array%. a!)
            ) j$
          ))
          :qid user_curve25519_dalek__lemmas__field_lemmas__pow2k_lemmas__lemma_term_product_bounds_34
          :skolemid skolem_user_curve25519_dalek__lemmas__field_lemmas__pow2k_lemmas__lemma_term_product_bounds_34
        ))
        (=>
         %%location_label%%4
         (curve25519_dalek!lemmas.field_lemmas.pow2k_lemmas.term_product_bounds_spec.? (Poly%array%.
           a!
          ) (I bound!)
 )))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
