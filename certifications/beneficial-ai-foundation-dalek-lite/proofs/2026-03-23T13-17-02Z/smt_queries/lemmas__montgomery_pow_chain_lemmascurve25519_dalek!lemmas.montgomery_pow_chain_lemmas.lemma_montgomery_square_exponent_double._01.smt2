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

;; MODULE 'module lemmas::montgomery_pow_chain_lemmas'
;; curve25519-dalek/src/lemmas/montgomery_pow_chain_lemmas.rs:145:1: 152:2 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_twice. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_associative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow1. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_adds. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_multiplies. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_distributes. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_adds. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.primality_specs.is_prime. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.group_order. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_mod_twice. fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop.
  fuel%vstd!arithmetic.mul.lemma_mul_is_associative. fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.
  fuel%vstd!arithmetic.power.lemma_pow1. fuel%vstd!arithmetic.power.lemma_pow_adds.
  fuel%vstd!arithmetic.power.lemma_pow_multiplies. fuel%vstd!arithmetic.power.lemma_pow_distributes.
  fuel%vstd!arithmetic.power2.lemma_pow2_pos. fuel%vstd!arithmetic.power2.lemma_pow2_adds.
  fuel%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.
  fuel%curve25519_dalek!specs.primality_specs.is_prime. fuel%curve25519_dalek!specs.scalar52_specs.group_order.
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

;; Function-Decl vstd::arithmetic::power::pow
(declare-fun vstd!arithmetic.power.pow.? (Poly Poly) Int)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::group_order
(declare-fun curve25519_dalek!specs.scalar52_specs.group_order.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::montgomery_pow_chain_lemmas::montgomery_invert_chain_exponent
(declare-fun curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.?
 (Poly) Int
)

;; Function-Decl curve25519_dalek::specs::primality_specs::is_prime
(declare-fun curve25519_dalek!specs.primality_specs.is_prime.? (Poly) Bool)

;; Function-Specs vstd::arithmetic::div_mod::lemma_small_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(declare-const %%global_location_label%%0 Bool)
(declare-const %%global_location_label%%1 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (and
     (=>
      %%global_location_label%%0
      (< x! m!)
     )
     (=>
      %%global_location_label%%1
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

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_twice
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_twice. (Int Int) Bool)
(declare-const %%global_location_label%%2 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!) (=>
     %%global_location_label%%2
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_twice_0
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_twice_0
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%3 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!) (=>
     %%global_location_label%%3
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_1
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_1
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_basics
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_basics. (Int) Bool)
(assert
 (forall ((x! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_basics. x!) (and
     (= (Mul 0 x!) 0)
     (= (Mul x! 0) 0)
     (= (Mul x! 1) x!)
     (= (Mul 1 x!) x!)
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_basics. x!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_basics._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_basics._definition
)))

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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_3
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_3
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow1
(declare-fun ens%vstd!arithmetic.power.lemma_pow1. (Int) Bool)
(assert
 (forall ((b! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma_pow1. b!) (= (vstd!arithmetic.power.pow.? (I b!)
      (I 1)
     ) b!
   ))
   :pattern ((ens%vstd!arithmetic.power.lemma_pow1. b!))
   :qid internal_ens__vstd!arithmetic.power.lemma_pow1._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma_pow1._definition
)))

;; Broadcast vstd::arithmetic::power::lemma_pow1
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma_pow1.)
  (forall ((b! Poly)) (!
    (=>
     (has_type b! INT)
     (= (vstd!arithmetic.power.pow.? b! (I 1)) (%I b!))
    )
    :pattern ((vstd!arithmetic.power.pow.? b! (I 1)))
    :qid user_vstd__arithmetic__power__lemma_pow1_4
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow1_4
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow_adds
(declare-fun ens%vstd!arithmetic.power.lemma_pow_adds. (Int Int Int) Bool)
(assert
 (forall ((b! Int) (e1! Int) (e2! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma_pow_adds. b! e1! e2!) (= (vstd!arithmetic.power.pow.?
      (I b!) (I (nClip (Add e1! e2!)))
     ) (Mul (vstd!arithmetic.power.pow.? (I b!) (I e1!)) (vstd!arithmetic.power.pow.? (I
        b!
       ) (I e2!)
   ))))
   :pattern ((ens%vstd!arithmetic.power.lemma_pow_adds. b! e1! e2!))
   :qid internal_ens__vstd!arithmetic.power.lemma_pow_adds._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma_pow_adds._definition
)))

;; Broadcast vstd::arithmetic::power::lemma_pow_adds
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma_pow_adds.)
  (forall ((b! Poly) (e1! Int) (e2! Int)) (!
    (=>
     (and
      (has_type b! INT)
      (<= 0 e1!)
      (<= 0 e2!)
     )
     (= (vstd!arithmetic.power.pow.? b! (I (nClip (Add e1! e2!)))) (Mul (vstd!arithmetic.power.pow.?
        b! (I e1!)
       ) (vstd!arithmetic.power.pow.? b! (I e2!))
    )))
    :pattern ((vstd!arithmetic.power.pow.? b! (I (nClip (Add e1! e2!)))))
    :qid user_vstd__arithmetic__power__lemma_pow_adds_5
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_adds_5
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow_multiplies
(declare-fun ens%vstd!arithmetic.power.lemma_pow_multiplies. (Int Int Int) Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma_pow_multiplies. a! b! c!) (and
     (<= 0 (nClip (Mul b! c!)))
     (= (vstd!arithmetic.power.pow.? (I (vstd!arithmetic.power.pow.? (I a!) (I b!))) (I c!))
      (vstd!arithmetic.power.pow.? (I a!) (I (nClip (Mul b! c!))))
   )))
   :pattern ((ens%vstd!arithmetic.power.lemma_pow_multiplies. a! b! c!))
   :qid internal_ens__vstd!arithmetic.power.lemma_pow_multiplies._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma_pow_multiplies._definition
)))

