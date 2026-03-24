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

;; MODULE 'module lemmas::scalar_lemmas_::montgomery_reduce_lemmas'
;; curve25519-dalek/src/lemmas/scalar_lemmas_/montgomery_reduce_lemmas.rs:705:1: 705:100 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_is_ordered. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_hoist_inequality. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_bound. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_mod. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_associative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_strict_inequality. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_strictly_positive. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_unfold. FuelId)
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
(declare-const fuel%vstd!bits.lemma_u128_shr_is_div. FuelId)
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
(declare-const fuel%vstd!view.impl&%20.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%24.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.L. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.LFACTOR. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.slice128_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limbs52_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.group_order. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.montgomery_radix. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded. FuelId)
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_div_is_ordered. fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod.
  fuel%vstd!arithmetic.div_mod.lemma_mul_hoist_inequality. fuel%vstd!arithmetic.div_mod.lemma_div_multiples_vanish.
  fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple. fuel%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish.
  fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop.
  fuel%vstd!arithmetic.div_mod.lemma_mod_bound. fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left.
  fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. fuel%vstd!arithmetic.div_mod.lemma_mod_mod.
  fuel%vstd!arithmetic.mul.lemma_mul_is_associative. fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.
  fuel%vstd!arithmetic.mul.lemma_mul_strict_inequality. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. fuel%vstd!arithmetic.mul.lemma_mul_strictly_positive.
  fuel%vstd!arithmetic.power2.lemma_pow2_pos. fuel%vstd!arithmetic.power2.lemma_pow2_unfold.
  fuel%vstd!arithmetic.power2.lemma_pow2_adds. fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases.
  fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index.
  fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_spec_array_as_slice.
  fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!bits.lemma_u128_shr_is_div. fuel%vstd!bits.low_bits_mask. fuel%vstd!bits.lemma_u64_low_bits_mask_is_mod.
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
  fuel%vstd!view.impl&%20.view. fuel%vstd!view.impl&%22.view. fuel%vstd!view.impl&%24.view.
  fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%32.view. fuel%curve25519_dalek!backend.serial.u64.constants.L.
  fuel%curve25519_dalek!backend.serial.u64.constants.LFACTOR. fuel%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul.
  fuel%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52. fuel%curve25519_dalek!specs.scalar52_specs.slice128_as_nat.
  fuel%curve25519_dalek!specs.scalar52_specs.limbs52_as_nat. fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.
  fuel%curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux. fuel%curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.
  fuel%curve25519_dalek!specs.scalar52_specs.group_order. fuel%curve25519_dalek!specs.scalar52_specs.montgomery_radix.
  fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded. fuel%curve25519_dalek!specs.scalar52_specs.spec_mul_internal.
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
(declare-sort vstd!seq.Seq<u64.>. 0)
(declare-sort vstd!seq.Seq<u128.>. 0)
(declare-sort slice%<u64.>. 0)
(declare-sort slice%<u128.>. 0)
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
(declare-fun Poly%vstd!seq.Seq<u64.>. (vstd!seq.Seq<u64.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u64.>. (Poly) vstd!seq.Seq<u64.>.)
(declare-fun Poly%vstd!seq.Seq<u128.>. (vstd!seq.Seq<u128.>.) Poly)
(declare-fun %Poly%vstd!seq.Seq<u128.>. (Poly) vstd!seq.Seq<u128.>.)
(declare-fun Poly%slice%<u64.>. (slice%<u64.>.) Poly)
(declare-fun %Poly%slice%<u64.>. (Poly) slice%<u64.>.)
(declare-fun Poly%slice%<u128.>. (slice%<u128.>.) Poly)
(declare-fun %Poly%slice%<u128.>. (Poly) slice%<u128.>.)
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

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::bits::low_bits_mask
(declare-fun vstd!bits.low_bits_mask.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::group_order
(declare-fun curve25519_dalek!specs.scalar52_specs.group_order.? (Poly) Int)

;; Function-Decl vstd::seq_lib::impl&%0::map
(declare-fun vstd!seq_lib.impl&%0.map.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::L
(declare-fun curve25519_dalek!backend.serial.u64.constants.L.? () curve25519_dalek!backend.serial.u64.scalar.Scalar52.)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::LFACTOR
(declare-fun curve25519_dalek!backend.serial.u64.constants.LFACTOR.? () Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::montgomery_radix
(declare-fun curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::seq_as_nat_52
(declare-fun curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.? (Poly) Int)
(declare-fun curve25519_dalek!specs.scalar52_specs.rec%seq_as_nat_52.? (Poly Fuel)
 Int
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::slice128_as_nat
(declare-fun curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::limbs52_as_nat
(declare-fun curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::scalar52_as_nat
(declare-fun curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly) Int)

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

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_is_ordered
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_is_ordered. (Int Int Int) Bool)
(declare-const %%global_location_label%%5 Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_is_ordered. x! y! z!) (and
     (=>
      %%global_location_label%%5
      (<= x! y!)
     )
     (=>
      %%global_location_label%%6
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
    :qid user_vstd__arithmetic__div_mod__lemma_div_is_ordered_27
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_is_ordered_27
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_small_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(declare-const %%global_location_label%%7 Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (and
     (=>
      %%global_location_label%%7
      (< x! m!)
     )
     (=>
      %%global_location_label%%8
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
(declare-const %%global_location_label%%9 Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (=>
     %%global_location_label%%9
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

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_hoist_inequality
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_hoist_inequality. (Int Int Int)
 Bool
)
(declare-const %%global_location_label%%10 Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_hoist_inequality. x! y! z!) (and
     (=>
      %%global_location_label%%10
      (<= 0 x!)
     )
     (=>
      %%global_location_label%%11
      (< 0 z!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mul_hoist_inequality. x! y! z!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mul_hoist_inequality._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mul_hoist_inequality._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mul_hoist_inequality. (Int Int Int)
 Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mul_hoist_inequality. x! y! z!) (<= (Mul x! (EucDiv
       y! z!
      )
     ) (EucDiv (Mul x! y!) z!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mul_hoist_inequality. x! y! z!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mul_hoist_inequality._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mul_hoist_inequality._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mul_hoist_inequality
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mul_hoist_inequality.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (=>
     (and
      (<= 0 x!)
      (< 0 z!)
     )
     (<= (Mul x! (EucDiv y! z!)) (EucDiv (Mul x! y!) z!))
    )
    :pattern ((Mul x! (EucDiv y! z!)) (EucDiv (Mul x! y!) z!))
    :qid user_vstd__arithmetic__div_mod__lemma_mul_hoist_inequality_29
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_hoist_inequality_29
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_multiples_vanish
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_multiples_vanish. (Int Int) Bool)
(declare-const %%global_location_label%%12 Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_multiples_vanish. x! d!) (=>
     %%global_location_label%%12
     (< 0 d!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_div_multiples_vanish. x! d!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_div_multiples_vanish._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_div_multiples_vanish._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_div_multiples_vanish. (Int Int) Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_div_multiples_vanish. x! d!) (= (EucDiv (Mul d!
       x!
      ) d!
     ) x!
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_div_multiples_vanish. x! d!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_div_multiples_vanish._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_div_multiples_vanish._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_div_multiples_vanish
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_div_multiples_vanish.)
  (forall ((x! Int) (d! Int)) (!
    (=>
     (< 0 d!)
     (= (EucDiv (Mul d! x!) d!) x!)
    )
    :pattern ((EucDiv (Mul d! x!) d!))
    :qid user_vstd__arithmetic__div_mod__lemma_div_multiples_vanish_30
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_multiples_vanish_30
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_by_multiple
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_by_multiple. (Int Int) Bool)
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((b! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_by_multiple. b! d!) (and
     (=>
      %%global_location_label%%13
      (<= 0 b!)
     )
     (=>
      %%global_location_label%%14
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
    :qid user_vstd__arithmetic__div_mod__lemma_div_by_multiple_31
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_by_multiple_31
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_sub_multiples_vanish
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish. (Int Int)
 Bool
)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((b! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_sub_multiples_vanish. b! m!) (=>
     %%global_location_label%%15
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_sub_multiples_vanish_32
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_sub_multiples_vanish_32
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_multiples_vanish
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. (Int Int Int)
 Bool
)
(declare-const %%global_location_label%%16 Bool)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!) (=>
     %%global_location_label%%16
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_multiples_vanish_33
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_multiples_vanish_33
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_add_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_add_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!) (=>
     %%global_location_label%%17
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
    :qid user_vstd__arithmetic__div_mod__lemma_add_mod_noop_34
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_add_mod_noop_34
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_fundamental_div_mod_converse
(declare-fun req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. (Int Int
  Int Int
 ) Bool
)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(declare-const %%global_location_label%%20 Bool)
(assert
 (forall ((x! Int) (d! Int) (q! Int) (r! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse. x! d! q! r!) (
     and
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

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_bound
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_bound. (Int Int) Bool)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!) (=>
     %%global_location_label%%21
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_bound_35
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_bound_35
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_left
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. (Int Int Int) Bool)
(declare-const %%global_location_label%%22 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!) (=>
     %%global_location_label%%22
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!) (= (EucMod (Mul (EucMod
        x! m!
       ) y!
      ) m!
     ) (EucMod (Mul x! y!) m!)
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_left._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mul_mod_noop_left
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (= (EucMod (Mul (EucMod x! m!) y!) m!) (EucMod (Mul x! y!) m!))
    )
    :pattern ((EucMod (Mul x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_left_36
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_left_36
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_right
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. (Int Int Int) Bool)
(declare-const %%global_location_label%%23 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!) (=>
     %%global_location_label%%23
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_37
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_37
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_mod. (Int Int Int) Bool)
(declare-const %%global_location_label%%24 Bool)
(declare-const %%global_location_label%%25 Bool)
(assert
 (forall ((x! Int) (a! Int) (b! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_mod. x! a! b!) (and
     (=>
      %%global_location_label%%24
      (< 0 a!)
     )
     (=>
      %%global_location_label%%25
      (< 0 b!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mod_mod. x! a! b!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mod_mod._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mod_mod._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mod_mod. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (a! Int) (b! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mod_mod. x! a! b!) (and
     (< 0 (Mul a! b!))
     (= (EucMod (EucMod x! (Mul a! b!)) a!) (EucMod x! a!))
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mod_mod. x! a! b!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mod_mod._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mod_mod._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mod_mod
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mod_mod.)
  (forall ((x! Int) (a! Int) (b! Int)) (!
    (=>
     (and
      (< 0 a!)
      (< 0 b!)
     )
     (and
      (< 0 (Mul a! b!))
      (= (EucMod (EucMod x! (Mul a! b!)) a!) (EucMod x! a!))
    ))
    :pattern ((EucMod (EucMod x! (Mul a! b!)) a!) (EucMod x! a!))
    :qid user_vstd__arithmetic__div_mod__lemma_mod_mod_38
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_mod_38
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_associative_39
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_associative_39
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_40
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_40
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_strict_inequality
(declare-fun req%vstd!arithmetic.mul.lemma_mul_strict_inequality. (Int Int Int) Bool)
(declare-const %%global_location_label%%26 Bool)
(declare-const %%global_location_label%%27 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_strict_inequality. x! y! z!) (and
     (=>
      %%global_location_label%%26
      (< x! y!)
     )
     (=>
      %%global_location_label%%27
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
    :qid user_vstd__arithmetic__mul__lemma_mul_strict_inequality_41
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_strict_inequality_41
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_42
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_42
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_other_way_43
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_other_way_43
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_strictly_positive
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_strictly_positive. (Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_strictly_positive. x! y!) (=>
     (and
      (< 0 x!)
      (< 0 y!)
     )
     (< 0 (Mul x! y!))
   ))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_strictly_positive. x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_strictly_positive._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_strictly_positive._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_strictly_positive
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_strictly_positive.)
  (forall ((x! Int) (y! Int)) (!
    (=>
     (and
      (< 0 x!)
      (< 0 y!)
     )
     (< 0 (Mul x! y!))
    )
    :pattern ((Mul x! y!))
    :qid user_vstd__arithmetic__mul__lemma_mul_strictly_positive_44
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_strictly_positive_44
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_45
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_45
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_unfold
(declare-fun req%vstd!arithmetic.power2.lemma_pow2_unfold. (Int) Bool)
(declare-const %%global_location_label%%28 Bool)
(assert
 (forall ((e! Int)) (!
   (= (req%vstd!arithmetic.power2.lemma_pow2_unfold. e!) (=>
     %%global_location_label%%28
     (> e! 0)
   ))
   :pattern ((req%vstd!arithmetic.power2.lemma_pow2_unfold. e!))
   :qid internal_req__vstd!arithmetic.power2.lemma_pow2_unfold._definition
   :skolemid skolem_internal_req__vstd!arithmetic.power2.lemma_pow2_unfold._definition
)))
(declare-fun ens%vstd!arithmetic.power2.lemma_pow2_unfold. (Int) Bool)
(assert
 (forall ((e! Int)) (!
   (= (ens%vstd!arithmetic.power2.lemma_pow2_unfold. e!) (= (vstd!arithmetic.power2.pow2.?
      (I e!)
     ) (nClip (Mul 2 (vstd!arithmetic.power2.pow2.? (I (nClip (Sub e! 1))))))
   ))
   :pattern ((ens%vstd!arithmetic.power2.lemma_pow2_unfold. e!))
   :qid internal_ens__vstd!arithmetic.power2.lemma_pow2_unfold._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power2.lemma_pow2_unfold._definition
)))

;; Broadcast vstd::arithmetic::power2::lemma_pow2_unfold
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power2.lemma_pow2_unfold.)
  (forall ((e! Poly)) (!
    (=>
     (has_type e! NAT)
     (=>
      (> (%I e!) 0)
      (= (vstd!arithmetic.power2.pow2.? e!) (nClip (Mul 2 (vstd!arithmetic.power2.pow2.? (I
           (nClip (Sub (%I e!) 1))
    )))))))
    :pattern ((vstd!arithmetic.power2.pow2.? e!))
    :qid user_vstd__arithmetic__power2__lemma_pow2_unfold_46
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_unfold_46
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_adds_47
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_adds_47
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_strictly_increases
(declare-fun req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. (Int Int) Bool)
(declare-const %%global_location_label%%29 Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!) (=>
     %%global_location_label%%29
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_48
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_48
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
(declare-const %%global_location_label%%30 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u128_shr_is_div. x! shift!) (=>
     %%global_location_label%%30
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
    :qid user_vstd__bits__lemma_u128_shr_is_div_49
    :skolemid skolem_user_vstd__bits__lemma_u128_shr_is_div_49
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
    :qid user_vstd__bits__lemma_u64_low_bits_mask_is_mod_50
    :skolemid skolem_user_vstd__bits__lemma_u64_low_bits_mask_is_mod_50
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

;; Function-Axioms curve25519_dalek::backend::serial::u64::constants::L
(assert
 (fuel_bool_default fuel%curve25519_dalek!backend.serial.u64.constants.L.)
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
(declare-fun %%lambda%%2 () %%Function%%)
(assert
 (forall ((i$ Poly) (x$ Poly)) (!
   (= (%%apply%%1 %%lambda%%2 i$ x$) x$)
   :pattern ((%%apply%%1 %%lambda%%2 i$ x$))
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.slice128_as_nat.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? limbs!) (curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.?
      (vstd!seq_lib.impl&%0.map.? $ (UINT 128) $ NAT (vstd!view.View.view.? $slice (SLICE
         $ (UINT 128)
        ) limbs!
       ) (Poly%fun%2. (mk_fun %%lambda%%2))
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
       :qid user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_51
       :skolemid skolem_user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_51
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.limbs_bounded.? s!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.limbs_bounded.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.limbs_bounded.?_definition
))))

;; Function-Specs curve25519_dalek::specs::scalar52_specs::spec_mul_internal
(declare-fun req%curve25519_dalek!specs.scalar52_specs.spec_mul_internal. (Poly Poly)
 Bool
)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (= (req%curve25519_dalek!specs.scalar52_specs.spec_mul_internal. a! b!) (and
     (=>
      %%global_location_label%%32
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? a!)
     )
     (=>
      %%global_location_label%%33
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

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_five_limbs_equals_to_nat
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_five_limbs_equals_to_nat.
 (%%Function%%) Bool
)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_five_limbs_equals_to_nat. limbs!)
    (= (curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.? (Poly%array%. limbs!))
     (curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.? (vstd!array.spec_array_as_slice.?
       $ (UINT 64) $ (CONST_INT 5) (Poly%array%. limbs!)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_five_limbs_equals_to_nat.
     limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_five_limbs_equals_to_nat._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_five_limbs_equals_to_nat._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_mul_internal_limbs_bounds
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_mul_internal_limbs_bounds.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  %%Function%%
 ) Bool
)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(declare-const %%global_location_label%%36 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (limbs! %%Function%%)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_mul_internal_limbs_bounds.
     a! b! limbs!
    ) (and
     (=>
      %%global_location_label%%34
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
     )))
     (=>
      %%global_location_label%%35
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        b!
     )))
     (=>
      %%global_location_label%%36
      (= (curve25519_dalek!specs.scalar52_specs.spec_mul_internal.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         a!
        ) (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
       ) limbs!
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_mul_internal_limbs_bounds.
     a! b! limbs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_mul_internal_limbs_bounds._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_mul_internal_limbs_bounds._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_mul_internal_limbs_bounds.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  %%Function%%
 ) Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (limbs! %%Function%%)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_mul_internal_limbs_bounds.
     a! b! limbs!
    ) (and
     (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
          $ (CONST_INT 9)
         ) (Poly%array%. limbs!)
        ) (I 0)
       )
      ) (uClip 128 (bitshl (I 1) (I 104)))
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
          $ (CONST_INT 9)
         ) (Poly%array%. limbs!)
        ) (I 1)
       )
      ) (uClip 128 (bitshl (I 1) (I 105)))
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
          $ (CONST_INT 9)
         ) (Poly%array%. limbs!)
        ) (I 2)
       )
      ) (uClip 128 (bitshl (I 1) (I 106)))
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
          $ (CONST_INT 9)
         ) (Poly%array%. limbs!)
        ) (I 3)
       )
      ) (uClip 128 (bitshl (I 1) (I 107)))
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
          $ (CONST_INT 9)
         ) (Poly%array%. limbs!)
        ) (I 4)
       )
      ) (uClip 128 (bitshl (I 1) (I 107)))
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
          $ (CONST_INT 9)
         ) (Poly%array%. limbs!)
        ) (I 5)
       )
      ) (uClip 128 (bitshl (I 1) (I 107)))
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
          $ (CONST_INT 9)
         ) (Poly%array%. limbs!)
        ) (I 6)
       )
      ) (uClip 128 (bitshl (I 1) (I 106)))
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
          $ (CONST_INT 9)
         ) (Poly%array%. limbs!)
        ) (I 7)
       )
      ) (uClip 128 (bitshl (I 1) (I 105)))
     )
     (< (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
          $ (CONST_INT 9)
         ) (Poly%array%. limbs!)
        ) (I 8)
       )
      ) (uClip 128 (bitshl (I 1) (I 104)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_mul_internal_limbs_bounds.
     a! b! limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_mul_internal_limbs_bounds._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_mul_internal_limbs_bounds._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u128_pow2_le_max
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max.
 (Int) Bool
)
(declare-const %%global_location_label%%37 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max. k!)
    (=>
     %%global_location_label%%37
     (< k! 128)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max.
     k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max.
 (Int) Bool
)
(assert
 (forall ((k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max. k!)
    (<= (vstd!arithmetic.power2.pow2.? (I k!)) 340282366920938463463374607431768211455)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max.
     k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::shift_lemmas::lemma_u128_shl_is_mul
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul.
 (Int Int) Bool
)
(declare-const %%global_location_label%%38 Bool)
(declare-const %%global_location_label%%39 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul. x!
     shift!
    ) (and
     (=>
      %%global_location_label%%38
      (let
       ((tmp%%$ shift!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 128)
     )))
     (=>
      %%global_location_label%%39
      (<= (Mul x! (vstd!arithmetic.power2.pow2.? (I shift!))) 340282366920938463463374607431768211455)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul.
     x! shift!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul. x!
     shift!
    ) (= (uClip 128 (bitshl (I x!) (I shift!))) (Mul x! (vstd!arithmetic.power2.pow2.? (
        I shift!
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul.
     x! shift!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul._definition
)))

;; Broadcast curve25519_dalek::lemmas::common_lemmas::shift_lemmas::lemma_u128_shl_is_mul
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shl_is_mul.)
  (forall ((x! Poly) (shift! Poly)) (!
    (=>
     (and
      (has_type x! (UINT 128))
      (has_type shift! (UINT 128))
     )
     (=>
      (and
       (let
        ((tmp%%$ (%I shift!)))
        (and
         (<= 0 tmp%%$)
         (< tmp%%$ 128)
       ))
       (<= (Mul (%I x!) (vstd!arithmetic.power2.pow2.? shift!)) 340282366920938463463374607431768211455)
      )
      (= (uClip 128 (bitshl (I (%I x!)) (I (%I shift!)))) (Mul (%I x!) (vstd!arithmetic.power2.pow2.?
         shift!
    )))))
    :pattern ((uClip 128 (bitshl (I (%I x!)) (I (%I shift!)))))
    :qid user_curve25519_dalek__lemmas__common_lemmas__shift_lemmas__lemma_u128_shl_is_mul_54
    :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__shift_lemmas__lemma_u128_shl_is_mul_54
))))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::shift_lemmas::lemma_u128_shift_is_pow2
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shift_is_pow2.
 (Int) Bool
)
(declare-const %%global_location_label%%40 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shift_is_pow2.
     k!
    ) (=>
     %%global_location_label%%40
     (< k! 128)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shift_is_pow2.
     k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shift_is_pow2._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shift_is_pow2._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shift_is_pow2.
 (Int) Bool
)
(assert
 (forall ((k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shift_is_pow2.
     k!
    ) (= (uClip 128 (bitshl (I (uClip 128 1)) (I k!))) (vstd!arithmetic.power2.pow2.? (
       I k!
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shift_is_pow2.
     k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shift_is_pow2._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_shift_is_pow2._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_bounded_product_satisfies_input_bounds
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_bounded_product_satisfies_input_bounds.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  %%Function%%
 ) Bool
)
(declare-const %%global_location_label%%41 Bool)
(declare-const %%global_location_label%%42 Bool)
(declare-const %%global_location_label%%43 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (limbs! %%Function%%)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_bounded_product_satisfies_input_bounds.
     a! b! limbs!
    ) (and
     (=>
      %%global_location_label%%41
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
     )))
     (=>
      %%global_location_label%%42
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        b!
     )))
     (=>
      %%global_location_label%%43
      (= (curve25519_dalek!specs.scalar52_specs.spec_mul_internal.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         a!
        ) (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
       ) limbs!
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_bounded_product_satisfies_input_bounds.
     a! b! limbs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_bounded_product_satisfies_input_bounds._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_bounded_product_satisfies_input_bounds._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_bounded_product_satisfies_input_bounds.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  %%Function%%
 ) Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (limbs! %%Function%%)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_bounded_product_satisfies_input_bounds.
     a! b! limbs!
    ) (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.?
     (Poly%array%. limbs!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_bounded_product_satisfies_input_bounds.
     a! b! limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_bounded_product_satisfies_input_bounds._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_bounded_product_satisfies_input_bounds._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_bound_scalar
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(declare-const %%global_location_label%%44 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. a!) (=>
     %%global_location_label%%44
     (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       a!
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. a!))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. a!) (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.?
      (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 52 5))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. a!))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_canonical_product_satisfies_canonical_bound
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_canonical_product_satisfies_canonical_bound.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  %%Function%%
 ) Bool
)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(declare-const %%global_location_label%%49 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (limbs! %%Function%%)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_canonical_product_satisfies_canonical_bound.
     a! b! limbs!
    ) (and
     (=>
      %%global_location_label%%45
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
     )))
     (=>
      %%global_location_label%%46
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        b!
     )))
     (=>
      %%global_location_label%%47
      (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         b!
        )
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
     ))
     (=>
      %%global_location_label%%48
      (= (curve25519_dalek!specs.scalar52_specs.spec_mul_internal.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         a!
        ) (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
       ) limbs!
     ))
     (=>
      %%global_location_label%%49
      (= (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (vstd!array.spec_array_as_slice.?
         $ (UINT 128) $ (CONST_INT 9) (Poly%array%. limbs!)
        )
       ) (nClip (Mul (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           a!
          )
         ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           b!
   ))))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_canonical_product_satisfies_canonical_bound.
     a! b! limbs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_canonical_product_satisfies_canonical_bound._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_canonical_product_satisfies_canonical_bound._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_canonical_product_satisfies_canonical_bound.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  %%Function%%
 ) Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (limbs! %%Function%%)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_canonical_product_satisfies_canonical_bound.
     a! b! limbs!
    ) (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.?
     (Poly%array%. limbs!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_canonical_product_satisfies_canonical_bound.
     a! b! limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_canonical_product_satisfies_canonical_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_canonical_product_satisfies_canonical_bound._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::shift_lemmas::lemma_u64_shift_is_pow2
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
 (Int) Bool
)
(declare-const %%global_location_label%%50 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
     k!
    ) (=>
     %%global_location_label%%50
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_u128_cast_64_is_mod
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod.
 (Int) Bool
)
(declare-const %%global_location_label%%51 Bool)
(assert
 (forall ((x! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_u128_cast_64_is_mod.
     x!
    ) (=>
     %%global_location_label%%51
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

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_u128_truncate_and_mask
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_u128_truncate_and_mask.
 (Int Int) Bool
)
(declare-const %%global_location_label%%52 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_u128_truncate_and_mask.
     x! n!
    ) (=>
     %%global_location_label%%52
     (<= n! 64)
   ))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_u128_truncate_and_mask.
     x! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_u128_truncate_and_mask._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_u128_truncate_and_mask._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_u128_truncate_and_mask.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_u128_truncate_and_mask.
     x! n!
    ) (= (uClip 64 (bitand (I (uClip 64 x!)) (I (uClip 64 (vstd!bits.low_bits_mask.? (I n!))))))
     (EucMod x! (vstd!arithmetic.power2.pow2.? (I n!)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_u128_truncate_and_mask.
     x! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_u128_truncate_and_mask._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_u128_truncate_and_mask._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_part1_sum_divisible_by_pow2_52
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_sum_divisible_by_pow2_52.
 (Int Int) Bool
)
(declare-const %%global_location_label%%53 Bool)
(declare-const %%global_location_label%%54 Bool)
(assert
 (forall ((s! Int) (p! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_sum_divisible_by_pow2_52.
     s! p!
    ) (and
     (=>
      %%global_location_label%%53
      (< s! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%54
      (= p! (EucMod (nClip (Mul s! curve25519_dalek!backend.serial.u64.constants.LFACTOR.?))
        (vstd!arithmetic.power2.pow2.? (I 52))
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_sum_divisible_by_pow2_52.
     s! p!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_sum_divisible_by_pow2_52._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_sum_divisible_by_pow2_52._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_sum_divisible_by_pow2_52.
 (Int Int) Bool
)
(assert
 (forall ((s! Int) (p! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_sum_divisible_by_pow2_52.
     s! p!
    ) (= (EucMod (nClip (Add s! (nClip (Mul p! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.?
             $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
               (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                 curve25519_dalek!backend.serial.u64.constants.L.?
             ))))
            ) (I 0)
       )))))
      ) (vstd!arithmetic.power2.pow2.? (I 52))
     ) 0
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_sum_divisible_by_pow2_52.
     s! p!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_sum_divisible_by_pow2_52._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_sum_divisible_by_pow2_52._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_mod_add_eq
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%55 Bool)
(declare-const %%global_location_label%%56 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mod_add_eq. a! b!
     c! m!
    ) (and
     (=>
      %%global_location_label%%55
      (> m! 0)
     )
     (=>
      %%global_location_label%%56
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::shift_lemmas::lemma_u128_right_left_shift_divisible
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_right_left_shift_divisible.
 (Int Int) Bool
)
(declare-const %%global_location_label%%57 Bool)
(declare-const %%global_location_label%%58 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_right_left_shift_divisible.
     x! n!
    ) (and
     (=>
      %%global_location_label%%57
      (< n! 128)
     )
     (=>
      %%global_location_label%%58
      (= (EucMod x! (vstd!arithmetic.power2.pow2.? (I n!))) 0)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_right_left_shift_divisible.
     x! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_right_left_shift_divisible._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_right_left_shift_divisible._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_right_left_shift_divisible.
 (Int Int) Bool
)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_right_left_shift_divisible.
     x! n!
    ) (= (uClip 128 (bitshl (I (uClip 128 (bitshr (I x!) (I n!)))) (I n!))) x!)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_right_left_shift_divisible.
     x! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_right_left_shift_divisible._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u128_right_left_shift_divisible._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_part1_correctness
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_correctness.
 (Int) Bool
)
(declare-const %%global_location_label%%59 Bool)
(assert
 (forall ((sum! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_correctness.
     sum!
    ) (=>
     %%global_location_label%%59
     (< sum! (uClip 128 (bitshl (I 1) (I 108))))
   ))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_correctness.
     sum!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_correctness._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_correctness._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_correctness.
 (Int) Bool
)
(assert
 (forall ((sum! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_correctness.
     sum!
    ) (let
     ((mask52$ 4503599627370495))
     (let
      ((sum_low52$ (uClip 64 (bitand (I (uClip 64 sum!)) (I mask52$)))))
      (let
       ((product$ (uClip 128 (Mul (uClip 128 sum_low52$) (uClip 128 curve25519_dalek!backend.serial.u64.constants.LFACTOR.?)))))
       (let
        ((p$ (uClip 64 (bitand (I (uClip 64 product$)) (I mask52$)))))
        (let
         ((total$ (uClip 128 (Add sum! (Mul (uClip 128 p$) (uClip 128 (%I (vstd!seq.Seq.index.? $
                 (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
                   (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                     (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.constants.L.?)
                  )))
                 ) (I 0)
         ))))))))
         (let
          ((carry$ (uClip 128 (bitshr (I total$) (I 52)))))
          (and
           (< p$ (uClip 64 (bitshl (I 1) (I 52))))
           (= total$ (uClip 128 (bitshl (I carry$) (I 52))))
   ))))))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_correctness.
     sum!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_correctness._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part1_correctness._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_part2_bounds
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part2_bounds.
 (Int) Bool
)
(declare-const %%global_location_label%%60 Bool)
(assert
 (forall ((sum! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part2_bounds.
     sum!
    ) (=>
     %%global_location_label%%60
     (< sum! (uClip 128 (bitshl (I 1) (I 108))))
   ))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part2_bounds.
     sum!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part2_bounds._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part2_bounds._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part2_bounds.
 (Int) Bool
)
(assert
 (forall ((sum! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part2_bounds.
     sum!
    ) (let
     ((carry$ (uClip 128 (bitshr (I sum!) (I 52)))))
     (let
      ((w$ (uClip 64 (bitand (I (uClip 64 sum!)) (I (uClip 64 (Sub (uClip 64 (bitshl (I 1) (I 52)))
             1
      )))))))
      (and
       (and
        (< w$ (uClip 64 (bitshl (I 1) (I 52))))
        (= sum! (Add w$ (uClip 128 (bitshl (I carry$) (I 52)))))
       )
       (< carry$ (uClip 128 (bitshl (I 1) (I 56))))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part2_bounds.
     sum!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part2_bounds._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_part2_bounds._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_l_limb4_is_pow2_44
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_l_limb4_is_pow2_44.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_l_limb4_is_pow2_44.
     no%param
    ) (and
     (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             curve25519_dalek!backend.serial.u64.constants.L.?
         ))))
        ) (I 4)
       )
      ) (vstd!arithmetic.power2.pow2.? (I 44))
     )
     (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             curve25519_dalek!backend.serial.u64.constants.L.?
         ))))
        ) (I 4)
       )
      ) 17592186044416
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_l_limb4_is_pow2_44.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_l_limb4_is_pow2_44._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_l_limb4_is_pow2_44._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_carry8_bound
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry8_bound.
 (Int Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%61 Bool)
(declare-const %%global_location_label%%62 Bool)
(declare-const %%global_location_label%%63 Bool)
(declare-const %%global_location_label%%64 Bool)
(declare-const %%global_location_label%%65 Bool)
(declare-const %%global_location_label%%66 Bool)
(assert
 (forall ((limb8! Int) (n4! Int) (l4! Int) (carry7! Int) (sum8! Int) (carry8! Int))
  (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry8_bound.
     limb8! n4! l4! carry7! sum8! carry8!
    ) (and
     (=>
      %%global_location_label%%61
      (< limb8! (uClip 128 (bitshl (I 1) (I 104))))
     )
     (=>
      %%global_location_label%%62
      (< n4! (uClip 64 (bitshl (I 1) (I 52))))
     )
     (=>
      %%global_location_label%%63
      (= l4! (uClip 64 (bitshl (I 1) (I 44))))
     )
     (=>
      %%global_location_label%%64
      (< carry7! (uClip 128 (bitshl (I 1) (I 56))))
     )
     (=>
      %%global_location_label%%65
      (= sum8! (Add (Add carry7! limb8!) (Mul (uClip 128 n4!) (uClip 128 l4!))))
     )
     (=>
      %%global_location_label%%66
      (= carry8! (uClip 128 (bitshr (I sum8!) (I 52))))
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry8_bound.
     limb8! n4! l4! carry7! sum8! carry8!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry8_bound._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry8_bound._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry8_bound.
 (Int Int Int Int Int Int) Bool
)
(assert
 (forall ((limb8! Int) (n4! Int) (l4! Int) (carry7! Int) (sum8! Int) (carry8! Int))
  (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry8_bound.
     limb8! n4! l4! carry7! sum8! carry8!
    ) (< carry8! (vstd!arithmetic.power2.pow2.? (I 53)))
   )
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry8_bound.
     limb8! n4! l4! carry7! sum8! carry8!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry8_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry8_bound._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_carry_shift_to_nat
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry_shift_to_nat.
 (Int Int) Bool
)
(declare-const %%global_location_label%%67 Bool)
(declare-const %%global_location_label%%68 Bool)
(assert
 (forall ((carry! Int) (carry_bound_bits! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry_shift_to_nat.
     carry! carry_bound_bits!
    ) (and
     (=>
      %%global_location_label%%67
      (<= carry_bound_bits! 72)
     )
     (=>
      %%global_location_label%%68
      (< carry! (vstd!arithmetic.power2.pow2.? (I carry_bound_bits!)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry_shift_to_nat.
     carry! carry_bound_bits!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry_shift_to_nat._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry_shift_to_nat._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry_shift_to_nat.
 (Int Int) Bool
)
(assert
 (forall ((carry! Int) (carry_bound_bits! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry_shift_to_nat.
     carry! carry_bound_bits!
    ) (= (uClip 128 (bitshl (I carry!) (I 52))) (nClip (Mul carry! (vstd!arithmetic.power2.pow2.?
        (I 52)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry_shift_to_nat.
     carry! carry_bound_bits!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry_shift_to_nat._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_carry_shift_to_nat._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_part2_chain_lemmas::lemma_part2_chain_quotient
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part2_chain_lemmas.lemma_part2_chain_quotient.
 (%%Function%% Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int
  Int
 ) Bool
)
(declare-const %%global_location_label%%69 Bool)
(declare-const %%global_location_label%%70 Bool)
(declare-const %%global_location_label%%71 Bool)
(declare-const %%global_location_label%%72 Bool)
(declare-const %%global_location_label%%73 Bool)
(declare-const %%global_location_label%%74 Bool)
(declare-const %%global_location_label%%75 Bool)
(declare-const %%global_location_label%%76 Bool)
(declare-const %%global_location_label%%77 Bool)
(declare-const %%global_location_label%%78 Bool)
(declare-const %%global_location_label%%79 Bool)
(declare-const %%global_location_label%%80 Bool)
(declare-const %%global_location_label%%81 Bool)
(declare-const %%global_location_label%%82 Bool)
(declare-const %%global_location_label%%83 Bool)
(declare-const %%global_location_label%%84 Bool)
(declare-const %%global_location_label%%85 Bool)
(declare-const %%global_location_label%%86 Bool)
(declare-const %%global_location_label%%87 Bool)
(declare-const %%global_location_label%%88 Bool)
(assert
 (forall ((limbs! %%Function%%) (n0! Int) (n1! Int) (n2! Int) (n3! Int) (n4! Int) (carry4!
    Int
   ) (sum5! Int) (sum6! Int) (sum7! Int) (sum8! Int) (carry5! Int) (carry6! Int) (carry7!
    Int
   ) (r0! Int) (r1! Int) (r2! Int) (r3! Int) (r4! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part2_chain_lemmas.lemma_part2_chain_quotient.
     limbs! n0! n1! n2! n3! n4! carry4! sum5! sum6! sum7! sum8! carry5! carry6! carry7!
     r0! r1! r2! r3! r4!
    ) (and
     (=>
      %%global_location_label%%69
      (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.? (
        Poly%array%. limbs!
     )))
     (=>
      %%global_location_label%%70
      (< n0! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%71
      (< n1! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%72
      (< n2! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%73
      (< n3! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%74
      (< n4! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%75
      (let
       ((t_low$ (nClip (Add (nClip (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 128)
                   (vstd!view.View.view.? $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%. limbs!))
                   (I 0)
                  )
                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                       (UINT 128) $ (CONST_INT 9)
                      ) (Poly%array%. limbs!)
                     ) (I 1)
                    )
                   ) (vstd!arithmetic.power2.pow2.? (I 52))
                )))
               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                     (UINT 128) $ (CONST_INT 9)
                    ) (Poly%array%. limbs!)
                   ) (I 2)
                  )
                 ) (vstd!arithmetic.power2.pow2.? (I 104))
              )))
             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                   (UINT 128) $ (CONST_INT 9)
                  ) (Poly%array%. limbs!)
                 ) (I 3)
                )
               ) (vstd!arithmetic.power2.pow2.? (I 156))
            )))
           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                 (UINT 128) $ (CONST_INT 9)
                ) (Poly%array%. limbs!)
               ) (I 4)
              )
             ) (vstd!arithmetic.power2.pow2.? (I 208))
       ))))))
       (let
        ((n$ (curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.? (I n0!) (I n1!)
           (I n2!) (I n3!) (I n4!)
        )))
        (let
         ((l_low$ (nClip (Add (nClip (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 64)
                     (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                        (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                          curve25519_dalek!backend.serial.u64.constants.L.?
                      ))))
                     ) (I 0)
                    )
                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                          UINT 64
                         ) $ (CONST_INT 5)
                        ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                          (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                            curve25519_dalek!backend.serial.u64.constants.L.?
                        ))))
                       ) (I 1)
                      )
                     ) (vstd!arithmetic.power2.pow2.? (I 52))
                  )))
                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                        UINT 64
                       ) $ (CONST_INT 5)
                      ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                        (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                          curve25519_dalek!backend.serial.u64.constants.L.?
                      ))))
                     ) (I 2)
                    )
                   ) (vstd!arithmetic.power2.pow2.? (I 104))
                )))
               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                      UINT 64
                     ) $ (CONST_INT 5)
                    ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                      (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                        curve25519_dalek!backend.serial.u64.constants.L.?
                    ))))
                   ) (I 3)
                  )
                 ) (vstd!arithmetic.power2.pow2.? (I 156))
              )))
             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                    UINT 64
                   ) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                      curve25519_dalek!backend.serial.u64.constants.L.?
                  ))))
                 ) (I 4)
                )
               ) (vstd!arithmetic.power2.pow2.? (I 208))
         ))))))
         (= (EucMod (nClip (Add t_low$ (nClip (Mul n$ l_low$)))) (vstd!arithmetic.power2.pow2.?
            (I 260)
           )
          ) 0
     )))))
     (=>
      %%global_location_label%%76
      (let
       ((t_low$ (nClip (Add (nClip (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 128)
                   (vstd!view.View.view.? $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%. limbs!))
                   (I 0)
                  )
                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                       (UINT 128) $ (CONST_INT 9)
                      ) (Poly%array%. limbs!)
                     ) (I 1)
                    )
                   ) (vstd!arithmetic.power2.pow2.? (I 52))
                )))
               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                     (UINT 128) $ (CONST_INT 9)
                    ) (Poly%array%. limbs!)
                   ) (I 2)
                  )
                 ) (vstd!arithmetic.power2.pow2.? (I 104))
              )))
             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                   (UINT 128) $ (CONST_INT 9)
                  ) (Poly%array%. limbs!)
                 ) (I 3)
                )
               ) (vstd!arithmetic.power2.pow2.? (I 156))
            )))
           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                 (UINT 128) $ (CONST_INT 9)
                ) (Poly%array%. limbs!)
               ) (I 4)
              )
             ) (vstd!arithmetic.power2.pow2.? (I 208))
       ))))))
       (let
        ((l0_val$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
               64
              ) $ (CONST_INT 5)
             ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
               (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                 curve25519_dalek!backend.serial.u64.constants.L.?
             ))))
            ) (I 0)
        ))))
        (let
         ((l1$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  curve25519_dalek!backend.serial.u64.constants.L.?
              ))))
             ) (I 1)
         ))))
         (let
          ((l2$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                   curve25519_dalek!backend.serial.u64.constants.L.?
               ))))
              ) (I 2)
          ))))
          (let
           ((l4$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                 $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                    curve25519_dalek!backend.serial.u64.constants.L.?
                ))))
               ) (I 4)
           ))))
           (let
            ((coeff0$ (nClip (Mul n0! l0_val$))))
            (let
             ((coeff1$ (nClip (Add (nClip (Mul n0! l1$)) (nClip (Mul n1! l0_val$))))))
             (let
              ((coeff2$ (nClip (Add (nClip (Add (nClip (Mul n0! l2$)) (nClip (Mul n1! l1$)))) (nClip
                   (Mul n2! l0_val$)
              )))))
              (let
               ((coeff3$ (nClip (Add (nClip (Add (nClip (Mul n1! l2$)) (nClip (Mul n2! l1$)))) (nClip
                    (Mul n3! l0_val$)
               )))))
               (let
                ((coeff4$ (nClip (Add (nClip (Add (nClip (Add (nClip (Mul n0! l4$)) (nClip (Mul n2! l2$))))
                      (nClip (Mul n3! l1$))
                     )
                    ) (nClip (Mul n4! l0_val$))
                ))))
                (let
                 ((nl_low_coeffs$ (nClip (Add (nClip (Add (nClip (Add (nClip (Add coeff0$ (nClip (Mul coeff1$
                             (vstd!arithmetic.power2.pow2.? (I 52))
                          )))
                         ) (nClip (Mul coeff2$ (vstd!arithmetic.power2.pow2.? (I 104))))
                        )
                       ) (nClip (Mul coeff3$ (vstd!arithmetic.power2.pow2.? (I 156))))
                      )
                     ) (nClip (Mul coeff4$ (vstd!arithmetic.power2.pow2.? (I 208))))
                 ))))
                 (= (nClip (Add t_low$ nl_low_coeffs$)) (nClip (Mul carry4! (vstd!arithmetic.power2.pow2.?
                     (I 260)
     ))))))))))))))))
     (=>
      %%global_location_label%%77
      (= sum5! (nClip (Add (nClip (Add (nClip (Add (nClip (Add carry4! (%I (vstd!seq.Seq.index.? $
                 (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%.
                   limbs!
                  )
                 ) (I 5)
              )))
             ) (nClip (Mul n1! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                   $ (UINT 64) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                      curve25519_dalek!backend.serial.u64.constants.L.?
                  ))))
                 ) (I 4)
            )))))
           ) (nClip (Mul n3! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                    curve25519_dalek!backend.serial.u64.constants.L.?
                ))))
               ) (I 2)
          )))))
         ) (nClip (Mul n4! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  curve25519_dalek!backend.serial.u64.constants.L.?
              ))))
             ) (I 1)
     ))))))))
     (=>
      %%global_location_label%%78
      (= sum6! (nClip (Add (nClip (Add (nClip (Add carry5! (%I (vstd!seq.Seq.index.? $ (UINT 128)
               (vstd!view.View.view.? $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%. limbs!))
               (I 6)
            )))
           ) (nClip (Mul n2! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                    curve25519_dalek!backend.serial.u64.constants.L.?
                ))))
               ) (I 4)
          )))))
         ) (nClip (Mul n4! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  curve25519_dalek!backend.serial.u64.constants.L.?
              ))))
             ) (I 2)
     ))))))))
     (=>
      %%global_location_label%%79
      (= sum7! (nClip (Add (nClip (Add carry6! (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.?
              $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%. limbs!)
             ) (I 7)
          )))
         ) (nClip (Mul n3! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  curve25519_dalek!backend.serial.u64.constants.L.?
              ))))
             ) (I 4)
     ))))))))
     (=>
      %%global_location_label%%80
      (= sum8! (nClip (Add (nClip (Add carry7! (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.?
              $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%. limbs!)
             ) (I 8)
          )))
         ) (nClip (Mul n4! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  curve25519_dalek!backend.serial.u64.constants.L.?
              ))))
             ) (I 4)
     ))))))))
     (=>
      %%global_location_label%%81
      (= sum5! (nClip (Add r0! (nClip (Mul carry5! (vstd!arithmetic.power2.pow2.? (I 52)))))))
     )
     (=>
      %%global_location_label%%82
      (= sum6! (nClip (Add r1! (nClip (Mul carry6! (vstd!arithmetic.power2.pow2.? (I 52)))))))
     )
     (=>
      %%global_location_label%%83
      (= sum7! (nClip (Add r2! (nClip (Mul carry7! (vstd!arithmetic.power2.pow2.? (I 52)))))))
     )
     (=>
      %%global_location_label%%84
      (= sum8! (nClip (Add r3! (nClip (Mul r4! (vstd!arithmetic.power2.pow2.? (I 52)))))))
     )
     (=>
      %%global_location_label%%85
      (< r0! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%86
      (< r1! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%87
      (< r2! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%88
      (< r3! (vstd!arithmetic.power2.pow2.? (I 52)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part2_chain_lemmas.lemma_part2_chain_quotient.
     limbs! n0! n1! n2! n3! n4! carry4! sum5! sum6! sum7! sum8! carry5! carry6! carry7!
     r0! r1! r2! r3! r4!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part2_chain_lemmas.lemma_part2_chain_quotient._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part2_chain_lemmas.lemma_part2_chain_quotient._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part2_chain_lemmas.lemma_part2_chain_quotient.
 (%%Function%% Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int
  Int
 ) Bool
)
(assert
 (forall ((limbs! %%Function%%) (n0! Int) (n1! Int) (n2! Int) (n3! Int) (n4! Int) (carry4!
    Int
   ) (sum5! Int) (sum6! Int) (sum7! Int) (sum8! Int) (carry5! Int) (carry6! Int) (carry7!
    Int
   ) (r0! Int) (r1! Int) (r2! Int) (r3! Int) (r4! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part2_chain_lemmas.lemma_part2_chain_quotient.
     limbs! n0! n1! n2! n3! n4! carry4! sum5! sum6! sum7! sum8! carry5! carry6! carry7!
     r0! r1! r2! r3! r4!
    ) (let
     ((n$ (curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.? (I n0!) (I n1!)
        (I n2!) (I n3!) (I n4!)
     )))
     (let
      ((t$ (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (vstd!array.spec_array_as_slice.?
          $ (UINT 128) $ (CONST_INT 9) (Poly%array%. limbs!)
      ))))
      (let
       ((l$ (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))))
       (let
        ((intermediate$ (curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.? (I r0!)
           (I r1!) (I r2!) (I r3!) (I r4!)
        )))
        (= (nClip (Add (nClip (Mul intermediate$ (vstd!arithmetic.power2.pow2.? (I 260)))) 0))
         (nClip (Add t$ (nClip (Mul n$ l$))))
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part2_chain_lemmas.lemma_part2_chain_quotient.
     limbs! n0! n1! n2! n3! n4! carry4! sum5! sum6! sum7! sum8! carry5! carry6! carry7!
     r0! r1! r2! r3! r4!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part2_chain_lemmas.lemma_part2_chain_quotient._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_part2_chain_lemmas.lemma_part2_chain_quotient._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_montgomery_reduce_pre_sub
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_pre_sub.
 (%%Function%% Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int
  Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) Bool
)
(declare-const %%global_location_label%%89 Bool)
(declare-const %%global_location_label%%90 Bool)
(declare-const %%global_location_label%%91 Bool)
(declare-const %%global_location_label%%92 Bool)
(declare-const %%global_location_label%%93 Bool)
(declare-const %%global_location_label%%94 Bool)
(declare-const %%global_location_label%%95 Bool)
(declare-const %%global_location_label%%96 Bool)
(declare-const %%global_location_label%%97 Bool)
(declare-const %%global_location_label%%98 Bool)
(declare-const %%global_location_label%%99 Bool)
(declare-const %%global_location_label%%100 Bool)
(declare-const %%global_location_label%%101 Bool)
(declare-const %%global_location_label%%102 Bool)
(declare-const %%global_location_label%%103 Bool)
(declare-const %%global_location_label%%104 Bool)
(declare-const %%global_location_label%%105 Bool)
(declare-const %%global_location_label%%106 Bool)
(declare-const %%global_location_label%%107 Bool)
(declare-const %%global_location_label%%108 Bool)
(declare-const %%global_location_label%%109 Bool)
(declare-const %%global_location_label%%110 Bool)
(declare-const %%global_location_label%%111 Bool)
(declare-const %%global_location_label%%112 Bool)
(declare-const %%global_location_label%%113 Bool)
(declare-const %%global_location_label%%114 Bool)
(assert
 (forall ((limbs! %%Function%%) (n0! Int) (n1! Int) (n2! Int) (n3! Int) (n4! Int) (n!
    Int
   ) (carry4! Int) (sum5! Int) (sum6! Int) (sum7! Int) (sum8! Int) (carry5! Int) (carry6!
    Int
   ) (carry7! Int) (r0! Int) (r1! Int) (r2! Int) (r3! Int) (r4! Int) (intermediate! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_pre_sub.
     limbs! n0! n1! n2! n3! n4! n! carry4! sum5! sum6! sum7! sum8! carry5! carry6! carry7!
     r0! r1! r2! r3! r4! intermediate!
    ) (and
     (=>
      %%global_location_label%%89
      (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.? (
        Poly%array%. limbs!
     )))
     (=>
      %%global_location_label%%90
      (< n0! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%91
      (< n1! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%92
      (< n2! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%93
      (< n3! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%94
      (< n4! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%95
      (= n! (curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.? (I n0!) (I n1!)
        (I n2!) (I n3!) (I n4!)
     )))
     (=>
      %%global_location_label%%96
      (let
       ((n$ (curve25519_dalek!specs.scalar52_specs.five_u64_limbs_to_nat.? (I n0!) (I n1!)
          (I n2!) (I n3!) (I n4!)
       )))
       (let
        ((t_low$ (nClip (Add (nClip (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 128)
                    (vstd!view.View.view.? $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%. limbs!))
                    (I 0)
                   )
                  ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                        (UINT 128) $ (CONST_INT 9)
                       ) (Poly%array%. limbs!)
                      ) (I 1)
                     )
                    ) (vstd!arithmetic.power2.pow2.? (I 52))
                 )))
                ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                      (UINT 128) $ (CONST_INT 9)
                     ) (Poly%array%. limbs!)
                    ) (I 2)
                   )
                  ) (vstd!arithmetic.power2.pow2.? (I 104))
               )))
              ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                    (UINT 128) $ (CONST_INT 9)
                   ) (Poly%array%. limbs!)
                  ) (I 3)
                 )
                ) (vstd!arithmetic.power2.pow2.? (I 156))
             )))
            ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                  (UINT 128) $ (CONST_INT 9)
                 ) (Poly%array%. limbs!)
                ) (I 4)
               )
              ) (vstd!arithmetic.power2.pow2.? (I 208))
        ))))))
        (let
         ((l_low$ (nClip (Add (nClip (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 64)
                     (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                        (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                          curve25519_dalek!backend.serial.u64.constants.L.?
                      ))))
                     ) (I 0)
                    )
                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                          UINT 64
                         ) $ (CONST_INT 5)
                        ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                          (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                            curve25519_dalek!backend.serial.u64.constants.L.?
                        ))))
                       ) (I 1)
                      )
                     ) (vstd!arithmetic.power2.pow2.? (I 52))
                  )))
                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                        UINT 64
                       ) $ (CONST_INT 5)
                      ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                        (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                          curve25519_dalek!backend.serial.u64.constants.L.?
                      ))))
                     ) (I 2)
                    )
                   ) (vstd!arithmetic.power2.pow2.? (I 104))
                )))
               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                      UINT 64
                     ) $ (CONST_INT 5)
                    ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                      (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                        curve25519_dalek!backend.serial.u64.constants.L.?
                    ))))
                   ) (I 3)
                  )
                 ) (vstd!arithmetic.power2.pow2.? (I 156))
              )))
             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                    UINT 64
                   ) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                      curve25519_dalek!backend.serial.u64.constants.L.?
                  ))))
                 ) (I 4)
                )
               ) (vstd!arithmetic.power2.pow2.? (I 208))
         ))))))
         (= (EucMod (nClip (Add t_low$ (nClip (Mul n$ l_low$)))) (vstd!arithmetic.power2.pow2.?
            (I 260)
           )
          ) 0
     )))))
     (=>
      %%global_location_label%%97
      (let
       ((t_low$ (nClip (Add (nClip (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.? $ (UINT 128)
                   (vstd!view.View.view.? $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%. limbs!))
                   (I 0)
                  )
                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                       (UINT 128) $ (CONST_INT 9)
                      ) (Poly%array%. limbs!)
                     ) (I 1)
                    )
                   ) (vstd!arithmetic.power2.pow2.? (I 52))
                )))
               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                     (UINT 128) $ (CONST_INT 9)
                    ) (Poly%array%. limbs!)
                   ) (I 2)
                  )
                 ) (vstd!arithmetic.power2.pow2.? (I 104))
              )))
             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                   (UINT 128) $ (CONST_INT 9)
                  ) (Poly%array%. limbs!)
                 ) (I 3)
                )
               ) (vstd!arithmetic.power2.pow2.? (I 156))
            )))
           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                 (UINT 128) $ (CONST_INT 9)
                ) (Poly%array%. limbs!)
               ) (I 4)
              )
             ) (vstd!arithmetic.power2.pow2.? (I 208))
       ))))))
       (let
        ((l0_val$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
               64
              ) $ (CONST_INT 5)
             ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
               (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                 curve25519_dalek!backend.serial.u64.constants.L.?
             ))))
            ) (I 0)
        ))))
        (let
         ((l1$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  curve25519_dalek!backend.serial.u64.constants.L.?
              ))))
             ) (I 1)
         ))))
         (let
          ((l2$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                   curve25519_dalek!backend.serial.u64.constants.L.?
               ))))
              ) (I 2)
          ))))
          (let
           ((l4$ (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                 $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                    curve25519_dalek!backend.serial.u64.constants.L.?
                ))))
               ) (I 4)
           ))))
           (let
            ((coeff0$ (nClip (Mul n0! l0_val$))))
            (let
             ((coeff1$ (nClip (Add (nClip (Mul n0! l1$)) (nClip (Mul n1! l0_val$))))))
             (let
              ((coeff2$ (nClip (Add (nClip (Add (nClip (Mul n0! l2$)) (nClip (Mul n1! l1$)))) (nClip
                   (Mul n2! l0_val$)
              )))))
              (let
               ((coeff3$ (nClip (Add (nClip (Add (nClip (Mul n1! l2$)) (nClip (Mul n2! l1$)))) (nClip
                    (Mul n3! l0_val$)
               )))))
               (let
                ((coeff4$ (nClip (Add (nClip (Add (nClip (Add (nClip (Mul n0! l4$)) (nClip (Mul n2! l2$))))
                      (nClip (Mul n3! l1$))
                     )
                    ) (nClip (Mul n4! l0_val$))
                ))))
                (let
                 ((nl_low_coeffs$ (nClip (Add (nClip (Add (nClip (Add (nClip (Add coeff0$ (nClip (Mul coeff1$
                             (vstd!arithmetic.power2.pow2.? (I 52))
                          )))
                         ) (nClip (Mul coeff2$ (vstd!arithmetic.power2.pow2.? (I 104))))
                        )
                       ) (nClip (Mul coeff3$ (vstd!arithmetic.power2.pow2.? (I 156))))
                      )
                     ) (nClip (Mul coeff4$ (vstd!arithmetic.power2.pow2.? (I 208))))
                 ))))
                 (= (nClip (Add t_low$ nl_low_coeffs$)) (nClip (Mul carry4! (vstd!arithmetic.power2.pow2.?
                     (I 260)
     ))))))))))))))))
     (=>
      %%global_location_label%%98
      (= sum5! (nClip (Add (nClip (Add (nClip (Add (nClip (Add carry4! (%I (vstd!seq.Seq.index.? $
                 (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%.
                   limbs!
                  )
                 ) (I 5)
              )))
             ) (nClip (Mul n1! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                   $ (UINT 64) $ (CONST_INT 5)
                  ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                    (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                      curve25519_dalek!backend.serial.u64.constants.L.?
                  ))))
                 ) (I 4)
            )))))
           ) (nClip (Mul n3! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                    curve25519_dalek!backend.serial.u64.constants.L.?
                ))))
               ) (I 2)
          )))))
         ) (nClip (Mul n4! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  curve25519_dalek!backend.serial.u64.constants.L.?
              ))))
             ) (I 1)
     ))))))))
     (=>
      %%global_location_label%%99
      (= sum6! (nClip (Add (nClip (Add (nClip (Add carry5! (%I (vstd!seq.Seq.index.? $ (UINT 128)
               (vstd!view.View.view.? $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%. limbs!))
               (I 6)
            )))
           ) (nClip (Mul n2! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
                 $ (UINT 64) $ (CONST_INT 5)
                ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                  (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                    curve25519_dalek!backend.serial.u64.constants.L.?
                ))))
               ) (I 4)
          )))))
         ) (nClip (Mul n4! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  curve25519_dalek!backend.serial.u64.constants.L.?
              ))))
             ) (I 2)
     ))))))))
     (=>
      %%global_location_label%%100
      (= sum7! (nClip (Add (nClip (Add carry6! (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.?
              $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%. limbs!)
             ) (I 7)
          )))
         ) (nClip (Mul n3! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  curve25519_dalek!backend.serial.u64.constants.L.?
              ))))
             ) (I 4)
     ))))))))
     (=>
      %%global_location_label%%101
      (= sum8! (nClip (Add (nClip (Add carry7! (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.?
              $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) (Poly%array%. limbs!)
             ) (I 8)
          )))
         ) (nClip (Mul n4! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  curve25519_dalek!backend.serial.u64.constants.L.?
              ))))
             ) (I 4)
     ))))))))
     (=>
      %%global_location_label%%102
      (= sum5! (nClip (Add r0! (nClip (Mul carry5! (vstd!arithmetic.power2.pow2.? (I 52)))))))
     )
     (=>
      %%global_location_label%%103
      (= sum6! (nClip (Add r1! (nClip (Mul carry6! (vstd!arithmetic.power2.pow2.? (I 52)))))))
     )
     (=>
      %%global_location_label%%104
      (= sum7! (nClip (Add r2! (nClip (Mul carry7! (vstd!arithmetic.power2.pow2.? (I 52)))))))
     )
     (=>
      %%global_location_label%%105
      (= sum8! (nClip (Add r3! (nClip (Mul r4! (vstd!arithmetic.power2.pow2.? (I 52)))))))
     )
     (=>
      %%global_location_label%%106
      (< r0! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%107
      (< r1! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%108
      (< r2! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%109
      (< r3! (vstd!arithmetic.power2.pow2.? (I 52)))
     )
     (=>
      %%global_location_label%%110
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              intermediate!
          ))))
         ) (I 0)
        )
       ) r0!
     ))
     (=>
      %%global_location_label%%111
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              intermediate!
          ))))
         ) (I 1)
        )
       ) r1!
     ))
     (=>
      %%global_location_label%%112
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              intermediate!
          ))))
         ) (I 2)
        )
       ) r2!
     ))
     (=>
      %%global_location_label%%113
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              intermediate!
          ))))
         ) (I 3)
        )
       ) r3!
     ))
     (=>
      %%global_location_label%%114
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              intermediate!
          ))))
         ) (I 4)
        )
       ) r4!
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_pre_sub.
     limbs! n0! n1! n2! n3! n4! n! carry4! sum5! sum6! sum7! sum8! carry5! carry6! carry7!
     r0! r1! r2! r3! r4! intermediate!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_pre_sub._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_pre_sub._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_pre_sub.
 (%%Function%% Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int Int
  Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) Bool
)
(assert
 (forall ((limbs! %%Function%%) (n0! Int) (n1! Int) (n2! Int) (n3! Int) (n4! Int) (n!
    Int
   ) (carry4! Int) (sum5! Int) (sum6! Int) (sum7! Int) (sum8! Int) (carry5! Int) (carry6!
    Int
   ) (carry7! Int) (r0! Int) (r1! Int) (r2! Int) (r3! Int) (r4! Int) (intermediate! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_pre_sub.
     limbs! n0! n1! n2! n3! n4! n! carry4! sum5! sum6! sum7! sum8! carry5! carry6! carry7!
     r0! r1! r2! r3! r4! intermediate!
    ) (= (nClip (Mul (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         intermediate!
        )
       ) (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0))
      )
     ) (nClip (Add (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (vstd!array.spec_array_as_slice.?
         $ (UINT 128) $ (CONST_INT 9) (Poly%array%. limbs!)
        )
       ) (nClip (Mul n! (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_pre_sub.
     limbs! n0! n1! n2! n3! n4! n! carry4! sum5! sum6! sum7! sum8! carry5! carry6! carry7!
     r0! r1! r2! r3! r4! intermediate!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_pre_sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_pre_sub._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_div_strictly_bounded
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%115 Bool)
(declare-const %%global_location_label%%116 Bool)
(declare-const %%global_location_label%%117 Bool)
(assert
 (forall ((x! Int) (a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded.
     x! a! b!
    ) (and
     (=>
      %%global_location_label%%115
      (> a! 0)
     )
     (=>
      %%global_location_label%%116
      (>= b! 0)
     )
     (=>
      %%global_location_label%%117
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
(declare-const %%global_location_label%%118 Bool)
(declare-const %%global_location_label%%119 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_mul_le_implies_div_le.
     a! b! c!
    ) (and
     (=>
      %%global_location_label%%118
      (> b! 0)
     )
     (=>
      %%global_location_label%%119
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_plus_one
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_plus_one.
 (Int) Bool
)
(assert
 (forall ((n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_plus_one. n!)
    (= (vstd!arithmetic.power2.pow2.? (I (nClip (Add n! 1)))) (nClip (Add (vstd!arithmetic.power2.pow2.?
        (I n!)
       ) (vstd!arithmetic.power2.pow2.? (I n!))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_plus_one.
     n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_plus_one._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_plus_one._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_two_l_div_pow2_208_eq_pow2_45
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_two_l_div_pow2_208_eq_pow2_45.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_two_l_div_pow2_208_eq_pow2_45.
     no%param
    ) (= (EucDiv (nClip (Mul 2 (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))))
      (vstd!arithmetic.power2.pow2.? (I 208))
     ) (vstd!arithmetic.power2.pow2.? (I 45))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_two_l_div_pow2_208_eq_pow2_45.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_two_l_div_pow2_208_eq_pow2_45._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_two_l_div_pow2_208_eq_pow2_45._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_r4_bound_from_canonical
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_r4_bound_from_canonical.
 (%%Function%% Int Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%120 Bool)
(declare-const %%global_location_label%%121 Bool)
(declare-const %%global_location_label%%122 Bool)
(assert
 (forall ((limbs! %%Function%%) (r0! Int) (r1! Int) (r2! Int) (r3! Int) (r4! Int) (n!
    Int
   )
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_r4_bound_from_canonical.
     limbs! r0! r1! r2! r3! r4! n!
    ) (and
     (=>
      %%global_location_label%%120
      (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.?
       (Poly%array%. limbs!)
     ))
     (=>
      %%global_location_label%%121
      (< n! (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0)))
     )
     (=>
      %%global_location_label%%122
      (let
       ((inter$ (nClip (Add (nClip (Add (nClip (Add (nClip (Add r0! (nClip (Mul r1! (vstd!arithmetic.power2.pow2.?
                    (I 52)
                ))))
               ) (nClip (Mul r2! (vstd!arithmetic.power2.pow2.? (I 104))))
              )
             ) (nClip (Mul r3! (vstd!arithmetic.power2.pow2.? (I 156))))
            )
           ) (nClip (Mul r4! (vstd!arithmetic.power2.pow2.? (I 208))))
       ))))
       (= (nClip (Mul inter$ (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0))))
        (nClip (Add (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (vstd!array.spec_array_as_slice.?
            $ (UINT 128) $ (CONST_INT 9) (Poly%array%. limbs!)
           )
          ) (nClip (Mul n! (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))))
   )))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_r4_bound_from_canonical.
     limbs! r0! r1! r2! r3! r4! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_r4_bound_from_canonical._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_r4_bound_from_canonical._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_r4_bound_from_canonical.
 (%%Function%% Int Int Int Int Int Int) Bool
)
(assert
 (forall ((limbs! %%Function%%) (r0! Int) (r1! Int) (r2! Int) (r3! Int) (r4! Int) (n!
    Int
   )
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_r4_bound_from_canonical.
     limbs! r0! r1! r2! r3! r4! n!
    ) (and
     (< r4! (nClip (Add (vstd!arithmetic.power2.pow2.? (I 52)) (%I (vstd!seq.Seq.index.? $
          (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
            (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.constants.L.?)
           )))
          ) (I 4)
     )))))
     (let
      ((inter$ (nClip (Add (nClip (Add (nClip (Add (nClip (Add r0! (nClip (Mul r1! (vstd!arithmetic.power2.pow2.?
                   (I 52)
               ))))
              ) (nClip (Mul r2! (vstd!arithmetic.power2.pow2.? (I 104))))
             )
            ) (nClip (Mul r3! (vstd!arithmetic.power2.pow2.? (I 156))))
           )
          ) (nClip (Mul r4! (vstd!arithmetic.power2.pow2.? (I 208))))
      ))))
      (< inter$ (nClip (Mul 2 (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)))))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_r4_bound_from_canonical.
     limbs! r0! r1! r2! r3! r4! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_r4_bound_from_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_r4_bound_from_canonical._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_mul_factors_congruent_implies_products_congruent
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%123 Bool)
(declare-const %%global_location_label%%124 Bool)
(assert
 (forall ((c! Int) (a! Int) (b! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent.
     c! a! b! m!
    ) (and
     (=>
      %%global_location_label%%123
      (> m! 0)
     )
     (=>
      %%global_location_label%%124
      (= (EucMod a! m!) (EucMod b! m!))
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent.
     c! a! b! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent.
 (Int Int Int Int) Bool
)
(assert
 (forall ((c! Int) (a! Int) (b! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent.
     c! a! b! m!
    ) (= (EucMod (Mul c! a!) m!) (EucMod (Mul c! b!) m!))
   )
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent.
     c! a! b! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_montgomery_reduce_post_sub
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_post_sub.
 (%%Function%% curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Int
 ) Bool
)
(declare-const %%global_location_label%%125 Bool)
(declare-const %%global_location_label%%126 Bool)
(assert
 (forall ((limbs! %%Function%%) (intermediate! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (result! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (n! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_post_sub.
     limbs! intermediate! result! n!
    ) (and
     (=>
      %%global_location_label%%125
      (= (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         result!
        )
       ) (EucMod (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           intermediate!
          )
         ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
        ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
     )))
     (=>
      %%global_location_label%%126
      (= (nClip (Mul (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           intermediate!
          )
         ) (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0))
        )
       ) (nClip (Add (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (vstd!array.spec_array_as_slice.?
           $ (UINT 128) $ (CONST_INT 9) (Poly%array%. limbs!)
          )
         ) (nClip (Mul n! (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))))
   ))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_post_sub.
     limbs! intermediate! result! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_post_sub._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_post_sub._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_post_sub.
 (%%Function%% curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Int
 ) Bool
)
(assert
 (forall ((limbs! %%Function%%) (intermediate! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (result! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (n! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_post_sub.
     limbs! intermediate! result! n!
    ) (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_congruent.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
      result!
     ) (Poly%array%. limbs!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_post_sub.
     limbs! intermediate! result! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_post_sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_montgomery_reduce_post_sub._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_identity_array_satisfies_input_bounds
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. %%Function%%) Bool
)
(declare-const %%global_location_label%%127 Bool)
(declare-const %%global_location_label%%128 Bool)
(declare-const %%global_location_label%%129 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (limbs! %%Function%%))
  (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds.
     a! limbs!
    ) (and
     (=>
      %%global_location_label%%127
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
     )))
     (=>
      %%global_location_label%%128
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
          (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
               $ (CONST_INT 9)
              ) (Poly%array%. limbs!)
             ) i$
            )
           ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                 UINT 64
                ) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                   a!
               ))))
              ) i$
        ))))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
            $ (CONST_INT 9)
           ) (Poly%array%. limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_input_bounds_110
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_input_bounds_110
     )))
     (=>
      %%global_location_label%%129
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 5 tmp%%$)
            (< tmp%%$ 9)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
               $ (CONST_INT 9)
              ) (Poly%array%. limbs!)
             ) i$
            )
           ) 0
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
            $ (CONST_INT 9)
           ) (Poly%array%. limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_input_bounds_111
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_input_bounds_111
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds.
     a! limbs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. %%Function%%) Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (limbs! %%Function%%))
  (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds.
     a! limbs!
    ) (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_input_bounds.?
     (Poly%array%. limbs!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds.
     a! limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_from_montgomery_limbs_conversion
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion.
 (%%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%130 Bool)
(declare-const %%global_location_label%%131 Bool)
(assert
 (forall ((limbs! %%Function%%) (self_limbs! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion.
     limbs! self_limbs!
    ) (and
     (=>
      %%global_location_label%%130
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ 5)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
               $ (CONST_INT 9)
              ) (Poly%array%. limbs!)
             ) j$
            )
           ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                 UINT 64
                ) $ (CONST_INT 5)
               ) (Poly%array%. self_limbs!)
              ) j$
        ))))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
            $ (CONST_INT 9)
           ) (Poly%array%. limbs!)
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_from_montgomery_limbs_conversion_115
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_from_montgomery_limbs_conversion_115
     )))
     (=>
      %%global_location_label%%131
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 5 tmp%%$)
            (< tmp%%$ 9)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
               $ (CONST_INT 9)
              ) (Poly%array%. limbs!)
             ) j$
            )
           ) 0
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
            $ (CONST_INT 9)
           ) (Poly%array%. limbs!)
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_from_montgomery_limbs_conversion_116
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_from_montgomery_limbs_conversion_116
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion.
     limbs! self_limbs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion.
 (%%Function%% %%Function%%) Bool
)
(assert
 (forall ((limbs! %%Function%%) (self_limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion.
     limbs! self_limbs!
    ) (= (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (vstd!array.spec_array_as_slice.?
       $ (UINT 128) $ (CONST_INT 9) (Poly%array%. limbs!)
      )
     ) (curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.? (vstd!array.spec_array_as_slice.?
       $ (UINT 64) $ (CONST_INT 5) (Poly%array%. self_limbs!)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion.
     limbs! self_limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_identity_array_satisfies_canonical_bound
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_canonical_bound.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. %%Function%%) Bool
)
(declare-const %%global_location_label%%132 Bool)
(declare-const %%global_location_label%%133 Bool)
(declare-const %%global_location_label%%134 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (limbs! %%Function%%))
  (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_canonical_bound.
     a! limbs!
    ) (and
     (=>
      %%global_location_label%%132
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
     )))
     (=>
      %%global_location_label%%133
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
          (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
               $ (CONST_INT 9)
              ) (Poly%array%. limbs!)
             ) i$
            )
           ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
                 UINT 64
                ) $ (CONST_INT 5)
               ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                 (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                   a!
               ))))
              ) i$
        ))))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
            $ (CONST_INT 9)
           ) (Poly%array%. limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_canonical_bound_117
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_canonical_bound_117
     )))
     (=>
      %%global_location_label%%134
      (forall ((i$ Poly)) (!
        (=>
         (has_type i$ INT)
         (=>
          (let
           ((tmp%%$ (%I i$)))
           (and
            (<= 5 tmp%%$)
            (< tmp%%$ 9)
          ))
          (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
               $ (CONST_INT 9)
              ) (Poly%array%. limbs!)
             ) i$
            )
           ) 0
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
            $ (CONST_INT 9)
           ) (Poly%array%. limbs!)
          ) i$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_canonical_bound_118
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_canonical_bound_118
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_canonical_bound.
     a! limbs!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_canonical_bound._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_canonical_bound._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_canonical_bound.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. %%Function%%) Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (limbs! %%Function%%))
  (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_canonical_bound.
     a! limbs!
    ) (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.?
     (Poly%array%. limbs!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_canonical_bound.
     a! limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_canonical_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_canonical_bound._definition
)))