;; Broadcast vstd::arithmetic::power::lemma_pow_multiplies
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma_pow_multiplies.)
  (forall ((a! Poly) (b! Poly) (c! Poly)) (!
    (=>
     (and
      (has_type a! INT)
      (has_type b! NAT)
      (has_type c! NAT)
     )
     (and
      (<= 0 (nClip (Mul (%I b!) (%I c!))))
      (= (vstd!arithmetic.power.pow.? (I (vstd!arithmetic.power.pow.? a! b!)) c!) (vstd!arithmetic.power.pow.?
        a! (I (nClip (Mul (%I b!) (%I c!))))
    ))))
    :pattern ((vstd!arithmetic.power.pow.? (I (vstd!arithmetic.power.pow.? a! b!)) c!))
    :qid user_vstd__arithmetic__power__lemma_pow_multiplies_6
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_multiplies_6
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow_distributes
(declare-fun ens%vstd!arithmetic.power.lemma_pow_distributes. (Int Int Int) Bool)
(assert
 (forall ((a! Int) (b! Int) (e! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma_pow_distributes. a! b! e!) (= (vstd!arithmetic.power.pow.?
      (I (Mul a! b!)) (I e!)
     ) (Mul (vstd!arithmetic.power.pow.? (I a!) (I e!)) (vstd!arithmetic.power.pow.? (I b!)
       (I e!)
   ))))
   :pattern ((ens%vstd!arithmetic.power.lemma_pow_distributes. a! b! e!))
   :qid internal_ens__vstd!arithmetic.power.lemma_pow_distributes._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma_pow_distributes._definition
)))

;; Broadcast vstd::arithmetic::power::lemma_pow_distributes
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma_pow_distributes.)
  (forall ((a! Int) (b! Int) (e! Poly)) (!
    (=>
     (has_type e! NAT)
     (= (vstd!arithmetic.power.pow.? (I (Mul a! b!)) e!) (Mul (vstd!arithmetic.power.pow.?
        (I a!) e!
       ) (vstd!arithmetic.power.pow.? (I b!) e!)
    )))
    :pattern ((vstd!arithmetic.power.pow.? (I (Mul a! b!)) e!))
    :qid user_vstd__arithmetic__power__lemma_pow_distributes_7
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_distributes_7
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_8
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_8
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_adds_9
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_adds_9
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

;; Function-Axioms curve25519_dalek::lemmas::montgomery_pow_chain_lemmas::montgomery_invert_chain_exponent
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.?
      no%param
     ) (let
      ((e$ 16))
      (let
       ((e$1 (nClip (Add (nClip (Mul 85070591730234615865843651857942052864 e$)) 5))))
       (let
        ((e$2 (nClip (Add (nClip (Mul 16 e$1)) 3))))
        (let
         ((e$3 (nClip (Add (nClip (Mul 32 e$2)) 15))))
         (let
          ((e$4 (nClip (Add (nClip (Mul 32 e$3)) 15))))
          (let
           ((e$5 (nClip (Add (nClip (Mul 16 e$4)) 9))))
           (let
            ((e$6 (nClip (Add (nClip (Mul 4 e$5)) 3))))
            (let
             ((e$7 (nClip (Add (nClip (Mul 32 e$6)) 15))))
             (let
              ((e$8 (nClip (Add (nClip (Mul 16 e$7)) 5))))
              (let
               ((e$9 (nClip (Add (nClip (Mul 64 e$8)) 5))))
               (let
                ((e$10 (nClip (Add (nClip (Mul 8 e$9)) 7))))
                (let
                 ((e$11 (nClip (Add (nClip (Mul 32 e$10)) 15))))
                 (let
                  ((e$12 (nClip (Add (nClip (Mul 32 e$11)) 7))))
                  (let
                   ((e$13 (nClip (Add (nClip (Mul 16 e$12)) 3))))
                   (let
                    ((e$14 (nClip (Add (nClip (Mul 32 e$13)) 11))))
                    (let
                     ((e$15 (nClip (Add (nClip (Mul 64 e$14)) 11))))
                     (let
                      ((e$16 (nClip (Add (nClip (Mul 1024 e$15)) 9))))
                      (let
                       ((e$17 (nClip (Add (nClip (Mul 16 e$16)) 3))))
                       (let
                        ((e$18 (nClip (Add (nClip (Mul 32 e$17)) 3))))
                        (let
                         ((e$19 (nClip (Add (nClip (Mul 32 e$18)) 3))))
                         (let
                          ((e$20 (nClip (Add (nClip (Mul 32 e$19)) 9))))
                          (let
                           ((e$21 (nClip (Add (nClip (Mul 16 e$20)) 7))))
                           (let
                            ((e$22 (nClip (Add (nClip (Mul 64 e$21)) 15))))
                            (let
                             ((e$23 (nClip (Add (nClip (Mul 32 e$22)) 11))))
                             (let
                              ((e$24 (nClip (Add (nClip (Mul 8 e$23)) 5))))
                              (let
                               ((e$25 (nClip (Add (nClip (Mul 64 e$24)) 15))))
                               (let
                                ((e$26 (nClip (Add (nClip (Mul 8 e$25)) 5))))
                                (let
                                 ((e$27 (nClip (Add (nClip (Mul 8 e$26)) 3))))
                                 e$27
    )))))))))))))))))))))))))))))
    :pattern ((curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.?
      no%param
    ))
    :qid internal_curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.?
      no%param
   )))
   :pattern ((curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.?
     no%param
   ))
   :qid internal_curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.montgomery_invert_chain_exponent.?_pre_post_definition
)))