;; Function-Def curve25519_dalek::lemmas::scalar_lemmas_::montgomery_reduce_lemmas::lemma_identity_array_satisfies_canonical_bound
;; curve25519-dalek/src/lemmas/scalar_lemmas_/montgomery_reduce_lemmas.rs:705:1: 705:100 (#0)
(get-info :all-statistics)
(push)
 (declare-const a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 (declare-const limbs! %%Function%%)
 (declare-const tmp%1 %%Function%%)
 (declare-const tmp%2 Bool)
 (declare-const tmp%3 Bool)
 (declare-const tmp%4 Bool)
 (declare-const tmp%5 Bool)
 (declare-const tmp%6 Int)
 (declare-const tmp%7 Int)
 (declare-const tmp%8 Int)
 (declare-const tmp%9 Bool)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!) TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 )
 (assert
  (has_type (Poly%array%. limbs!) (ARRAY $ (UINT 128) $ (CONST_INT 9)))
 )
 (assert
  (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
    a!
 )))
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
      (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) (Poly%array%. limbs!)
         ) i$
        )
       ) (uClip 128 (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (
             UINT 64
            ) $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               a!
           ))))
          ) i$
    ))))))
    :pattern ((vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
        $ (CONST_INT 9)
       ) (Poly%array%. limbs!)
      ) i$
    ))
    :qid user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_canonical_bound_121
    :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_canonical_bound_121
 )))
 (assert
  (forall ((i$ Poly)) (!
    (=>
     (has_type i$ INT)
     (=>
      (let
       ((tmp%%$ (%I i$)))
       (and
        (<= 5 tmp%%$)
        (< tmp%%$ 9)
      ))
      (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) (Poly%array%. limbs!)
         ) i$
        )
       ) 0
    )))
    :pattern ((vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
        $ (CONST_INT 9)
       ) (Poly%array%. limbs!)
      ) i$
    ))
    :qid user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_canonical_bound_122
    :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas___montgomery_reduce_lemmas__lemma_identity_array_satisfies_canonical_bound_122
 )))
 ;; precondition not satisfied
 (declare-const %%location_label%%0 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%1 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%2 Bool)
 ;; assertion failed
 (declare-const %%location_label%%3 Bool)
 ;; assertion failed
 (declare-const %%location_label%%4 Bool)
 ;; assertion failed
 (declare-const %%location_label%%5 Bool)
 ;; assertion failed
 (declare-const %%location_label%%6 Bool)
 ;; assertion failed
 (declare-const %%location_label%%7 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%8 Bool)
 ;; assertion failed
 (declare-const %%location_label%%9 Bool)
 ;; assertion failed
 (declare-const %%location_label%%10 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%11 Bool)
 (assert
  (not (and
    (=>
     %%location_label%%0
     (req%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds.
      a! limbs!
    ))
    (=>
     (ens%curve25519_dalek!lemmas.scalar_lemmas_.montgomery_reduce_lemmas.lemma_identity_array_satisfies_input_bounds.
      a! limbs!
     )
     (=>
      (= tmp%1 (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
      )))
      (and
       (=>
        %%location_label%%1
        (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion.
         limbs! tmp%1
       ))
       (=>
        (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_from_montgomery_limbs_conversion.
         limbs! tmp%1
        )
        (and
         (=>
          %%location_label%%2
          (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. a!)
         )
         (=>
          (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. a!)
          (=>
           (= tmp%2 (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               a!
              )
             ) (vstd!arithmetic.power2.pow2.? (I 260))
           ))
           (and
            (=>
             %%location_label%%3
             tmp%2
            )
            (=>
             tmp%2
             (=>
              (= tmp%3 (= (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0)) (vstd!arithmetic.power2.pow2.?
                 (I 260)
              )))
              (and
               (=>
                %%location_label%%4
                tmp%3
               )
               (=>
                tmp%3
                (and
                 (=>
                  (= tmp%4 (= (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)) (nClip (Add (
                       vstd!arithmetic.power2.pow2.? (I 252)
                      ) 27742317777372353535851937790883648493
                  ))))
                  (and
                   (=>
                    %%location_label%%5
                    tmp%4
                   )
                   (=>
                    tmp%4
                    (=>
                     (ens%vstd!arithmetic.power2.lemma_pow2_pos. 252)
                     (=>
                      %%location_label%%6
                      (> (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)) 1)
                 )))))
                 (=>
                  (> (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)) 1)
                  (and
                   (=>
                    (= tmp%5 (> (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)) 1))
                    (and
                     (=>
                      %%location_label%%7
                      tmp%5
                     )
                     (=>
                      tmp%5
                      (=>
                       (= tmp%6 (vstd!arithmetic.power2.pow2.? (I 260)))
                       (=>
                        (ens%vstd!arithmetic.mul.lemma_mul_basics. tmp%6)
                        (=>
                         (= tmp%7 (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)))
                         (=>
                          (= tmp%8 (vstd!arithmetic.power2.pow2.? (I 260)))
                          (and
                           (=>
                            %%location_label%%8
                            (req%vstd!arithmetic.mul.lemma_mul_strict_inequality. 1 tmp%7 tmp%8)
                           )
                           (=>
                            (ens%vstd!arithmetic.mul.lemma_mul_strict_inequality. 1 tmp%7 tmp%8)
                            (=>
                             %%location_label%%9
                             (> (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 260)) (curve25519_dalek!specs.scalar52_specs.group_order.?
                                 (I 0)
                               ))
                              ) (vstd!arithmetic.power2.pow2.? (I 260))
                   )))))))))))
                   (=>
                    (> (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 260)) (curve25519_dalek!specs.scalar52_specs.group_order.?
                        (I 0)
                      ))
                     ) (vstd!arithmetic.power2.pow2.? (I 260))
                    )
                    (=>
                     (= tmp%9 (< (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (vstd!array.spec_array_as_slice.?
                         $ (UINT 128) $ (CONST_INT 9) (Poly%array%. limbs!)
                        )
                       ) (nClip (Mul (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0)) (curve25519_dalek!specs.scalar52_specs.group_order.?
                          (I 0)
                     )))))
                     (and
                      (=>
                       %%location_label%%10
                       tmp%9
                      )
                      (=>
                       tmp%9
                       (=>
                        %%location_label%%11
                        (curve25519_dalek!specs.montgomery_reduce_specs.montgomery_reduce_canonical_bound.?
                         (Poly%array%. limbs!)
 ))))))))))))))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