;; Function-Axioms curve25519_dalek::specs::primality_specs::is_prime
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.primality_specs.is_prime.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.primality_specs.is_prime.)
  (forall ((n! Poly)) (!
    (= (curve25519_dalek!specs.primality_specs.is_prime.? n!) (and
      (> (%I n!) 1)
      (forall ((d$ Int)) (!
        (=>
         (<= 0 d$)
         (=>
          (let
           ((tmp%%$ d$))
           (and
            (< 1 tmp%%$)
            (< tmp%%$ (%I n!))
          ))
          (not (= (EucMod (%I n!) d$) 0))
        ))
        :pattern ((EucMod (%I n!) d$))
        :qid user_curve25519_dalek__specs__primality_specs__is_prime_10
        :skolemid skolem_user_curve25519_dalek__specs__primality_specs__is_prime_10
    ))))
    :pattern ((curve25519_dalek!specs.primality_specs.is_prime.? n!))
    :qid internal_curve25519_dalek!specs.primality_specs.is_prime.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.primality_specs.is_prime.?_definition
))))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow_nonnegative
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative.
 (Int Int) Bool
)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((base! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base!
     n!
    ) (=>
     %%global_location_label%%4
     (>= base! 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative.
     base! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative.
 (Int Int) Bool
)
(assert
 (forall ((base! Int) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base!
     n!
    ) (>= (vstd!arithmetic.power.pow.? (I base!) (I n!)) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative.
     base! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow_mod_congruent
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%5 Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((a! Int) (b! Int) (n! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent. a!
     b! n! m!
    ) (and
     (=>
      %%global_location_label%%5
      (> m! 0)
     )
     (=>
      %%global_location_label%%6
      (= (EucMod a! m!) (EucMod b! m!))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent.
     a! b! n! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent.
 (Int Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (n! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent. a!
     b! n! m!
    ) (= (EucMod (vstd!arithmetic.power.pow.? (I a!) (I n!)) m!) (EucMod (vstd!arithmetic.power.pow.?
       (I b!) (I n!)
      ) m!
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent.
     a! b! n! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_mod_congruent._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_fermat_little_theorem
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_fermat_little_theorem.
 (Int Int) Bool
)
(declare-const %%global_location_label%%7 Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (prime! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_fermat_little_theorem.
     x! prime!
    ) (and
     (=>
      %%global_location_label%%7
      (curve25519_dalek!specs.primality_specs.is_prime.? (I prime!))
     )
     (=>
      %%global_location_label%%8
      (not (= (EucMod x! prime!) 0))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_fermat_little_theorem.
     x! prime!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_fermat_little_theorem._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_fermat_little_theorem._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_fermat_little_theorem.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (prime! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_fermat_little_theorem.
     x! prime!
    ) (= (EucMod (nClip (vstd!arithmetic.power.pow.? (I x!) (I (nClip (Sub prime! 1)))))
      prime!
     ) 1
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_fermat_little_theorem.
     x! prime!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_fermat_little_theorem._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_fermat_little_theorem._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_pow_chain_lemmas::lemma_montgomery_mul_exponent_add
(declare-fun req%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add.
 (Int Int Int Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%9 Bool)
(declare-const %%global_location_label%%10 Bool)
(declare-const %%global_location_label%%11 Bool)
(declare-const %%global_location_label%%12 Bool)
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((self_val! Int) (a! Int) (b! Int) (result! Int) (ea! Int) (eb! Int) (R! Int)
   (L! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add.
     self_val! a! b! result! ea! eb! R! L!
    ) (and
     (=>
      %%global_location_label%%9
      (> L! 0)
     )
     (=>
      %%global_location_label%%10
      (> R! 0)
     )
     (=>
      %%global_location_label%%11
      (> ea! 0)
     )
     (=>
      %%global_location_label%%12
      (> eb! 0)
     )
     (=>
      %%global_location_label%%13
      (= (EucMod (nClip (Mul result! R!)) L!) (EucMod (nClip (Mul a! b!)) L!))
     )
     (=>
      %%global_location_label%%14
      (= (EucMod (nClip (Mul a! (nClip (vstd!arithmetic.power.pow.? (I R!) (I (nClip (Sub ea! 1)))))))
        L!
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I self_val!) (I ea!))) L!)
     ))
     (=>
      %%global_location_label%%15
      (= (EucMod (nClip (Mul b! (nClip (vstd!arithmetic.power.pow.? (I R!) (I (nClip (Sub eb! 1)))))))
        L!
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I self_val!) (I eb!))) L!)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add.
     self_val! a! b! result! ea! eb! R! L!
   ))
   :qid internal_req__curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add.
 (Int Int Int Int Int Int Int Int) Bool
)
(assert
 (forall ((self_val! Int) (a! Int) (b! Int) (result! Int) (ea! Int) (eb! Int) (R! Int)
   (L! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add.
     self_val! a! b! result! ea! eb! R! L!
    ) (= (EucMod (nClip (Mul result! (nClip (vstd!arithmetic.power.pow.? (I R!) (I (nClip (Sub
             (nClip (Add ea! eb!)) 1
       ))))))
      ) L!
     ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I self_val!) (I (nClip (Add ea! eb!)))))
      L!
   )))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add.
     self_val! a! b! result! ea! eb! R! L!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add._definition
)))

;; Function-Specs curve25519_dalek::lemmas::montgomery_pow_chain_lemmas::lemma_montgomery_square_exponent_double
(declare-fun req%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_square_exponent_double.
 (Int Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%16 Bool)
(declare-const %%global_location_label%%17 Bool)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(declare-const %%global_location_label%%20 Bool)
(assert
 (forall ((self_val! Int) (a! Int) (result! Int) (e! Int) (R! Int) (L! Int)) (!
   (= (req%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_square_exponent_double.
     self_val! a! result! e! R! L!
    ) (and
     (=>
      %%global_location_label%%16
      (> L! 0)
     )
     (=>
      %%global_location_label%%17
      (> R! 0)
     )
     (=>
      %%global_location_label%%18
      (> e! 0)
     )
     (=>
      %%global_location_label%%19
      (= (EucMod (nClip (Mul result! R!)) L!) (EucMod (nClip (Mul a! a!)) L!))
     )
     (=>
      %%global_location_label%%20
      (= (EucMod (nClip (Mul a! (nClip (vstd!arithmetic.power.pow.? (I R!) (I (nClip (Sub e! 1)))))))
        L!
       ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I self_val!) (I e!))) L!)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_square_exponent_double.
     self_val! a! result! e! R! L!
   ))
   :qid internal_req__curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_square_exponent_double._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_square_exponent_double._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_square_exponent_double.
 (Int Int Int Int Int Int) Bool
)
(assert
 (forall ((self_val! Int) (a! Int) (result! Int) (e! Int) (R! Int) (L! Int)) (!
   (= (ens%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_square_exponent_double.
     self_val! a! result! e! R! L!
    ) (= (EucMod (nClip (Mul result! (nClip (vstd!arithmetic.power.pow.? (I R!) (I (nClip (Sub
             (nClip (Mul 2 e!)) 1
       ))))))
      ) L!
     ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I self_val!) (I (nClip (Mul 2 e!)))))
      L!
   )))
   :pattern ((ens%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_square_exponent_double.
     self_val! a! result! e! R! L!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_square_exponent_double._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_square_exponent_double._definition
)))

;; Function-Def curve25519_dalek::lemmas::montgomery_pow_chain_lemmas::lemma_montgomery_square_exponent_double
;; curve25519-dalek/src/lemmas/montgomery_pow_chain_lemmas.rs:145:1: 152:2 (#0)
(get-info :all-statistics)
(push)
 (declare-const self_val! Int)
 (declare-const a! Int)
 (declare-const result! Int)
 (declare-const e! Int)
 (declare-const R! Int)
 (declare-const L! Int)
 (declare-const tmp%1 Bool)
 (assert
  fuel_defaults
 )
 (assert
  (<= 0 self_val!)
 )
 (assert
  (<= 0 a!)
 )
 (assert
  (<= 0 result!)
 )
 (assert
  (<= 0 e!)
 )
 (assert
  (<= 0 R!)
 )
 (assert
  (<= 0 L!)
 )
 (assert
  (> L! 0)
 )
 (assert
  (> R! 0)
 )
 (assert
  (> e! 0)
 )
 (assert
  (= (EucMod (nClip (Mul result! R!)) L!) (EucMod (nClip (Mul a! a!)) L!))
 )
 (assert
  (= (EucMod (nClip (Mul a! (nClip (vstd!arithmetic.power.pow.? (I R!) (I (nClip (Sub e! 1)))))))
    L!
   ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I self_val!) (I e!))) L!)
 ))
 ;; assertion failed
 (declare-const %%location_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%1 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%2 Bool)
 (assert
  (not (=>
    (= tmp%1 (= (nClip (Mul 2 e!)) (nClip (Add e! e!))))
    (and
     (=>
      %%location_label%%0
      tmp%1
     )
     (=>
      tmp%1
      (and
       (=>
        %%location_label%%1
        (req%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add.
         self_val! a! a! result! e! e! R! L!
       ))
       (=>
        (ens%curve25519_dalek!lemmas.montgomery_pow_chain_lemmas.lemma_montgomery_mul_exponent_add.
         self_val! a! a! result! e! e! R! L!
        )
        (=>
         %%location_label%%2
         (= (EucMod (nClip (Mul result! (nClip (vstd!arithmetic.power.pow.? (I R!) (I (nClip (Sub (
                   nClip (Mul 2 e!)
                  ) 1
            ))))))
           ) L!
          ) (EucMod (nClip (vstd!arithmetic.power.pow.? (I self_val!) (I (nClip (Mul 2 e!)))))
           L!
 ))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
