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

;; MODULE 'module lemmas::scalar_lemmas'
;; curve25519-dalek/src/lemmas/scalar_lemmas.rs:2065:1: 2071:2 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.
 FuelId
)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_self_0. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod.
 FuelId
)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_basics_1. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_basics_3. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_associative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_inequality. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_strict_inequality_converse. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_unary_negation. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow1. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_positive. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_adds. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_multiplies. FuelId)
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
(declare-const fuel%vstd!bits.lemma_u64_shr_is_div. FuelId)
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
(declare-const fuel%vstd!view.impl&%24.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%vstd!view.impl&%32.view. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.L. FuelId)
(declare-const fuel%curve25519_dalek!backend.serial.u64.constants.RR. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.slice128_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limbs52_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_nat. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.group_order. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.montgomery_radix. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub. FuelId)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.
 FuelId
)
(declare-const fuel%curve25519_dalek!specs.scalar52_specs.spec_mul_internal. FuelId)
(declare-const fuel%vstd!arithmetic.mul.group_mul_is_distributive. FuelId)
(declare-const fuel%vstd!arithmetic.mul.group_mul_is_commutative_and_distributive.
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
  fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. fuel%vstd!arithmetic.div_mod.lemma_mod_self_0.
  fuel%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish.
  fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop. fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod.
  fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right.
  fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop. fuel%vstd!arithmetic.mul.lemma_mul_basics_1.
  fuel%vstd!arithmetic.mul.lemma_mul_basics_3. fuel%vstd!arithmetic.mul.lemma_mul_is_associative.
  fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. fuel%vstd!arithmetic.mul.lemma_mul_inequality.
  fuel%vstd!arithmetic.mul.lemma_mul_strict_inequality_converse. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way. fuel%vstd!arithmetic.mul.lemma_mul_unary_negation.
  fuel%vstd!arithmetic.power.lemma_pow1. fuel%vstd!arithmetic.power.lemma_pow_positive.
  fuel%vstd!arithmetic.power.lemma_pow_adds. fuel%vstd!arithmetic.power.lemma_pow_multiplies.
  fuel%vstd!arithmetic.power2.lemma_pow2_pos. fuel%vstd!arithmetic.power2.lemma_pow2_unfold.
  fuel%vstd!arithmetic.power2.lemma_pow2_adds. fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases.
  fuel%vstd!array.array_view. fuel%vstd!array.impl&%0.view. fuel%vstd!array.impl&%2.spec_index.
  fuel%vstd!array.lemma_array_index. fuel%vstd!array.array_len_matches_n. fuel%vstd!array.axiom_spec_array_as_slice.
  fuel%vstd!array.axiom_array_ext_equal. fuel%vstd!array.axiom_array_has_resolved.
  fuel%vstd!bits.lemma_u64_shr_is_div. fuel%vstd!bits.low_bits_mask. fuel%vstd!bits.lemma_u64_low_bits_mask_is_mod.
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
  fuel%vstd!view.impl&%24.view. fuel%vstd!view.impl&%26.view. fuel%vstd!view.impl&%32.view.
  fuel%curve25519_dalek!backend.serial.u64.constants.L. fuel%curve25519_dalek!backend.serial.u64.constants.RR.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd. fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_extended_gcd.
  fuel%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
  fuel%curve25519_dalek!specs.core_specs.u8_32_as_nat. fuel%curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.
  fuel%curve25519_dalek!specs.scalar52_specs.slice128_as_nat. fuel%curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.
  fuel%curve25519_dalek!specs.scalar52_specs.limbs52_as_nat. fuel%curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.
  fuel%curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux. fuel%curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.
  fuel%curve25519_dalek!specs.scalar52_specs.group_order. fuel%curve25519_dalek!specs.scalar52_specs.montgomery_radix.
  fuel%curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix. fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded.
  fuel%curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub. fuel%curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.
  fuel%curve25519_dalek!specs.scalar52_specs.spec_mul_internal. fuel%vstd!arithmetic.mul.group_mul_is_distributive.
  fuel%vstd!arithmetic.mul.group_mul_is_commutative_and_distributive. fuel%vstd!array.group_array_axioms.
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
  (fuel_bool_default fuel%vstd!arithmetic.mul.group_mul_is_distributive.)
  (and
   (fuel_bool_default fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add.)
   (fuel_bool_default fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way.)
   (fuel_bool_default fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub.)
   (fuel_bool_default fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub_other_way.)
)))
(assert
 (=>
  (fuel_bool_default fuel%vstd!arithmetic.mul.group_mul_is_commutative_and_distributive.)
  (and
   (fuel_bool_default fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.)
   (fuel_bool_default fuel%vstd!arithmetic.mul.group_mul_is_distributive.)
)))
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
  ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult. 0) (tuple%0.
   0
  )
 ) (((vstd!raw_ptr.PtrData./PtrData (vstd!raw_ptr.PtrData./PtrData/?addr Int) (vstd!raw_ptr.PtrData./PtrData/?provenance
     vstd!raw_ptr.Provenance.
    ) (vstd!raw_ptr.PtrData./PtrData/?metadata Poly)
   )
  ) ((curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52 (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/?limbs
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
  ) ((tuple%0./tuple%0))
))
(declare-fun vstd!raw_ptr.PtrData./PtrData/addr (vstd!raw_ptr.PtrData.) Int)
(declare-fun vstd!raw_ptr.PtrData./PtrData/provenance (vstd!raw_ptr.PtrData.) vstd!raw_ptr.Provenance.)
(declare-fun vstd!raw_ptr.PtrData./PtrData/metadata (vstd!raw_ptr.PtrData.) Poly)
(declare-fun curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (
  curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) %%Function%%
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
(declare-fun TYPE%fun%1. (Dcr Type Dcr Type) Type)
(declare-fun TYPE%fun%2. (Dcr Type Dcr Type Dcr Type) Type)
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-const TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52. Type)
(declare-const TYPE%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 Type
)
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
(declare-fun Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.) Poly
)
(declare-fun %Poly%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
 (Poly) curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.ExtGcdResult.
)
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

;; Function-Decl vstd::arithmetic::power::pow
(declare-fun vstd!arithmetic.power.pow.? (Poly Poly) Int)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl vstd::bits::low_bits_mask
(declare-fun vstd!bits.low_bits_mask.? (Poly) Int)

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

;; Function-Decl curve25519_dalek::specs::core_specs::u8_32_as_nat
(declare-fun curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly) Int)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::group_order
(declare-fun curve25519_dalek!specs.scalar52_specs.group_order.? (Poly) Int)

;; Function-Decl vstd::std_specs::num::u64_specs::wrapping_sub%returns_clause_autospec
(declare-fun vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.? (
  Poly Poly
 ) Int
)

;; Function-Decl vstd::seq_lib::impl&%0::map
(declare-fun vstd!seq_lib.impl&%0.map.? (Dcr Type Dcr Type Poly Poly) Poly)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::L
(declare-fun curve25519_dalek!backend.serial.u64.constants.L.? () curve25519_dalek!backend.serial.u64.scalar.Scalar52.)

;; Function-Decl curve25519_dalek::backend::serial::u64::constants::RR
(declare-fun curve25519_dalek!backend.serial.u64.constants.RR.? () curve25519_dalek!backend.serial.u64.scalar.Scalar52.)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::montgomery_radix
(declare-fun curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (Poly) Int)

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

;; Function-Decl curve25519_dalek::specs::scalar52_specs::nine_limbs_to_nat_aux
(declare-fun curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::five_limbs_to_nat_aux
(declare-fun curve25519_dalek!specs.scalar52_specs.five_limbs_to_nat_aux.? (Poly)
 Int
)

;; Function-Decl curve25519_dalek::specs::scalar52_specs::inv_montgomery_radix
(declare-fun curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.? (Poly) Int)

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

;; Function-Decl curve25519_dalek::specs::scalar52_specs::spec_mul_internal
(declare-fun curve25519_dalek!specs.scalar52_specs.spec_mul_internal.? (Poly Poly)
 %%Function%%
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

;; Function-Specs vstd::arithmetic::div_mod::lemma_small_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(declare-const %%global_location_label%%5 Bool)
(declare-const %%global_location_label%%6 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (and
     (=>
      %%global_location_label%%5
      (< x! m!)
     )
     (=>
      %%global_location_label%%6
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
    :qid user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_27
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_27
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_self_0
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_self_0. (Int) Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_self_0. m!) (=>
     %%global_location_label%%8
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_self_0_28
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_self_0_28
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_add_multiples_vanish
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. (Int Int)
 Bool
)
(declare-const %%global_location_label%%9 Bool)
(assert
 (forall ((b! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. b! m!) (=>
     %%global_location_label%%9
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_add_multiples_vanish_29
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_add_multiples_vanish_29
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_multiples_vanish
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. (Int Int Int)
 Bool
)
(declare-const %%global_location_label%%10 Bool)
(assert
 (forall ((a! Int) (b! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_multiples_vanish. a! b! m!) (=>
     %%global_location_label%%10
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_multiples_vanish_30
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_multiples_vanish_30
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_add_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_add_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!) (=>
     %%global_location_label%%11
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
    :qid user_vstd__arithmetic__div_mod__lemma_add_mod_noop_31
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_add_mod_noop_31
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_fundamental_div_mod_converse_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod. (
  Int Int Int Int
 ) Bool
)
(declare-const %%global_location_label%%12 Bool)
(declare-const %%global_location_label%%13 Bool)
(declare-const %%global_location_label%%14 Bool)
(assert
 (forall ((x! Int) (d! Int) (q! Int) (r! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod_converse_mod. x! d! q! r!)
    (and
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
    :qid user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_converse_mod_32
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_converse_mod_32
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_left
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. (Int Int Int) Bool)
(declare-const %%global_location_label%%15 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_left. x! y! m!) (=>
     %%global_location_label%%15
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_left_33
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_left_33
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_right
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. (Int Int Int) Bool)
(declare-const %%global_location_label%%16 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!) (=>
     %%global_location_label%%16
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_34
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_34
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!) (=>
     %%global_location_label%%17
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_35
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_35
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

;; Function-Specs vstd::arithmetic::mul::lemma_mul_basics_1
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_basics_1. (Int) Bool)
(assert
 (forall ((x! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_basics_1. x!) (= (Mul 0 x!) 0))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_basics_1. x!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_basics_1._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_basics_1._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_basics_1
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_basics_1.)
  (forall ((x! Int)) (!
    (= (Mul 0 x!) 0)
    :pattern ((Mul 0 x!))
    :qid user_vstd__arithmetic__mul__lemma_mul_basics_1_36
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_basics_1_36
))))

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
    :qid user_vstd__arithmetic__mul__lemma_mul_basics_3_37
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_basics_3_37
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_associative_38
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_associative_38
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_39
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_39
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_inequality
(declare-fun req%vstd!arithmetic.mul.lemma_mul_inequality. (Int Int Int) Bool)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_inequality. x! y! z!) (and
     (=>
      %%global_location_label%%18
      (<= x! y!)
     )
     (=>
      %%global_location_label%%19
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
    :qid user_vstd__arithmetic__mul__lemma_mul_inequality_40
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_inequality_40
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_strict_inequality_converse
(declare-fun req%vstd!arithmetic.mul.lemma_mul_strict_inequality_converse. (Int Int
  Int
 ) Bool
)
(declare-const %%global_location_label%%20 Bool)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_strict_inequality_converse. x! y! z!) (and
     (=>
      %%global_location_label%%20
      (< (Mul x! z!) (Mul y! z!))
     )
     (=>
      %%global_location_label%%21
      (>= z! 0)
   )))
   :pattern ((req%vstd!arithmetic.mul.lemma_mul_strict_inequality_converse. x! y! z!))
   :qid internal_req__vstd!arithmetic.mul.lemma_mul_strict_inequality_converse._definition
   :skolemid skolem_internal_req__vstd!arithmetic.mul.lemma_mul_strict_inequality_converse._definition
)))
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_strict_inequality_converse. (Int Int
  Int
 ) Bool
)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_strict_inequality_converse. x! y! z!) (< x! y!))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_strict_inequality_converse. x! y! z!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_strict_inequality_converse._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_strict_inequality_converse._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_strict_inequality_converse
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_strict_inequality_converse.)
  (forall ((x! Int) (y! Int) (z! Int)) (!
    (=>
     (and
      (< (Mul x! z!) (Mul y! z!))
      (>= z! 0)
     )
     (< x! y!)
    )
    :pattern ((Mul x! z!) (Mul y! z!))
    :qid user_vstd__arithmetic__mul__lemma_mul_strict_inequality_converse_41
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_strict_inequality_converse_41
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_44
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_44
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_other_way_45
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_other_way_45
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_unary_negation
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_unary_negation. (Int Int) Bool)
(assert
 (forall ((x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_unary_negation. x! y!) (let
     ((tmp%%$ (Sub 0 (Mul x! y!))))
     (and
      (= (Mul (Sub 0 x!) y!) tmp%%$)
      (= tmp%%$ (Mul x! (Sub 0 y!)))
   )))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_unary_negation. x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_unary_negation._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_unary_negation._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_unary_negation
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_unary_negation.)
  (forall ((x! Int) (y! Int)) (!
    (let
     ((tmp%%$ (Sub 0 (Mul x! y!))))
     (and
      (= (Mul (Sub 0 x!) y!) tmp%%$)
      (= tmp%%$ (Mul x! (Sub 0 y!)))
    ))
    :pattern ((Mul (Sub 0 x!) y!))
    :pattern ((Mul x! (Sub 0 y!)))
    :qid user_vstd__arithmetic__mul__lemma_mul_unary_negation_46
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_unary_negation_46
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
    :qid user_vstd__arithmetic__power__lemma_pow1_47
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow1_47
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow_positive
(declare-fun req%vstd!arithmetic.power.lemma_pow_positive. (Int Int) Bool)
(declare-const %%global_location_label%%22 Bool)
(assert
 (forall ((b! Int) (e! Int)) (!
   (= (req%vstd!arithmetic.power.lemma_pow_positive. b! e!) (=>
     %%global_location_label%%22
     (> b! 0)
   ))
   :pattern ((req%vstd!arithmetic.power.lemma_pow_positive. b! e!))
   :qid internal_req__vstd!arithmetic.power.lemma_pow_positive._definition
   :skolemid skolem_internal_req__vstd!arithmetic.power.lemma_pow_positive._definition
)))
(declare-fun ens%vstd!arithmetic.power.lemma_pow_positive. (Int Int) Bool)
(assert
 (forall ((b! Int) (e! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma_pow_positive. b! e!) (< 0 (vstd!arithmetic.power.pow.?
      (I b!) (I e!)
   )))
   :pattern ((ens%vstd!arithmetic.power.lemma_pow_positive. b! e!))
   :qid internal_ens__vstd!arithmetic.power.lemma_pow_positive._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma_pow_positive._definition
)))

;; Broadcast vstd::arithmetic::power::lemma_pow_positive
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma_pow_positive.)
  (forall ((b! Poly) (e! Poly)) (!
    (=>
     (and
      (has_type b! INT)
      (has_type e! NAT)
     )
     (=>
      (> (%I b!) 0)
      (< 0 (vstd!arithmetic.power.pow.? b! e!))
    ))
    :pattern ((vstd!arithmetic.power.pow.? b! e!))
    :qid user_vstd__arithmetic__power__lemma_pow_positive_48
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_positive_48
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
    :qid user_vstd__arithmetic__power__lemma_pow_adds_49
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_adds_49
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
    :qid user_vstd__arithmetic__power__lemma_pow_multiplies_50
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_multiplies_50
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_pos_51
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_pos_51
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_unfold
(declare-fun req%vstd!arithmetic.power2.lemma_pow2_unfold. (Int) Bool)
(declare-const %%global_location_label%%23 Bool)
(assert
 (forall ((e! Int)) (!
   (= (req%vstd!arithmetic.power2.lemma_pow2_unfold. e!) (=>
     %%global_location_label%%23
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_unfold_52
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_unfold_52
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_adds_53
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_adds_53
))))

;; Function-Specs vstd::arithmetic::power2::lemma_pow2_strictly_increases
(declare-fun req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. (Int Int) Bool)
(declare-const %%global_location_label%%24 Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!) (=>
     %%global_location_label%%24
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
    :qid user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_54
    :skolemid skolem_user_vstd__arithmetic__power2__lemma_pow2_strictly_increases_54
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

;; Function-Specs vstd::bits::lemma_u64_shr_is_div
(declare-fun req%vstd!bits.lemma_u64_shr_is_div. (Int Int) Bool)
(declare-const %%global_location_label%%25 Bool)
(assert
 (forall ((x! Int) (shift! Int)) (!
   (= (req%vstd!bits.lemma_u64_shr_is_div. x! shift!) (=>
     %%global_location_label%%25
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
    :qid user_vstd__bits__lemma_u64_shr_is_div_55
    :skolemid skolem_user_vstd__bits__lemma_u64_shr_is_div_55
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
(declare-const %%global_location_label%%26 Bool)
(assert
 (forall ((x! Int) (n! Int)) (!
   (= (req%vstd!bits.lemma_u64_low_bits_mask_is_mod. x! n!) (=>
     %%global_location_label%%26
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
    :qid user_vstd__bits__lemma_u64_low_bits_mask_is_mod_56
    :skolemid skolem_user_vstd__bits__lemma_u64_low_bits_mask_is_mod_56
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
(declare-const %%global_location_label%%27 Bool)
(declare-const %%global_location_label%%28 Bool)
(assert
 (forall ((a! Poly) (m! Poly)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.
     a! m!
    ) (and
     (=>
      %%global_location_label%%27
      (> (%I m!) 1)
     )
     (=>
      %%global_location_label%%28
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

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::seq_u64_as_nat
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? limbs!) (curve25519_dalek!specs.scalar52_specs.seq_as_nat_52.?
      (vstd!seq_lib.impl&%0.map.? $ (UINT 64) $ NAT limbs! (Poly%fun%2. (mk_fun %%lambda%%2)))
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

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::nine_limbs_to_nat_aux
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.)
  (forall ((limbs! Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.? limbs!) (nClip (Add
       (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (%I (vstd!seq.Seq.index.?
                       $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128) $ (CONST_INT 9)) limbs!)
                       (I 0)
                      )
                     ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                           (UINT 128) $ (CONST_INT 9)
                          ) limbs!
                         ) (I 1)
                        )
                       ) (vstd!arithmetic.power2.pow2.? (I 52))
                    )))
                   ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                         (UINT 128) $ (CONST_INT 9)
                        ) limbs!
                       ) (I 2)
                      )
                     ) (vstd!arithmetic.power2.pow2.? (I 104))
                  )))
                 ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                       (UINT 128) $ (CONST_INT 9)
                      ) limbs!
                     ) (I 3)
                    )
                   ) (vstd!arithmetic.power2.pow2.? (I 156))
                )))
               ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                     (UINT 128) $ (CONST_INT 9)
                    ) limbs!
                   ) (I 4)
                  )
                 ) (vstd!arithmetic.power2.pow2.? (I 208))
              )))
             ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                   (UINT 128) $ (CONST_INT 9)
                  ) limbs!
                 ) (I 5)
                )
               ) (vstd!arithmetic.power2.pow2.? (I 260))
            )))
           ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
                 (UINT 128) $ (CONST_INT 9)
                ) limbs!
               ) (I 6)
              )
             ) (vstd!arithmetic.power2.pow2.? (I 312))
          )))
         ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
               (UINT 128) $ (CONST_INT 9)
              ) limbs!
             ) (I 7)
            )
           ) (vstd!arithmetic.power2.pow2.? (I 364))
        )))
       ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $
             (UINT 128) $ (CONST_INT 9)
            ) limbs!
           ) (I 8)
          )
         ) (vstd!arithmetic.power2.pow2.? (I 416))
    )))))
    :pattern ((curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.? limbs!))
    :qid internal_curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.?_definition
))))
(assert
 (forall ((limbs! Poly)) (!
   (=>
    (has_type limbs! (ARRAY $ (UINT 128) $ (CONST_INT 9)))
    (<= 0 (curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.? limbs!))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.? limbs!))
   :qid internal_curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.?_pre_post_definition
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

;; Function-Axioms curve25519_dalek::specs::scalar52_specs::inv_montgomery_radix
(assert
 (fuel_bool_default fuel%curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.)
)
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.)
  (forall ((no%param Poly)) (!
    (= (curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.? no%param) (nClip (
       Add (nClip (Add (nClip (Add 10269393652460441540 (nClip (Mul (vstd!arithmetic.power2.pow2.?
              (I 64)
             ) 18097319062105074933
          )))
         ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 128)) 3896993926501868395))
        )
       ) (nClip (Mul (vstd!arithmetic.power2.pow2.? (I 192)) 909083665385908504))
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.? no%param))
    :qid internal_curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.?_definition
))))
(assert
 (forall ((no%param Poly)) (!
   (=>
    (has_type no%param INT)
    (<= 0 (curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.? no%param))
   )
   :pattern ((curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.? no%param))
   :qid internal_curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.?_pre_post_definition
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
       :qid user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_57
       :skolemid skolem_user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_57
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
        :qid user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_for_sub_58
        :skolemid skolem_user_curve25519_dalek__specs__scalar52_specs__limbs_bounded_for_sub_58
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
       :qid user_curve25519_dalek__specs__scalar52_specs__limb_prod_bounded_u128_59
       :skolemid skolem_user_curve25519_dalek__specs__scalar52_specs__limb_prod_bounded_u128_59
    )))
    :pattern ((curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.? limbs1! limbs2!
      k!
    ))
    :qid internal_curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.?_definition
    :skolemid skolem_internal_curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.?_definition
))))

;; Function-Specs curve25519_dalek::specs::scalar52_specs::spec_mul_internal
(declare-fun req%curve25519_dalek!specs.scalar52_specs.spec_mul_internal. (Poly Poly)
 Bool
)
(declare-const %%global_location_label%%29 Bool)
(declare-const %%global_location_label%%30 Bool)
(assert
 (forall ((a! Poly) (b! Poly)) (!
   (= (req%curve25519_dalek!specs.scalar52_specs.spec_mul_internal. a! b!) (and
     (=>
      %%global_location_label%%29
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? a!)
     )
     (=>
      %%global_location_label%%30
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::mul_lemmas::lemma_mul_le
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. (Int
  Int Int Int
 ) Bool
)
(declare-const %%global_location_label%%31 Bool)
(declare-const %%global_location_label%%32 Bool)
(assert
 (forall ((a1! Int) (b1! Int) (a2! Int) (b2! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. a1! b1! a2!
     b2!
    ) (and
     (=>
      %%global_location_label%%31
      (<= a1! b1!)
     )
     (=>
      %%global_location_label%%32
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

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_limbs_bounded_implies_prod_bounded
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(declare-const %%global_location_label%%33 Bool)
(assert
 (forall ((s! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (t! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_prod_bounded.
     s! t!
    ) (=>
     %%global_location_label%%33
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

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_rr_limbs_bounded
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_rr_limbs_bounded. (Int)
 Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_rr_limbs_bounded. no%param) (<
     3768881411696287 (uClip 64 (bitshl (I 1) (I 52)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_rr_limbs_bounded. no%param))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_rr_limbs_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_rr_limbs_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_mul_internal_no_overflow
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_no_overflow.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_no_overflow. no%param)
    (and
     (= (Add (uClip 128 (bitshl (I 1) (I 104))) (uClip 128 (bitshl (I 1) (I 104)))) (uClip
       128 (bitshl (I 1) (I 105))
     ))
     (< (Mul 3 (uClip 128 (bitshl (I 1) (I 104)))) (uClip 128 (bitshl (I 1) (I 106))))
     (= (Mul 4 (uClip 128 (bitshl (I 1) (I 104)))) (Mul (uClip 128 (bitshl (I 1) (I 2)))
       (uClip 128 (bitshl (I 1) (I 104)))
     ))
     (= (Mul (uClip 128 (bitshl (I 1) (I 2))) (uClip 128 (bitshl (I 1) (I 104)))) (uClip
       128 (bitshl (I 1) (I 106))
     ))
     (= 8 (uClip 128 (bitshl (I 1) (I 3))))
     (= (Mul (uClip 128 (bitshl (I 1) (I 3))) (uClip 128 (bitshl (I 1) (I 104)))) (uClip
       128 (bitshl (I 1) (I 107))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_no_overflow.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_no_overflow._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_no_overflow._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_nine_limbs_equals_slice128_as_nat
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_nine_limbs_equals_slice128_as_nat.
 (%%Function%%) Bool
)
(assert
 (forall ((limbs! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_nine_limbs_equals_slice128_as_nat.
     limbs!
    ) (= (curve25519_dalek!specs.scalar52_specs.nine_limbs_to_nat_aux.? (Poly%array%. limbs!))
     (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (vstd!array.spec_array_as_slice.?
       $ (UINT 128) $ (CONST_INT 9) (Poly%array%. limbs!)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_nine_limbs_equals_slice128_as_nat.
     limbs!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_nine_limbs_equals_slice128_as_nat._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_nine_limbs_equals_slice128_as_nat._definition
)))

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

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_mul_internal_correct
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_correct.
 (%%Function%% %%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%34 Bool)
(declare-const %%global_location_label%%35 Bool)
(declare-const %%global_location_label%%36 Bool)
(declare-const %%global_location_label%%37 Bool)
(declare-const %%global_location_label%%38 Bool)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(declare-const %%global_location_label%%41 Bool)
(declare-const %%global_location_label%%42 Bool)
(declare-const %%global_location_label%%43 Bool)
(assert
 (forall ((a! %%Function%%) (b! %%Function%%) (z! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_correct. a! b! z!)
    (and
     (=>
      %%global_location_label%%34
      (curve25519_dalek!specs.scalar52_specs.limb_prod_bounded_u128.? (Poly%array%. a!)
       (Poly%array%. b!) (I 5)
     ))
     (=>
      %%global_location_label%%35
      (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) (Poly%array%. z!)
         ) (I 0)
        )
       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. a!)
          ) (I 0)
         )
        ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) (Poly%array%. b!)
          ) (I 0)
     )))))
     (=>
      %%global_location_label%%36
      (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) (Poly%array%. z!)
         ) (I 1)
        )
       ) (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
              64
             ) $ (CONST_INT 5)
            ) (Poly%array%. a!)
           ) (I 0)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. b!)
           ) (I 1)
         ))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) (Poly%array%. a!)
           ) (I 1)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. b!)
           ) (I 0)
     ))))))
     (=>
      %%global_location_label%%37
      (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) (Poly%array%. z!)
         ) (I 2)
        )
       ) (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $
              (UINT 64) $ (CONST_INT 5)
             ) (Poly%array%. a!)
            ) (I 0)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. b!)
            ) (I 2)
          ))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) (Poly%array%. a!)
            ) (I 1)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. b!)
            ) (I 1)
         )))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) (Poly%array%. a!)
           ) (I 2)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. b!)
           ) (I 0)
     ))))))
     (=>
      %%global_location_label%%38
      (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) (Poly%array%. z!)
         ) (I 3)
        )
       ) (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 0)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 3)
           ))
          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 1)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 2)
          )))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) (Poly%array%. a!)
            ) (I 2)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. b!)
            ) (I 1)
         )))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) (Poly%array%. a!)
           ) (I 3)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. b!)
           ) (I 0)
     ))))))
     (=>
      %%global_location_label%%39
      (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) (Poly%array%. z!)
         ) (I 4)
        )
       ) (Add (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $
               (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. a!)
              ) (I 0)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. b!)
              ) (I 4)
            ))
           ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
                $ (CONST_INT 5)
               ) (Poly%array%. a!)
              ) (I 1)
             )
            ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
                (CONST_INT 5)
               ) (Poly%array%. b!)
              ) (I 3)
           )))
          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 2)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 2)
          )))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) (Poly%array%. a!)
            ) (I 3)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. b!)
            ) (I 1)
         )))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) (Poly%array%. a!)
           ) (I 4)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. b!)
           ) (I 0)
     ))))))
     (=>
      %%global_location_label%%40
      (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) (Poly%array%. z!)
         ) (I 5)
        )
       ) (Add (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 1)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 4)
           ))
          ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
               $ (CONST_INT 5)
              ) (Poly%array%. a!)
             ) (I 2)
            )
           ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. b!)
             ) (I 3)
          )))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) (Poly%array%. a!)
            ) (I 3)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. b!)
            ) (I 2)
         )))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) (Poly%array%. a!)
           ) (I 4)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. b!)
           ) (I 1)
     ))))))
     (=>
      %%global_location_label%%41
      (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) (Poly%array%. z!)
         ) (I 6)
        )
       ) (Add (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $
              (UINT 64) $ (CONST_INT 5)
             ) (Poly%array%. a!)
            ) (I 2)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. b!)
            ) (I 4)
          ))
         ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
              $ (CONST_INT 5)
             ) (Poly%array%. a!)
            ) (I 3)
           )
          ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
              (CONST_INT 5)
             ) (Poly%array%. b!)
            ) (I 3)
         )))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) (Poly%array%. a!)
           ) (I 4)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. b!)
           ) (I 2)
     ))))))
     (=>
      %%global_location_label%%42
      (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) (Poly%array%. z!)
         ) (I 7)
        )
       ) (Add (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
              64
             ) $ (CONST_INT 5)
            ) (Poly%array%. a!)
           ) (I 3)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. b!)
           ) (I 4)
         ))
        ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
             $ (CONST_INT 5)
            ) (Poly%array%. a!)
           ) (I 4)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. b!)
           ) (I 3)
     ))))))
     (=>
      %%global_location_label%%43
      (= (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $ (ARRAY $ (UINT 128)
           $ (CONST_INT 9)
          ) (Poly%array%. z!)
         ) (I 8)
        )
       ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. a!)
          ) (I 4)
         )
        ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
            (CONST_INT 5)
           ) (Poly%array%. b!)
          ) (I 4)
   )))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_correct. a!
     b! z!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_correct._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_correct._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_correct.
 (%%Function%% %%Function%% %%Function%%) Bool
)
(assert
 (forall ((a! %%Function%%) (b! %%Function%%) (z! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_correct. a! b! z!)
    (= (curve25519_dalek!specs.scalar52_specs.slice128_as_nat.? (vstd!array.spec_array_as_slice.?
       $ (UINT 128) $ (CONST_INT 9) (Poly%array%. z!)
      )
     ) (nClip (Mul (curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.? (vstd!array.spec_array_as_slice.?
         $ (UINT 64) $ (CONST_INT 5) (Poly%array%. a!)
        )
       ) (curve25519_dalek!specs.scalar52_specs.limbs52_as_nat.? (vstd!array.spec_array_as_slice.?
         $ (UINT 64) $ (CONST_INT 5) (Poly%array%. b!)
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_correct. a!
     b! z!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_correct._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_internal_correct._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_general_bound
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_general_bound. (vstd!seq.Seq<u64.>.)
 Bool
)
(declare-const %%global_location_label%%44 Bool)
(assert
 (forall ((a! vstd!seq.Seq<u64.>.)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_general_bound. a!) (=>
     %%global_location_label%%44
     (forall ((i$ Poly)) (!
       (=>
        (has_type i$ INT)
        (=>
         (let
          ((tmp%%$ (%I i$)))
          (and
           (<= 0 tmp%%$)
           (< tmp%%$ (vstd!seq.Seq.len.? $ (UINT 64) (Poly%vstd!seq.Seq<u64.>. a!)))
         ))
         (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (Poly%vstd!seq.Seq<u64.>. a!) i$)) (uClip
           64 (bitshl (I 1) (I 52))
       ))))
       :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (Poly%vstd!seq.Seq<u64.>. a!) i$))
       :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_general_bound_90
       :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_general_bound_90
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_general_bound. a!))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_general_bound._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_general_bound._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_general_bound. (vstd!seq.Seq<u64.>.)
 Bool
)
(assert
 (forall ((a! vstd!seq.Seq<u64.>.)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_general_bound. a!) (< (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.?
      (Poly%vstd!seq.Seq<u64.>. a!)
     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 52 (vstd!seq.Seq.len.? $ (UINT 64) (Poly%vstd!seq.Seq<u64.>.
           a!
   ))))))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_general_bound. a!))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_general_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_general_bound._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_bound_scalar
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(declare-const %%global_location_label%%45 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. a!) (=>
     %%global_location_label%%45
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

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_spec_mul_internal_commutative
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_spec_mul_internal_commutative.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_spec_mul_internal_commutative.
     a! b!
    ) (= (curve25519_dalek!specs.scalar52_specs.spec_mul_internal.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       a!
      ) (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
     ) (curve25519_dalek!specs.scalar52_specs.spec_mul_internal.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       b!
      ) (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_spec_mul_internal_commutative.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_spec_mul_internal_commutative._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_spec_mul_internal_commutative._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_l_limbs_bounded
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_limbs_bounded. (Int)
 Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_limbs_bounded. no%param) (curve25519_dalek!specs.scalar52_specs.limbs_bounded.?
     (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.constants.L.?)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_limbs_bounded. no%param))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_l_limbs_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_l_limbs_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::shift_lemmas::lemma_u64_shift_is_pow2
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
 (Int) Bool
)
(declare-const %%global_location_label%%46 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2.
     k!
    ) (=>
     %%global_location_label%%46
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

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_pow252
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_pow252. (Int) Bool)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_pow252. no%param) (= (vstd!arithmetic.power2.pow2.?
      (I 252)
     ) 7237005577332262213973186563042994240829374041602535252466099000494570602496
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_pow252. no%param))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_pow252._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_pow252._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_l_equals_group_order
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_equals_group_order.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_equals_group_order. no%param)
    (and
     (= (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        curve25519_dalek!backend.serial.u64.constants.L.?
       )
      ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
     )
     (= (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
        $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
          (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.constants.L.?)
         )))
        ) (I 0) (I 5)
       )
      ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_equals_group_order. no%param))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_l_equals_group_order._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_l_equals_group_order._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_seq_u64_as_nat_subrange_extend
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_seq_u64_as_nat_subrange_extend.
 (vstd!seq.Seq<u64.>. Int) Bool
)
(declare-const %%global_location_label%%47 Bool)
(assert
 (forall ((seq! vstd!seq.Seq<u64.>.) (i! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_seq_u64_as_nat_subrange_extend.
     seq! i!
    ) (=>
     %%global_location_label%%47
     (let
      ((tmp%%$ i!))
      (and
       (<= 0 tmp%%$)
       (< tmp%%$ (vstd!seq.Seq.len.? $ (UINT 64) (Poly%vstd!seq.Seq<u64.>. seq!)))
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_seq_u64_as_nat_subrange_extend.
     seq! i!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_seq_u64_as_nat_subrange_extend._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_seq_u64_as_nat_subrange_extend._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_seq_u64_as_nat_subrange_extend.
 (vstd!seq.Seq<u64.>. Int) Bool
)
(assert
 (forall ((seq! vstd!seq.Seq<u64.>.) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_seq_u64_as_nat_subrange_extend.
     seq! i!
    ) (= (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
       $ (UINT 64) (Poly%vstd!seq.Seq<u64.>. seq!) (I 0) (I (Add i! 1))
      )
     ) (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
        $ (UINT 64) (Poly%vstd!seq.Seq<u64.>. seq!) (I 0) (I i!)
       )
      ) (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (Poly%vstd!seq.Seq<u64.>. seq!) (I i!)))
       (vstd!arithmetic.power2.pow2.? (I (nClip (Mul 52 (nClip i!)))))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_seq_u64_as_nat_subrange_extend.
     seq! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_seq_u64_as_nat_subrange_extend._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_seq_u64_as_nat_subrange_extend._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_decompose
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_decompose. (Int Int)
 Bool
)
(declare-const %%global_location_label%%48 Bool)
(assert
 (forall ((a! Int) (mask! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_decompose. a! mask!) (=>
     %%global_location_label%%48
     (= mask! (Sub (uClip 64 (bitshl (I 1) (I 52))) 1))
   ))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_decompose. a! mask!))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_decompose._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_decompose._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_decompose. (Int Int)
 Bool
)
(assert
 (forall ((a! Int) (mask! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_decompose. a! mask!) (= a! (Add
      (Mul (uClip 64 (bitshr (I a!) (I 52))) (vstd!arithmetic.power2.pow2.? (I 52))) (uClip
       64 (bitand (I a!) (I mask!))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_decompose. a! mask!))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_decompose._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_decompose._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_sub_loop1_invariant
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_loop1_invariant.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) Bool
)
(declare-const %%global_location_label%%49 Bool)
(declare-const %%global_location_label%%50 Bool)
(declare-const %%global_location_label%%51 Bool)
(declare-const %%global_location_label%%52 Bool)
(declare-const %%global_location_label%%53 Bool)
(declare-const %%global_location_label%%54 Bool)
(declare-const %%global_location_label%%55 Bool)
(declare-const %%global_location_label%%56 Bool)
(declare-const %%global_location_label%%57 Bool)
(assert
 (forall ((difference! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (borrow!
    Int
   ) (i! Int) (a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (old_borrow! Int) (mask! Int) (difference_loop1_start! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_loop1_invariant. difference!
     borrow! i! a! b! old_borrow! mask! difference_loop1_start!
    ) (and
     (=>
      %%global_location_label%%49
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
       ) (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
     ))
     (=>
      %%global_location_label%%50
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        b!
     )))
     (=>
      %%global_location_label%%51
      (let
       ((tmp%%$ i!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 5)
     )))
     (=>
      %%global_location_label%%52
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ i!)
          ))
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  difference!
              ))))
             ) j$
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               difference!
           ))))
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_sub_loop1_invariant_126
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_sub_loop1_invariant_126
     )))
     (=>
      %%global_location_label%%53
      (= mask! (Sub (uClip 64 (bitshl (I 1) (I 52))) 1))
     )
     (=>
      %%global_location_label%%54
      (= (Sub (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
          $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
            (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
           )))
          ) (I 0) (I i!)
         )
        ) (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
          $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
            (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
           )))
          ) (I 0) (I i!)
        ))
       ) (Sub (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
          $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
            (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. difference_loop1_start!)
           )))
          ) (I 0) (I i!)
         )
        ) (Mul (uClip 64 (bitshr (I old_borrow!) (I 63))) (vstd!arithmetic.power2.pow2.? (I
           (nClip (Mul 52 i!))
     ))))))
     (=>
      %%global_location_label%%55
      (= (vstd!seq.Seq.subrange.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             difference_loop1_start!
         ))))
        ) (I 0) (I i!)
       ) (vstd!seq.Seq.subrange.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             difference!
         ))))
        ) (I 0) (I i!)
     )))
     (=>
      %%global_location_label%%56
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              difference!
          ))))
         ) (I i!)
        )
       ) (uClip 64 (bitand (I borrow!) (I mask!)))
     ))
     (=>
      %%global_location_label%%57
      (= borrow! (vstd!std_specs.num.u64_specs.wrapping_sub%returns_clause_autospec.? (vstd!seq.Seq.index.?
         $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
           (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
          )))
         ) (I i!)
        ) (I (uClip 64 (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
               $ (UINT 64) $ (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  b!
              ))))
             ) (I i!)
            )
           ) (uClip 64 (bitshr (I old_borrow!) (I 63)))
   ))))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_loop1_invariant. difference!
     borrow! i! a! b! old_borrow! mask! difference_loop1_start!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_loop1_invariant._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_loop1_invariant._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_loop1_invariant.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) Bool
)
(assert
 (forall ((difference! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (borrow!
    Int
   ) (i! Int) (a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (old_borrow! Int) (mask! Int) (difference_loop1_start! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_loop1_invariant. difference!
     borrow! i! a! b! old_borrow! mask! difference_loop1_start!
    ) (= (Sub (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
        $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
          (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. difference!)
         )))
        ) (I 0) (I (Add i! 1))
       )
      ) (Mul (uClip 64 (bitshr (I borrow!) (I 63))) (vstd!arithmetic.power2.pow2.? (I (nClip
          (Mul 52 (nClip (Add i! 1)))
      ))))
     ) (Sub (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
        $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
          (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
         )))
        ) (I 0) (I (Add i! 1))
       )
      ) (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
        $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
          (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
         )))
        ) (I 0) (I (Add i! 1))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_loop1_invariant. difference!
     borrow! i! a! b! old_borrow! mask! difference_loop1_start!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_loop1_invariant._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_loop1_invariant._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_borrow_and_mask_bounded
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_borrow_and_mask_bounded.
 (Int Int) Bool
)
(declare-const %%global_location_label%%58 Bool)
(assert
 (forall ((borrow! Int) (mask! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_borrow_and_mask_bounded. borrow!
     mask!
    ) (=>
     %%global_location_label%%58
     (= mask! (Sub (uClip 64 (bitshl (I 1) (I 52))) 1))
   ))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_borrow_and_mask_bounded.
     borrow! mask!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_borrow_and_mask_bounded._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_borrow_and_mask_bounded._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_borrow_and_mask_bounded.
 (Int Int) Bool
)
(assert
 (forall ((borrow! Int) (mask! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_borrow_and_mask_bounded. borrow!
     mask!
    ) (< (uClip 64 (bitand (I borrow!) (I mask!))) (uClip 64 (bitshl (I 1) (I 52))))
   )
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_borrow_and_mask_bounded.
     borrow! mask!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_borrow_and_mask_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_borrow_and_mask_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_scalar_subtract_no_overflow
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar_subtract_no_overflow.
 (Int Int Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.) Bool
)
(declare-const %%global_location_label%%59 Bool)
(declare-const %%global_location_label%%60 Bool)
(declare-const %%global_location_label%%61 Bool)
(declare-const %%global_location_label%%62 Bool)
(declare-const %%global_location_label%%63 Bool)
(declare-const %%global_location_label%%64 Bool)
(declare-const %%global_location_label%%65 Bool)
(declare-const %%global_location_label%%66 Bool)
(declare-const %%global_location_label%%67 Bool)
(declare-const %%global_location_label%%68 Bool)
(assert
 (forall ((carry! Int) (difference_limb! Int) (addend! Int) (i! Int) (l_value! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar_subtract_no_overflow. carry!
     difference_limb! addend! i! l_value!
    ) (and
     (=>
      %%global_location_label%%59
      (< i! 5)
     )
     (=>
      %%global_location_label%%60
      (< difference_limb! (uClip 64 (bitshl (I 1) (I 52))))
     )
     (=>
      %%global_location_label%%61
      (or
       (= addend! 0)
       (= addend! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
             64
            ) $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               l_value!
           ))))
          ) (I i!)
     )))))
     (=>
      %%global_location_label%%62
      (=>
       (= i! 0)
       (= carry! 0)
     ))
     (=>
      %%global_location_label%%63
      (=>
       (>= i! 1)
       (< (uClip 64 (bitshr (I carry!) (I 52))) 2)
     ))
     (=>
      %%global_location_label%%64
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              l_value!
          ))))
         ) (I 0)
        )
       ) 671914833335277
     ))
     (=>
      %%global_location_label%%65
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              l_value!
          ))))
         ) (I 1)
        )
       ) 3916664325105025
     ))
     (=>
      %%global_location_label%%66
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              l_value!
          ))))
         ) (I 2)
        )
       ) 1367801
     ))
     (=>
      %%global_location_label%%67
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              l_value!
          ))))
         ) (I 3)
        )
       ) 0
     ))
     (=>
      %%global_location_label%%68
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              l_value!
          ))))
         ) (I 4)
        )
       ) 17592186044416
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar_subtract_no_overflow.
     carry! difference_limb! addend! i! l_value!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar_subtract_no_overflow._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar_subtract_no_overflow._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar_subtract_no_overflow.
 (Int Int Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.) Bool
)
(assert
 (forall ((carry! Int) (difference_limb! Int) (addend! Int) (i! Int) (l_value! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar_subtract_no_overflow. carry!
     difference_limb! addend! i! l_value!
    ) (< (Add (Add (uClip 64 (bitshr (I carry!) (I 52))) difference_limb!) addend!) (uClip
      64 (bitshl (I 1) (I 53))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar_subtract_no_overflow.
     carry! difference_limb! addend! i! l_value!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar_subtract_no_overflow._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar_subtract_no_overflow._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_carry_bounded_after_mask
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_carry_bounded_after_mask.
 (Int Int) Bool
)
(declare-const %%global_location_label%%69 Bool)
(declare-const %%global_location_label%%70 Bool)
(assert
 (forall ((carry! Int) (mask! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_carry_bounded_after_mask. carry!
     mask!
    ) (and
     (=>
      %%global_location_label%%69
      (= mask! (Sub (uClip 64 (bitshl (I 1) (I 52))) 1))
     )
     (=>
      %%global_location_label%%70
      (< carry! (uClip 64 (bitshl (I 1) (I 53))))
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_carry_bounded_after_mask.
     carry! mask!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_carry_bounded_after_mask._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_carry_bounded_after_mask._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_carry_bounded_after_mask.
 (Int Int) Bool
)
(assert
 (forall ((carry! Int) (mask! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_carry_bounded_after_mask. carry!
     mask!
    ) (and
     (< (uClip 64 (bitand (I carry!) (I mask!))) (uClip 64 (bitshl (I 1) (I 52))))
     (<= (uClip 64 (bitshr (I carry!) (I 52))) 1)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_carry_bounded_after_mask.
     carry! mask!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_carry_bounded_after_mask._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_carry_bounded_after_mask._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_add_l_loop_invariant
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_l_loop_invariant.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int Int Bool
 ) Bool
)
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
(assert
 (forall ((result! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (i! Int) (mask!
    Int
   ) (orig! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (before! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (carry! Int) (old_carry! Int) (addend! Int) (is_adding! Bool)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_l_loop_invariant. result! i!
     mask! orig! before! carry! old_carry! addend! is_adding!
    ) (and
     (=>
      %%global_location_label%%71
      (let
       ((tmp%%$ i!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 5)
     )))
     (=>
      %%global_location_label%%72
      (= mask! (Sub (uClip 64 (bitshl (I 1) (I 52))) 1))
     )
     (=>
      %%global_location_label%%73
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
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  before!
              ))))
             ) j$
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               before!
           ))))
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_add_l_loop_invariant_157
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_add_l_loop_invariant_157
     )))
     (=>
      %%global_location_label%%74
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= i! tmp%%$)
            (< tmp%%$ 5)
          ))
          (= (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT
               5
              )
             ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
               (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                 before!
             ))))
            ) j$
           ) (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT
               5
              )
             ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
               (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                 orig!
             ))))
            ) j$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               before!
           ))))
          ) j$
        ))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               orig!
           ))))
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_add_l_loop_invariant_158
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_add_l_loop_invariant_158
     )))
     (=>
      %%global_location_label%%75
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (and
           (let
            ((tmp%%$ (%I j$)))
            (and
             (<= 0 tmp%%$)
             (< tmp%%$ 5)
           ))
           (not (= (%I j$) i!))
          )
          (= (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT
               5
              )
             ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
               (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                 before!
             ))))
            ) j$
           ) (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT
               5
              )
             ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
               (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                 result!
             ))))
            ) j$
        ))))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               before!
           ))))
          ) j$
        ))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               result!
           ))))
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_add_l_loop_invariant_159
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_add_l_loop_invariant_159
     )))
     (=>
      %%global_location_label%%76
      (=>
       (= i! 0)
       (= old_carry! 0)
     ))
     (=>
      %%global_location_label%%77
      (=>
       (>= i! 1)
       (< (uClip 64 (bitshr (I old_carry!) (I 52))) 2)
     ))
     (=>
      %%global_location_label%%78
      (=>
       (and
        (>= i! 1)
        (not is_adding!)
       )
       (= old_carry! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $
            (UINT 64) $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               before!
           ))))
          ) (I (Sub i! 1))
     )))))
     (=>
      %%global_location_label%%79
      (=>
       (not is_adding!)
       (= orig! before!)
     ))
     (=>
      %%global_location_label%%80
      (=>
       is_adding!
       (= (nClip (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
            $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
              (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. orig!)
             )))
            ) (I 0) (I i!)
           )
          ) (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
            $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
              (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.constants.L.?)
             )))
            ) (I 0) (I i!)
         )))
        ) (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
           $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
             (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. before!)
            )))
           ) (I 0) (I i!)
          )
         ) (Mul (uClip 64 (bitshr (I old_carry!) (I 52))) (vstd!arithmetic.power2.pow2.? (I (
             nClip (Mul 52 i!)
     ))))))))
     (=>
      %%global_location_label%%81
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              result!
          ))))
         ) (I i!)
        )
       ) (uClip 64 (bitand (I carry!) (I mask!)))
     ))
     (=>
      %%global_location_label%%82
      (= (vstd!seq.Seq.subrange.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             before!
         ))))
        ) (I 0) (I i!)
       ) (vstd!seq.Seq.subrange.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             result!
         ))))
        ) (I 0) (I i!)
     )))
     (=>
      %%global_location_label%%83
      (=>
       (not is_adding!)
       (= addend! 0)
     ))
     (=>
      %%global_location_label%%84
      (=>
       is_adding!
       (= addend! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
             64
            ) $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               curve25519_dalek!backend.serial.u64.constants.L.?
           ))))
          ) (I i!)
     )))))
     (=>
      %%global_location_label%%85
      (= carry! (Add (Add (uClip 64 (bitshr (I old_carry!) (I 52))) (%I (vstd!seq.Seq.index.?
           $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
             (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. before!)
            )))
           ) (I i!)
         ))
        ) addend!
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_l_loop_invariant. result!
     i! mask! orig! before! carry! old_carry! addend! is_adding!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_l_loop_invariant._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_l_loop_invariant._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_l_loop_invariant.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int Int Bool
 ) Bool
)
(assert
 (forall ((result! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (i! Int) (mask!
    Int
   ) (orig! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (before! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (carry! Int) (old_carry! Int) (addend! Int) (is_adding! Bool)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_l_loop_invariant. result! i!
     mask! orig! before! carry! old_carry! addend! is_adding!
    ) (and
     (=>
      (and
       (>= (Add i! 1) 1)
       (not is_adding!)
      )
      (= carry! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
            64
           ) $ (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              result!
          ))))
         ) (I i!)
     ))))
     (=>
      (not is_adding!)
      (= orig! result!)
     )
     (=>
      is_adding!
      (= (nClip (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
           $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
             (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. orig!)
            )))
           ) (I 0) (I (Add i! 1))
          )
         ) (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
           $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
             (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.constants.L.?)
            )))
           ) (I 0) (I (Add i! 1))
        )))
       ) (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
          $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
            (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. result!)
           )))
          ) (I 0) (I (Add i! 1))
         )
        ) (Mul (uClip 64 (bitshr (I carry!) (I 52))) (vstd!arithmetic.power2.pow2.? (I (nClip
            (Mul 52 (nClip (Add i! 1)))
   )))))))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_l_loop_invariant. result!
     i! mask! orig! before! carry! old_carry! addend! is_adding!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_l_loop_invariant._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_l_loop_invariant._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_subrange5_eq_scalar52_as_nat
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_subrange5_eq_scalar52_as_nat.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52.) Bool
)
(assert
 (forall ((x! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_subrange5_eq_scalar52_as_nat. x!)
    (and
     (= (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           x!
       ))))
      ) (vstd!seq.Seq.subrange.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
         (CONST_INT 5)
        ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
          (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            x!
        ))))
       ) (I 0) (I 5)
     ))
     (= (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
        $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
          (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. x!)
         )))
        ) (I 0) (I 5)
       )
      ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        x!
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_subrange5_eq_scalar52_as_nat.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_subrange5_eq_scalar52_as_nat._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_subrange5_eq_scalar52_as_nat._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_mod_cancel
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mod_cancel. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mod_cancel. a! b!) (= (EucMod (Sub
       (nClip (Add (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.?
          (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
        ))
       ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         b!
       ))
      ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
     ) (EucMod (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         a!
        )
       ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         b!
       ))
      ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_mod_cancel. a! b!))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_mod_cancel._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_mod_cancel._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_sub_correct_after_loops
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_correct_after_loops.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Int
 ) Bool
)
(declare-const %%global_location_label%%86 Bool)
(declare-const %%global_location_label%%87 Bool)
(declare-const %%global_location_label%%88 Bool)
(declare-const %%global_location_label%%89 Bool)
(declare-const %%global_location_label%%90 Bool)
(declare-const %%global_location_label%%91 Bool)
(declare-const %%global_location_label%%92 Bool)
(declare-const %%global_location_label%%93 Bool)
(declare-const %%global_location_label%%94 Bool)
(assert
 (forall ((difference! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (carry!
    Int
   ) (a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (difference_after_loop1! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (borrow!
    Int
   )
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_correct_after_loops. difference!
     carry! a! b! difference_after_loop1! borrow!
    ) (and
     (=>
      %%global_location_label%%86
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
       ) (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
     ))
     (=>
      %%global_location_label%%87
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        b!
     )))
     (=>
      %%global_location_label%%88
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        difference!
     )))
     (=>
      %%global_location_label%%89
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        difference_after_loop1!
     )))
     (=>
      %%global_location_label%%90
      (< (uClip 64 (bitshr (I carry!) (I 52))) 2)
     )
     (=>
      %%global_location_label%%91
      (let
       ((tmp%%$ (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            a!
           )
          ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            b!
       )))))
       (and
        (<= (Sub 0 (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))) tmp%%$)
        (< tmp%%$ (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)))
     )))
     (=>
      %%global_location_label%%92
      (=>
       (= (uClip 64 (bitshr (I borrow!) (I 63))) 0)
       (= difference_after_loop1! difference!)
     ))
     (=>
      %%global_location_label%%93
      (=>
       (= (uClip 64 (bitshr (I borrow!) (I 63))) 1)
       (= (nClip (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
            $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
              (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. difference_after_loop1!)
             )))
            ) (I 0) (I 5)
           )
          ) (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
            $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
              (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.constants.L.?)
             )))
            ) (I 0) (I 5)
         )))
        ) (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
           $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
             (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. difference!)
            )))
           ) (I 0) (I 5)
          )
         ) (Mul (uClip 64 (bitshr (I carry!) (I 52))) (vstd!arithmetic.power2.pow2.? (I (nClip
             (Mul 52 5)
     ))))))))
     (=>
      %%global_location_label%%94
      (= (Sub (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
          $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
            (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
           )))
          ) (I 0) (I 5)
         )
        ) (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
          $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
            (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
           )))
          ) (I 0) (I 5)
        ))
       ) (Sub (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
          $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
            (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. difference_after_loop1!)
           )))
          ) (I 0) (I 5)
         )
        ) (Mul (uClip 64 (bitshr (I borrow!) (I 63))) (vstd!arithmetic.power2.pow2.? (I (nClip
            (Mul 52 5)
   )))))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_correct_after_loops.
     difference! carry! a! b! difference_after_loop1! borrow!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_correct_after_loops._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_correct_after_loops._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_correct_after_loops.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Int
 ) Bool
)
(assert
 (forall ((difference! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (carry!
    Int
   ) (a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (difference_after_loop1! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (borrow!
    Int
   )
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_correct_after_loops. difference!
     carry! a! b! difference_after_loop1! borrow!
    ) (= (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       difference!
      )
     ) (EucMod (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         a!
        )
       ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         b!
       ))
      ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_correct_after_loops.
     difference! carry! a! b! difference_after_loop1! borrow!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_correct_after_loops._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_correct_after_loops._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_mul_factors_congruent_implies_products_congruent
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%95 Bool)
(declare-const %%global_location_label%%96 Bool)
(assert
 (forall ((c! Int) (a! Int) (b! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_mul_factors_congruent_implies_products_congruent.
     c! a! b! m!
    ) (and
     (=>
      %%global_location_label%%95
      (> m! 0)
     )
     (=>
      %%global_location_label%%96
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

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_rr_equals_spec
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_rr_equals_spec. (Int)
 Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_rr_equals_spec. no%param) (and
     (= (EucMod (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         curve25519_dalek!backend.serial.u64.constants.RR.?
        )
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
      ) (EucMod (nClip (Mul (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0))
         (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0))
        )
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
     ))
     (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        curve25519_dalek!backend.serial.u64.constants.RR.?
       )
      ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_rr_equals_spec. no%param))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_rr_equals_spec._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_rr_equals_spec._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_int_nat_mod_equiv
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv.
 (Int Int) Bool
)
(declare-const %%global_location_label%%97 Bool)
(declare-const %%global_location_label%%98 Bool)
(assert
 (forall ((v! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv.
     v! m!
    ) (and
     (=>
      %%global_location_label%%97
      (>= v! 0)
     )
     (=>
      %%global_location_label%%98
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

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_montgomery_inverse
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_montgomery_inverse. (
  Int
 ) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_montgomery_inverse. no%param)
    (= (EucMod (nClip (Mul (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0))
        (curve25519_dalek!specs.scalar52_specs.inv_montgomery_radix.? (I 0))
       )
      ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
     ) 1
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_montgomery_inverse. no%param))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_montgomery_inverse._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_montgomery_inverse._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_cancel_mul_montgomery_mod
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_montgomery_mod.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%99 Bool)
(declare-const %%global_location_label%%100 Bool)
(declare-const %%global_location_label%%101 Bool)
(assert
 (forall ((x! Int) (a! Int) (rr! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_montgomery_mod. x! a!
     rr!
    ) (and
     (=>
      %%global_location_label%%99
      (= (EucMod (nClip (Mul x! (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I
            0
         )))
        ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
       ) (EucMod (nClip (Mul a! rr!)) (curve25519_dalek!specs.scalar52_specs.group_order.?
         (I 0)
     ))))
     (=>
      %%global_location_label%%100
      (= (EucMod rr! (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))) (EucMod
        (nClip (Mul (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0)) (curve25519_dalek!specs.scalar52_specs.montgomery_radix.?
           (I 0)
         ))
        ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
     )))
     (=>
      %%global_location_label%%101
      (> (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)) 0)
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_montgomery_mod.
     x! a! rr!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_montgomery_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_montgomery_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_montgomery_mod.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (a! Int) (rr! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_montgomery_mod. x! a!
     rr!
    ) (= (EucMod x! (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))) (EucMod
      (nClip (Mul a! (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0))))
      (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_montgomery_mod.
     x! a! rr!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_montgomery_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_montgomery_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_group_order_bound
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_bound. (Int)
 Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_bound. no%param) (
     < (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)) (vstd!arithmetic.power2.pow2.?
      (I 255)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_bound. no%param))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_bound._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_scalar52_lt_pow2_256_if_canonical
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar52_lt_pow2_256_if_canonical.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52.) Bool
)
(declare-const %%global_location_label%%102 Bool)
(declare-const %%global_location_label%%103 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar52_lt_pow2_256_if_canonical.
     a!
    ) (and
     (=>
      %%global_location_label%%102
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
     )))
     (=>
      %%global_location_label%%103
      (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         a!
        )
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar52_lt_pow2_256_if_canonical.
     a!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar52_lt_pow2_256_if_canonical._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar52_lt_pow2_256_if_canonical._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar52_lt_pow2_256_if_canonical.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52.) Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar52_lt_pow2_256_if_canonical.
     a!
    ) (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       a!
      )
     ) (vstd!arithmetic.power2.pow2.? (I 256))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar52_lt_pow2_256_if_canonical.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar52_lt_pow2_256_if_canonical._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_scalar52_lt_pow2_256_if_canonical._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_u8_32_as_nat_lower_bound
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
 (%%Function%% Int) Bool
)
(declare-const %%global_location_label%%104 Bool)
(assert
 (forall ((bytes! %%Function%%) (index! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
     bytes! index!
    ) (=>
     %%global_location_label%%104
     (< index! 32)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
     bytes! index!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
 (%%Function%% Int) Bool
)
(assert
 (forall ((bytes! %%Function%%) (index! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
     bytes! index!
    ) (>= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes!)) (nClip
      (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $
           (CONST_INT 32)
          ) (Poly%array%. bytes!)
         ) (I index!)
        )
       ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul index! 8))))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound.
     bytes! index!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_u8_32_as_nat_lower_bound._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_add_loop_bounds
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_bounds. (Int
  Int Int Int
 ) Bool
)
(declare-const %%global_location_label%%105 Bool)
(declare-const %%global_location_label%%106 Bool)
(declare-const %%global_location_label%%107 Bool)
(declare-const %%global_location_label%%108 Bool)
(declare-const %%global_location_label%%109 Bool)
(assert
 (forall ((i! Int) (carry! Int) (a_limb! Int) (b_limb! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_bounds. i! carry! a_limb!
     b_limb!
    ) (and
     (=>
      %%global_location_label%%105
      (let
       ((tmp%%$ i!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 5)
     )))
     (=>
      %%global_location_label%%106
      (< a_limb! (uClip 64 (bitshl (I 1) (I 52))))
     )
     (=>
      %%global_location_label%%107
      (< b_limb! (uClip 64 (bitshl (I 1) (I 52))))
     )
     (=>
      %%global_location_label%%108
      (=>
       (= i! 0)
       (= carry! 0)
     ))
     (=>
      %%global_location_label%%109
      (=>
       (>= i! 1)
       (< (uClip 64 (bitshr (I carry!) (I 52))) 2)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_bounds. i! carry!
     a_limb! b_limb!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_bounds._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_bounds._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_bounds. (Int
  Int Int Int
 ) Bool
)
(assert
 (forall ((i! Int) (carry! Int) (a_limb! Int) (b_limb! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_bounds. i! carry! a_limb!
     b_limb!
    ) (< (Add (Add (uClip 64 (bitshr (I carry!) (I 52))) a_limb!) b_limb!) (uClip 64 (bitshl
       (I 1) (I 53)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_bounds. i! carry!
     a_limb! b_limb!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_bounds._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_bounds._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_add_loop_invariant
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_invariant. (
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) Bool
)
(declare-const %%global_location_label%%110 Bool)
(declare-const %%global_location_label%%111 Bool)
(declare-const %%global_location_label%%112 Bool)
(declare-const %%global_location_label%%113 Bool)
(declare-const %%global_location_label%%114 Bool)
(declare-const %%global_location_label%%115 Bool)
(declare-const %%global_location_label%%116 Bool)
(declare-const %%global_location_label%%117 Bool)
(declare-const %%global_location_label%%118 Bool)
(assert
 (forall ((sum! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (carry! Int) (
    i! Int
   ) (a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (old_carry! Int) (mask! Int) (sum_loop_start! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_invariant. sum! carry!
     i! a! b! old_carry! mask! sum_loop_start!
    ) (and
     (=>
      %%global_location_label%%110
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
     )))
     (=>
      %%global_location_label%%111
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        b!
     )))
     (=>
      %%global_location_label%%112
      (let
       ((tmp%%$ i!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ 5)
     )))
     (=>
      %%global_location_label%%113
      (forall ((j$ Poly)) (!
        (=>
         (has_type j$ INT)
         (=>
          (let
           ((tmp%%$ (%I j$)))
           (and
            (<= 0 tmp%%$)
            (< tmp%%$ i!)
          ))
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  sum!
              ))))
             ) j$
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               sum!
           ))))
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_add_loop_invariant_210
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_add_loop_invariant_210
     )))
     (=>
      %%global_location_label%%114
      (= mask! (Sub (uClip 64 (bitshl (I 1) (I 52))) 1))
     )
     (=>
      %%global_location_label%%115
      (= (nClip (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
           $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
             (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
            )))
           ) (I 0) (I i!)
          )
         ) (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
           $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
             (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
            )))
           ) (I 0) (I i!)
        )))
       ) (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
          $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
            (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. sum_loop_start!)
           )))
          ) (I 0) (I i!)
         )
        ) (Mul (uClip 64 (bitshr (I old_carry!) (I 52))) (vstd!arithmetic.power2.pow2.? (I (
            nClip (Mul 52 i!)
     )))))))
     (=>
      %%global_location_label%%116
      (= (vstd!seq.Seq.subrange.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             sum_loop_start!
         ))))
        ) (I 0) (I i!)
       ) (vstd!seq.Seq.subrange.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
          (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             sum!
         ))))
        ) (I 0) (I i!)
     )))
     (=>
      %%global_location_label%%117
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              sum!
          ))))
         ) (I i!)
        )
       ) (uClip 64 (bitand (I carry!) (I mask!)))
     ))
     (=>
      %%global_location_label%%118
      (= carry! (Add (Add (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY
             $ (UINT 64) $ (CONST_INT 5)
            ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                a!
            ))))
           ) (I i!)
          )
         ) (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                b!
            ))))
           ) (I i!)
         ))
        ) (uClip 64 (bitshr (I old_carry!) (I 52)))
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_invariant. sum!
     carry! i! a! b! old_carry! mask! sum_loop_start!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_invariant._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_invariant._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_invariant. (
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) Bool
)
(assert
 (forall ((sum! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (carry! Int) (
    i! Int
   ) (a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (old_carry! Int) (mask! Int) (sum_loop_start! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_invariant. sum! carry!
     i! a! b! old_carry! mask! sum_loop_start!
    ) (= (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
        $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
          (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. sum!)
         )))
        ) (I 0) (I (Add i! 1))
       )
      ) (Mul (uClip 64 (bitshr (I carry!) (I 52))) (vstd!arithmetic.power2.pow2.? (I (nClip
          (Mul 52 (nClip (Add i! 1)))
      ))))
     ) (nClip (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
         $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
           (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
          )))
         ) (I 0) (I (Add i! 1))
        )
       ) (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
         $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
           (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
          )))
         ) (I 0) (I (Add i! 1))
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_invariant. sum!
     carry! i! a! b! old_carry! mask! sum_loop_start!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_invariant._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_loop_invariant._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_add_carry_and_sum_bounds
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_carry_and_sum_bounds.
 (Int Int) Bool
)
(declare-const %%global_location_label%%119 Bool)
(declare-const %%global_location_label%%120 Bool)
(assert
 (forall ((carry! Int) (mask! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_carry_and_sum_bounds. carry!
     mask!
    ) (and
     (=>
      %%global_location_label%%119
      (= mask! (Sub (uClip 64 (bitshl (I 1) (I 52))) 1))
     )
     (=>
      %%global_location_label%%120
      (< carry! (uClip 64 (bitshl (I 1) (I 53))))
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_carry_and_sum_bounds.
     carry! mask!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_carry_and_sum_bounds._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_carry_and_sum_bounds._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_carry_and_sum_bounds.
 (Int Int) Bool
)
(assert
 (forall ((carry! Int) (mask! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_carry_and_sum_bounds. carry!
     mask!
    ) (and
     (< (uClip 64 (bitand (I carry!) (I mask!))) (uClip 64 (bitshl (I 1) (I 52))))
     (< (uClip 64 (bitshr (I carry!) (I 52))) 2)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_carry_and_sum_bounds.
     carry! mask!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_carry_and_sum_bounds._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_carry_and_sum_bounds._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_pow2_260_greater_than_2_group_order
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_pow2_260_greater_than_2_group_order.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_pow2_260_greater_than_2_group_order.
     no%param
    ) (> (vstd!arithmetic.power2.pow2.? (I 260)) (nClip (Mul 2 (curve25519_dalek!specs.scalar52_specs.group_order.?
        (I 0)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_pow2_260_greater_than_2_group_order.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_pow2_260_greater_than_2_group_order._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_pow2_260_greater_than_2_group_order._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_add_sum_simplify
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_sum_simplify. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Int
 ) Bool
)
(declare-const %%global_location_label%%121 Bool)
(declare-const %%global_location_label%%122 Bool)
(declare-const %%global_location_label%%123 Bool)
(declare-const %%global_location_label%%124 Bool)
(declare-const %%global_location_label%%125 Bool)
(declare-const %%global_location_label%%126 Bool)
(declare-const %%global_location_label%%127 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (sum! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (carry! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_sum_simplify. a! b! sum! carry!)
    (and
     (=>
      %%global_location_label%%121
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
     )))
     (=>
      %%global_location_label%%122
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        b!
     )))
     (=>
      %%global_location_label%%123
      (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         a!
        )
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
     ))
     (=>
      %%global_location_label%%124
      (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         b!
        )
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
     ))
     (=>
      %%global_location_label%%125
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
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  sum!
              ))))
             ) j$
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               sum!
           ))))
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_add_sum_simplify_228
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_add_sum_simplify_228
     )))
     (=>
      %%global_location_label%%126
      (< (uClip 64 (bitshr (I carry!) (I 52))) 2)
     )
     (=>
      %%global_location_label%%127
      (= (nClip (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
           $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
             (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!)
            )))
           ) (I 0) (I 5)
          )
         ) (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
           $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
             (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
            )))
           ) (I 0) (I 5)
        )))
       ) (nClip (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
           $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
             (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. sum!)
            )))
           ) (I 0) (I 5)
          )
         ) (nClip (Mul (uClip 64 (bitshr (I carry!) (I 52))) (vstd!arithmetic.power2.pow2.? (
             I (nClip (Mul 52 5))
   ))))))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_sum_simplify. a! b!
     sum! carry!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_sum_simplify._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_sum_simplify._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_sum_simplify. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Int
 ) Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (sum! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (carry! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_sum_simplify. a! b! sum! carry!)
    (= (nClip (Add (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         a!
        )
       ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         b!
      )))
     ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       sum!
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_add_sum_simplify. a! b!
     sum! carry!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_sum_simplify._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_add_sum_simplify._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_l_value_properties
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_value_properties. (
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) Bool
)
(declare-const %%global_location_label%%128 Bool)
(declare-const %%global_location_label%%129 Bool)
(declare-const %%global_location_label%%130 Bool)
(declare-const %%global_location_label%%131 Bool)
(declare-const %%global_location_label%%132 Bool)
(declare-const %%global_location_label%%133 Bool)
(assert
 (forall ((l_value! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (sum! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_value_properties. l_value! sum!)
    (and
     (=>
      %%global_location_label%%128
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              l_value!
          ))))
         ) (I 0)
        )
       ) 671914833335277
     ))
     (=>
      %%global_location_label%%129
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              l_value!
          ))))
         ) (I 1)
        )
       ) 3916664325105025
     ))
     (=>
      %%global_location_label%%130
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              l_value!
          ))))
         ) (I 2)
        )
       ) 1367801
     ))
     (=>
      %%global_location_label%%131
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              l_value!
          ))))
         ) (I 3)
        )
       ) 0
     ))
     (=>
      %%global_location_label%%132
      (= (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              l_value!
          ))))
         ) (I 4)
        )
       ) 17592186044416
     ))
     (=>
      %%global_location_label%%133
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
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  sum!
              ))))
             ) j$
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               sum!
           ))))
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_l_value_properties_233
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_l_value_properties_233
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_value_properties. l_value!
     sum!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_l_value_properties._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_l_value_properties._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_value_properties. (
  curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
 ) Bool
)
(assert
 (forall ((l_value! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (sum! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_value_properties. l_value! sum!)
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
        (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
             (CONST_INT 5)
            ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
              (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                l_value!
            ))))
           ) j$
          )
         ) (uClip 64 (bitshl (I 1) (I 52)))
      )))
      :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
          $ (CONST_INT 5)
         ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
           (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             l_value!
         ))))
        ) j$
      ))
      :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_l_value_properties_234
      :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_l_value_properties_234
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_l_value_properties. l_value!
     sum!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_l_value_properties._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_l_value_properties._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_group_order_smaller_than_pow256
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_smaller_than_pow256.
 (Int) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_smaller_than_pow256.
     no%param
    ) (< (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)) (vstd!arithmetic.power2.pow2.?
      (I 256)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_smaller_than_pow256.
     no%param
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_smaller_than_pow256._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_smaller_than_pow256._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_r_bounded
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_bounded. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(declare-const %%global_location_label%%134 Bool)
(assert
 (forall ((r! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_bounded. r!) (=>
     %%global_location_label%%134
     (= r! (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52 (%Poly%array%.
        (array_new $ (UINT 64) 5 (%%array%%0 (I 4302102966953709) (I 1049714374468698) (I 4503599278581019)
          (I 4503599627370495) (I 17592186044415)
   )))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_bounded. r!))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_r_bounded._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_r_bounded._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_bounded. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(assert
 (forall ((r! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_bounded. r!) (curve25519_dalek!specs.scalar52_specs.limbs_bounded.?
     (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. r!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_bounded. r!))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_r_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_r_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_zero_bounded
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_zero_bounded. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(declare-const %%global_location_label%%135 Bool)
(assert
 (forall ((z! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_zero_bounded. z!) (=>
     %%global_location_label%%135
     (= z! (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52 (%Poly%array%.
        (array_new $ (UINT 64) 5 (%%array%%0 (I 0) (I 0) (I 0) (I 0) (I 0)))
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_zero_bounded. z!))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_zero_bounded._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_zero_bounded._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_zero_bounded. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(assert
 (forall ((z! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_zero_bounded. z!) (and
     (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       z!
     ))
     (= (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        z!
       )
      ) 0
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_zero_bounded. z!))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_zero_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_zero_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_r_equals_spec
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_equals_spec. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(declare-const %%global_location_label%%136 Bool)
(assert
 (forall ((r! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_equals_spec. r!) (=>
     %%global_location_label%%136
     (= r! (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52 (%Poly%array%.
        (array_new $ (UINT 64) 5 (%%array%%0 (I 4302102966953709) (I 1049714374468698) (I 4503599278581019)
          (I 4503599627370495) (I 17592186044415)
   )))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_equals_spec. r!))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_r_equals_spec._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_r_equals_spec._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_equals_spec. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(assert
 (forall ((r! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_equals_spec. r!) (and
     (= (EucMod (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         r!
        )
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
      ) (EucMod (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I 0)) (curve25519_dalek!specs.scalar52_specs.group_order.?
        (I 0)
     )))
     (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        r!
       )
      ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_equals_spec. r!))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_r_equals_spec._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_r_equals_spec._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_even
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even.
 (Int) Bool
)
(declare-const %%global_location_label%%137 Bool)
(assert
 (forall ((n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even. n!) (=>
     %%global_location_label%%137
     (>= n! 1)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even. n!))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even.
 (Int) Bool
)
(assert
 (forall ((n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even. n!) (= (EucMod
      (vstd!arithmetic.power2.pow2.? (I n!)) 2
     ) 0
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even. n!))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_group_order_is_odd
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_is_odd. (
  Int
 ) Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_is_odd. no%param)
    (= (EucMod (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)) 2) 1)
   )
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_is_odd. no%param))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_is_odd._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_group_order_is_odd._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_gcd_symmetric
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_symmetric.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_symmetric.
     a! b!
    ) (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I a!)
      (I b!)
     ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I b!) (I
       a!
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_symmetric.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_symmetric._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_symmetric._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_gcd_mod_noop
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_mod_noop.
 (Int Int) Bool
)
(declare-const %%global_location_label%%138 Bool)
(assert
 (forall ((a! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_mod_noop.
     a! m!
    ) (=>
     %%global_location_label%%138
     (> m! 0)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_mod_noop.
     a! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_mod_noop._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_mod_noop._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_mod_noop.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_mod_noop.
     a! m!
    ) (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (EucMod
        a! m!
       )
      ) (I m!)
     ) (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I a!) (I
       m!
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_mod_noop.
     a! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_mod_noop._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_mod_noop._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_gcd_pow2_odd
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_pow2_odd.
 (Int Int) Bool
)
(declare-const %%global_location_label%%139 Bool)
(assert
 (forall ((k! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_pow2_odd.
     k! n!
    ) (=>
     %%global_location_label%%139
     (= (EucMod n! 2) 1)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_pow2_odd.
     k! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_pow2_odd._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_pow2_odd._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_pow2_odd.
 (Int Int) Bool
)
(assert
 (forall ((k! Int) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_pow2_odd.
     k! n!
    ) (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (vstd!arithmetic.power2.pow2.?
        (I k!)
       )
      ) (I n!)
     ) 1
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_pow2_odd.
     k! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_pow2_odd._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_gcd_pow2_odd._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::number_theory_lemmas::lemma_mod_inverse_correct
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_inverse_correct.
 (Int Int) Bool
)
(declare-const %%global_location_label%%140 Bool)
(declare-const %%global_location_label%%141 Bool)
(assert
 (forall ((a! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_inverse_correct.
     a! m!
    ) (and
     (=>
      %%global_location_label%%140
      (> m! 1)
     )
     (=>
      %%global_location_label%%141
      (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (EucMod
          a! m!
         )
        ) (I m!)
       ) 1
   ))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_inverse_correct.
     a! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_inverse_correct._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_inverse_correct._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_inverse_correct.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_inverse_correct.
     a! m!
    ) (and
     (< (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.? (
        I a!
       ) (I m!)
      ) m!
     )
     (= (EucMod (nClip (Mul a! (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_mod_inverse.?
          (I a!) (I m!)
        ))
       ) m!
      ) 1
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_inverse_correct.
     a! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_inverse_correct._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.lemma_mod_inverse_correct._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_cancel_coprime_factor
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_coprime_factor.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%142 Bool)
(declare-const %%global_location_label%%143 Bool)
(declare-const %%global_location_label%%144 Bool)
(assert
 (forall ((a! Int) (b! Int) (factor! Int) (modulus! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_coprime_factor. a! b! factor!
     modulus!
    ) (and
     (=>
      %%global_location_label%%142
      (> modulus! 1)
     )
     (=>
      %%global_location_label%%143
      (= (curve25519_dalek!lemmas.common_lemmas.number_theory_lemmas.spec_gcd.? (I (EucMod
          factor! modulus!
         )
        ) (I modulus!)
       ) 1
     ))
     (=>
      %%global_location_label%%144
      (= (EucMod (nClip (Mul a! factor!)) modulus!) (EucMod (nClip (Mul b! factor!)) modulus!))
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_coprime_factor. a!
     b! factor! modulus!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_coprime_factor._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_coprime_factor._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_coprime_factor.
 (Int Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (factor! Int) (modulus! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_coprime_factor. a! b! factor!
     modulus!
    ) (= (EucMod a! modulus!) (EucMod b! modulus!))
   )
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_coprime_factor. a!
     b! factor! modulus!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_coprime_factor._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_coprime_factor._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_cancel_mul_R_mod_L
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_R_mod_L. (
  Int Int
 ) Bool
)
(declare-const %%global_location_label%%145 Bool)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_R_mod_L. a! b!) (=>
     %%global_location_label%%145
     (= (EucMod (nClip (Mul a! (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I
           0
        )))
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
      ) (EucMod (nClip (Mul b! (curve25519_dalek!specs.scalar52_specs.montgomery_radix.? (I
           0
        )))
       ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   ))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_R_mod_L. a! b!))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_R_mod_L._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_R_mod_L._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_R_mod_L. (
  Int Int
 ) Bool
)
(assert
 (forall ((a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_R_mod_L. a! b!) (= (
      EucMod a! (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
     ) (EucMod b! (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_R_mod_L. a! b!))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_R_mod_L._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_R_mod_L._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_cancel_mul_pow2_mod
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_pow2_mod.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%146 Bool)
(declare-const %%global_location_label%%147 Bool)
(assert
 (forall ((a! Int) (b! Int) (r_pow! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_pow2_mod. a! b! r_pow!)
    (and
     (=>
      %%global_location_label%%146
      (= r_pow! (vstd!arithmetic.power2.pow2.? (I 260)))
     )
     (=>
      %%global_location_label%%147
      (= (EucMod (nClip (Mul a! r_pow!)) (curve25519_dalek!specs.scalar52_specs.group_order.?
         (I 0)
        )
       ) (EucMod (nClip (Mul b! r_pow!)) (curve25519_dalek!specs.scalar52_specs.group_order.?
         (I 0)
   ))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_pow2_mod. a!
     b! r_pow!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_pow2_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_pow2_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_pow2_mod.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (r_pow! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_pow2_mod. a! b! r_pow!)
    (= (EucMod a! (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))) (EucMod
      b! (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_pow2_mod. a!
     b! r_pow!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_pow2_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_cancel_mul_pow2_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_neg_sum_mod
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_neg_sum_mod. (Int Int
  Int
 ) Bool
)
(declare-const %%global_location_label%%148 Bool)
(declare-const %%global_location_label%%149 Bool)
(assert
 (forall ((q! Int) (r! Int) (L! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_neg_sum_mod. q! r! L!) (and
     (=>
      %%global_location_label%%148
      (> L! 0)
     )
     (=>
      %%global_location_label%%149
      (let
       ((tmp%%$ r!))
       (and
        (<= 0 tmp%%$)
        (< tmp%%$ L!)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_neg_sum_mod. q! r! L!))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_neg_sum_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_neg_sum_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_neg_sum_mod. (Int Int
  Int
 ) Bool
)
(assert
 (forall ((q! Int) (r! Int) (L! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_neg_sum_mod. q! r! L!) (= (EucMod
      (Sub 0 (Add (Mul L! q!) r!)) L!
     ) (EucMod (Sub 0 r!) L!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_neg_sum_mod. q! r! L!))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_neg_sum_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_neg_sum_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_negation_sums_to_zero
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_negation_sums_to_zero.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%150 Bool)
(declare-const %%global_location_label%%151 Bool)
(declare-const %%global_location_label%%152 Bool)
(declare-const %%global_location_label%%153 Bool)
(assert
 (forall ((self_nat! Int) (congruent_to_self! Int) (result_nat! Int) (L! Int)) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_negation_sums_to_zero. self_nat!
     congruent_to_self! result_nat! L!
    ) (and
     (=>
      %%global_location_label%%150
      (> L! 0)
     )
     (=>
      %%global_location_label%%151
      (= (EucMod congruent_to_self! L!) (EucMod self_nat! L!))
     )
     (=>
      %%global_location_label%%152
      (= result_nat! (EucMod (Sub 0 congruent_to_self!) L!))
     )
     (=>
      %%global_location_label%%153
      (< result_nat! L!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_negation_sums_to_zero. self_nat!
     congruent_to_self! result_nat! L!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_negation_sums_to_zero._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_negation_sums_to_zero._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_negation_sums_to_zero.
 (Int Int Int Int) Bool
)
(assert
 (forall ((self_nat! Int) (congruent_to_self! Int) (result_nat! Int) (L! Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_negation_sums_to_zero. self_nat!
     congruent_to_self! result_nat! L!
    ) (= (EucMod (nClip (Add self_nat! result_nat!)) L!) 0)
   )
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_negation_sums_to_zero. self_nat!
     congruent_to_self! result_nat! L!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_negation_sums_to_zero._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_negation_sums_to_zero._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::to_nat_lemmas::lemma_canonical_bytes_equal
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
 (%%Function%% %%Function%%) Bool
)
(declare-const %%global_location_label%%154 Bool)
(assert
 (forall ((bytes1! %%Function%%) (bytes2! %%Function%%)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
    ) (=>
     %%global_location_label%%154
     (= (curve25519_dalek!specs.core_specs.u8_32_as_nat.? (Poly%array%. bytes1!)) (curve25519_dalek!specs.core_specs.u8_32_as_nat.?
       (Poly%array%. bytes2!)
   ))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
 (%%Function%% %%Function%%) Bool
)
(assert
 (forall ((bytes1! %%Function%%) (bytes2! %%Function%%)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
    ) (forall ((i$ Poly)) (!
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
           ) (Poly%array%. bytes1!)
          ) i$
         ) (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8) $ (CONST_INT
             32
            )
           ) (Poly%array%. bytes2!)
          ) i$
      ))))
      :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
          $ (CONST_INT 32)
         ) (Poly%array%. bytes1!)
        ) i$
      ))
      :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $ (ARRAY $ (UINT 8)
          $ (CONST_INT 32)
         ) (Poly%array%. bytes2!)
        ) i$
      ))
      :qid user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_canonical_bytes_equal_247
      :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__to_nat_lemmas__lemma_canonical_bytes_equal_247
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal.
     bytes1! bytes2!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.to_nat_lemmas.lemma_canonical_bytes_equal._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_square
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_square.
 (Int Int) Bool
)
(assert
 (forall ((v! Int) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_square. v! i!)
    (= (Mul (vstd!arithmetic.power.pow.? (I v!) (I (vstd!arithmetic.power2.pow2.? (I i!))))
      (vstd!arithmetic.power.pow.? (I v!) (I (vstd!arithmetic.power2.pow2.? (I i!))))
     ) (vstd!arithmetic.power.pow.? (I v!) (I (vstd!arithmetic.power2.pow2.? (I (nClip (Add
           i! 1
   ))))))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_square.
     v! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_square._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_square._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow_nonnegative
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative.
 (Int Int) Bool
)
(declare-const %%global_location_label%%155 Bool)
(assert
 (forall ((base! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nonnegative. base!
     n!
    ) (=>
     %%global_location_label%%155
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

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_r_limbs_bounded
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_limbs_bounded. (Int)
 Bool
)
(assert
 (forall ((no%param Int)) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_limbs_bounded. no%param) (and
     (< 4302102966953709 (uClip 64 (bitshl (I 1) (I 52))))
     (< 1049714374468698 (uClip 64 (bitshl (I 1) (I 52))))
     (< 4503599278581019 (uClip 64 (bitshl (I 1) (I 52))))
     (< 4503599627370495 (uClip 64 (bitshl (I 1) (I 52))))
     (< 17592186044415 (uClip 64 (bitshl (I 1) (I 52))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_r_limbs_bounded. no%param))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_r_limbs_bounded._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_r_limbs_bounded._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_limbs_bounded_implies_limbs_bounded_for_sub
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_limbs_bounded_for_sub.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(declare-const %%global_location_label%%156 Bool)
(declare-const %%global_location_label%%157 Bool)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_limbs_bounded_for_sub.
     a! b!
    ) (and
     (=>
      %%global_location_label%%156
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
     )))
     (=>
      %%global_location_label%%157
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        b!
   )))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_limbs_bounded_for_sub.
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_limbs_bounded_for_sub._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_limbs_bounded_for_sub._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_limbs_bounded_for_sub.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 Bool
)
(assert
 (forall ((a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.))
  (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_limbs_bounded_for_sub.
     a! b!
    ) (curve25519_dalek!specs.scalar52_specs.limbs_bounded_for_sub.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
      a!
     ) (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!)
   ))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_limbs_bounded_for_sub.
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_limbs_bounded_for_sub._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_limbs_bounded_implies_limbs_bounded_for_sub._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_conditional_add_l_correct
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_conditional_add_l_correct.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Bool
 ) Bool
)
(declare-const %%global_location_label%%158 Bool)
(declare-const %%global_location_label%%159 Bool)
(declare-const %%global_location_label%%160 Bool)
(declare-const %%global_location_label%%161 Bool)
(declare-const %%global_location_label%%162 Bool)
(declare-const %%global_location_label%%163 Bool)
(assert
 (forall ((self_now! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (carry! Int)
   (self_orig! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (is_adding! Bool)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_conditional_add_l_correct. self_now!
     carry! self_orig! is_adding!
    ) (and
     (=>
      %%global_location_label%%158
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        self_orig!
     )))
     (=>
      %%global_location_label%%159
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        self_now!
     )))
     (=>
      %%global_location_label%%160
      (< (uClip 64 (bitshr (I carry!) (I 52))) 2)
     )
     (=>
      %%global_location_label%%161
      (=>
       (not is_adding!)
       (= self_orig! self_now!)
     ))
     (=>
      %%global_location_label%%162
      (=>
       is_adding!
       (= (nClip (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
            $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
              (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. self_orig!)
             )))
            ) (I 0) (I 5)
           )
          ) (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
            $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
              (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.constants.L.?)
             )))
            ) (I 0) (I 5)
         )))
        ) (Add (curve25519_dalek!specs.scalar52_specs.seq_u64_as_nat.? (vstd!seq.Seq.subrange.?
           $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $ (CONST_INT 5)) (Poly%array%.
             (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. self_now!)
            )))
           ) (I 0) (I 5)
          )
         ) (Mul (uClip 64 (bitshr (I carry!) (I 52))) (vstd!arithmetic.power2.pow2.? (I (nClip
             (Mul 52 5)
     ))))))))
     (=>
      %%global_location_label%%163
      (=>
       (and
        (not is_adding!)
        (>= 5 1)
       )
       (= carry! (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT
             64
            ) $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               self_now!
           ))))
          ) (I 4)
   )))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_conditional_add_l_correct.
     self_now! carry! self_orig! is_adding!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_conditional_add_l_correct._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_conditional_add_l_correct._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_conditional_add_l_correct.
 (curve25519_dalek!backend.serial.u64.scalar.Scalar52. Int curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Bool
 ) Bool
)
(assert
 (forall ((self_now! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (carry! Int)
   (self_orig! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (is_adding! Bool)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_conditional_add_l_correct. self_now!
     carry! self_orig! is_adding!
    ) (and
     (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       self_now!
     ))
     (<= (uClip 64 (bitshr (I carry!) (I 52))) 1)
     (=>
      is_adding!
      (= (nClip (Add (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           self_now!
          )
         ) (nClip (Mul (uClip 64 (bitshr (I carry!) (I 52))) (vstd!arithmetic.power2.pow2.? (
             I 260
        )))))
       ) (nClip (Add (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           self_orig!
          )
         ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
     ))))
     (=>
      (not is_adding!)
      (= (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         self_now!
        )
       ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         self_orig!
     ))))
     (=>
      (not is_adding!)
      (= (uClip 64 (bitshr (I carry!) (I 52))) 0)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_conditional_add_l_correct.
     self_now! carry! self_orig! is_adding!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_conditional_add_l_correct._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_conditional_add_l_correct._definition
)))

;; Function-Specs curve25519_dalek::lemmas::scalar_lemmas::lemma_sub_new_correct
(declare-fun req%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_new_correct. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Int curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Int
 ) Bool
)
(declare-const %%global_location_label%%164 Bool)
(declare-const %%global_location_label%%165 Bool)
(declare-const %%global_location_label%%166 Bool)
(declare-const %%global_location_label%%167 Bool)
(declare-const %%global_location_label%%168 Bool)
(declare-const %%global_location_label%%169 Bool)
(declare-const %%global_location_label%%170 Bool)
(declare-const %%global_location_label%%171 Bool)
(declare-const %%global_location_label%%172 Bool)
(assert
 (forall ((result! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (carry! Int)
   (a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (borrow! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_new_correct. result! carry!
     a! b! borrow!
    ) (and
     (=>
      %%global_location_label%%164
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
     )))
     (=>
      %%global_location_label%%165
      (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        b!
     )))
     (=>
      %%global_location_label%%166
      (let
       ((tmp%%$ (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            a!
           )
          ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            b!
       )))))
       (and
        (<= (Sub 0 (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))) tmp%%$)
        (< tmp%%$ (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)))
     )))
     (=>
      %%global_location_label%%167
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
          (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
               (CONST_INT 5)
              ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
                (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  result!
              ))))
             ) j$
            )
           ) (uClip 64 (bitshl (I 1) (I 52)))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
            $ (CONST_INT 5)
           ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
             (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               result!
           ))))
          ) j$
        ))
        :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_sub_new_correct_248
        :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_sub_new_correct_248
     )))
     (=>
      %%global_location_label%%168
      (<= (uClip 64 (bitshr (I carry!) (I 52))) 1)
     )
     (=>
      %%global_location_label%%169
      (or
       (= (uClip 64 (bitshr (I borrow!) (I 63))) 0)
       (= (uClip 64 (bitshr (I borrow!) (I 63))) 1)
     ))
     (=>
      %%global_location_label%%170
      (=>
       (= (uClip 64 (bitshr (I borrow!) (I 63))) 0)
       (= (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           a!
          )
         ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           b!
         ))
        ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
          result!
     )))))
     (=>
      %%global_location_label%%171
      (=>
       (= (uClip 64 (bitshr (I borrow!) (I 63))) 1)
       (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
          a!
         )
        ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
          b!
     )))))
     (=>
      %%global_location_label%%172
      (=>
       (= (uClip 64 (bitshr (I borrow!) (I 63))) 1)
       (= (nClip (Add (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            result!
           )
          ) (nClip (Mul (uClip 64 (bitshr (I carry!) (I 52))) (vstd!arithmetic.power2.pow2.? (
              I 260
         )))))
        ) (Add (Add (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             a!
            )
           ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             b!
           ))
          ) (vstd!arithmetic.power2.pow2.? (I 260))
         ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   ))))))
   :pattern ((req%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_new_correct. result!
     carry! a! b! borrow!
   ))
   :qid internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_new_correct._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_new_correct._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_new_correct. (curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Int curve25519_dalek!backend.serial.u64.scalar.Scalar52. curve25519_dalek!backend.serial.u64.scalar.Scalar52.
  Int
 ) Bool
)
(assert
 (forall ((result! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (carry! Int)
   (a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.) (b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
   (borrow! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_new_correct. result! carry!
     a! b! borrow!
    ) (= (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       result!
      )
     ) (EucMod (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         a!
        )
       ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         b!
       ))
      ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_new_correct. result!
     carry! a! b! borrow!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_new_correct._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.scalar_lemmas.lemma_sub_new_correct._definition
)))

;; Function-Def curve25519_dalek::lemmas::scalar_lemmas::lemma_sub_new_correct
;; curve25519-dalek/src/lemmas/scalar_lemmas.rs:2065:1: 2071:2 (#0)
(get-info :all-statistics)
(push)
 (declare-const result! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 (declare-const carry! Int)
 (declare-const a! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 (declare-const b! curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 (declare-const borrow! Int)
 (declare-const tmp%1 Bool)
 (declare-const tmp%2 Bool)
 (declare-const tmp%3 Bool)
 (declare-const tmp%4 Int)
 (declare-const tmp%5 Int)
 (declare-const tmp%6 Bool)
 (declare-const tmp%7 Bool)
 (declare-const tmp%8 Bool)
 (declare-const tmp%9 Bool)
 (declare-const tmp%10 Bool)
 (declare-const tmp%11 Bool)
 (declare-const tmp%12 Int)
 (declare-const tmp%13 Int)
 (declare-const tmp%14 Int)
 (declare-const tmp%15 Bool)
 (declare-const a_nat@ Int)
 (declare-const b_nat@ Int)
 (declare-const r_nat@ Int)
 (declare-const carry_top@ Int)
 (assert
  fuel_defaults
 )
 (assert
  (has_type (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. result!) TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 )
 (assert
  (uInv 64 carry!)
 )
 (assert
  (has_type (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. a!) TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 )
 (assert
  (has_type (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. b!) TYPE%curve25519_dalek!backend.serial.u64.scalar.Scalar52.)
 )
 (assert
  (uInv 64 borrow!)
 )
 (assert
  (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
    a!
 )))
 (assert
  (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
    b!
 )))
 (assert
  (let
   ((tmp%%$ (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        a!
       )
      ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        b!
   )))))
   (and
    (<= (Sub 0 (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))) tmp%%$)
    (< tmp%%$ (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)))
 )))
 (assert
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
      (< (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64) $
           (CONST_INT 5)
          ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
            (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              result!
          ))))
         ) j$
        )
       ) (uClip 64 (bitshl (I 1) (I 52)))
    )))
    :pattern ((vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $ (ARRAY $ (UINT 64)
        $ (CONST_INT 5)
       ) (Poly%array%. (curve25519_dalek!backend.serial.u64.scalar.Scalar52./Scalar52/limbs
         (%Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52. (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           result!
       ))))
      ) j$
    ))
    :qid user_curve25519_dalek__lemmas__scalar_lemmas__lemma_sub_new_correct_252
    :skolemid skolem_user_curve25519_dalek__lemmas__scalar_lemmas__lemma_sub_new_correct_252
 )))
 (assert
  (<= (uClip 64 (bitshr (I carry!) (I 52))) 1)
 )
 (assert
  (or
   (= (uClip 64 (bitshr (I borrow!) (I 63))) 0)
   (= (uClip 64 (bitshr (I borrow!) (I 63))) 1)
 ))
 (assert
  (=>
   (= (uClip 64 (bitshr (I borrow!) (I 63))) 0)
   (= (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       a!
      )
     ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
       b!
     ))
    ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
      result!
 )))))
 (assert
  (=>
   (= (uClip 64 (bitshr (I borrow!) (I 63))) 1)
   (< (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
      a!
     )
    ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
      b!
 )))))
 (assert
  (=>
   (= (uClip 64 (bitshr (I borrow!) (I 63))) 1)
   (= (nClip (Add (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
        result!
       )
      ) (nClip (Mul (uClip 64 (bitshr (I carry!) (I 52))) (vstd!arithmetic.power2.pow2.? (
          I 260
     )))))
    ) (Add (Add (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         a!
        )
       ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
         b!
       ))
      ) (vstd!arithmetic.power2.pow2.? (I 260))
     ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
 ))))
 (declare-const %%switch_label%%0 Bool)
 (declare-const %%switch_label%%1 Bool)
 (declare-const %%switch_label%%2 Bool)
 ;; assertion failed
 (declare-const %%location_label%%0 Bool)
 ;; assertion failed
 (declare-const %%location_label%%1 Bool)
 ;; assertion failed
 (declare-const %%location_label%%2 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%3 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%4 Bool)
 ;; assertion failed
 (declare-const %%location_label%%5 Bool)
 ;; assertion failed
 (declare-const %%location_label%%6 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%7 Bool)
 ;; assertion failed
 (declare-const %%location_label%%8 Bool)
 ;; assertion failed
 (declare-const %%location_label%%9 Bool)
 ;; assertion failed
 (declare-const %%location_label%%10 Bool)
 ;; assertion failed
 (declare-const %%location_label%%11 Bool)
 ;; assertion failed
 (declare-const %%location_label%%12 Bool)
 ;; assertion failed
 (declare-const %%location_label%%13 Bool)
 ;; assertion failed
 (declare-const %%location_label%%14 Bool)
 ;; assertion failed
 (declare-const %%location_label%%15 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%16 Bool)
 ;; precondition not satisfied
 (declare-const %%location_label%%17 Bool)
 ;; assertion failed
 (declare-const %%location_label%%18 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%19 Bool)
 (assert
  (not (or
    (and
     (=>
      (= (uClip 64 (bitshr (I borrow!) (I 63))) 0)
      (=>
       (= tmp%1 (= (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           result!
          )
         ) (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            a!
           )
          ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            b!
       )))))
       (and
        (=>
         %%location_label%%0
         tmp%1
        )
        (=>
         tmp%1
         (=>
          (= tmp%2 (>= (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               a!
              )
             ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
               b!
             ))
            ) 0
          ))
          (and
           (=>
            %%location_label%%1
            tmp%2
           )
           (=>
            tmp%2
            (=>
             (= tmp%3 (< (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  a!
                 )
                ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  b!
                ))
               ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
             ))
             (and
              (=>
               %%location_label%%2
               tmp%3
              )
              (=>
               tmp%3
               (=>
                (= tmp%4 (nClip (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                     a!
                    )
                   ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                     b!
                )))))
                (=>
                 (= tmp%5 (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)))
                 (and
                  (=>
                   %%location_label%%3
                   (req%vstd!arithmetic.div_mod.lemma_small_mod. tmp%4 tmp%5)
                  )
                  (=>
                   (ens%vstd!arithmetic.div_mod.lemma_small_mod. tmp%4 tmp%5)
                   %%switch_label%%2
     ))))))))))))))
     (=>
      (not (= (uClip 64 (bitshr (I borrow!) (I 63))) 0))
      %%switch_label%%2
    ))
    (and
     (not %%switch_label%%2)
     (or
      (and
       (=>
        (= (uClip 64 (bitshr (I borrow!) (I 63))) 1)
        (=>
         (= a_nat@ (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
            a!
         )))
         (=>
          (= b_nat@ (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             b!
          )))
          (=>
           (= r_nat@ (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
              result!
           )))
           (=>
            (= carry_top@ (uClip 64 (bitshr (I carry!) (I 52))))
            (and
             (and
              (and
               (=>
                %%location_label%%4
                (req%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2. 52)
               )
               (=>
                (ens%curve25519_dalek!lemmas.common_lemmas.shift_lemmas.lemma_u64_shift_is_pow2. 52)
                (=>
                 %%location_label%%5
                 (= (uClip 64 (bitshl (I 1) (I 52))) (vstd!arithmetic.power2.pow2.? (I 52)))
              )))
              (=>
               (= (uClip 64 (bitshl (I 1) (I 52))) (vstd!arithmetic.power2.pow2.? (I 52)))
               (=>
                %%location_label%%6
                (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                  result!
             )))))
             (=>
              (curve25519_dalek!specs.scalar52_specs.limbs_bounded.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
                result!
              ))
              (and
               (=>
                %%location_label%%7
                (req%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. result!)
               )
               (=>
                (ens%curve25519_dalek!lemmas.scalar_lemmas.lemma_bound_scalar. result!)
                (=>
                 (= tmp%6 (< r_nat@ (vstd!arithmetic.power2.pow2.? (I 260))))
                 (and
                  (=>
                   %%location_label%%8
                   tmp%6
                  )
                  (=>
                   tmp%6
                   (and
                    (or
                     (and
                      (=>
                       (= carry_top@ 0)
                       (=>
                        (= tmp%7 (= r_nat@ (Add (Add (Sub a_nat@ b_nat@) (vstd!arithmetic.power2.pow2.? (I 260)))
                           (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
                        )))
                        (and
                         (=>
                          %%location_label%%9
                          tmp%7
                         )
                         (=>
                          tmp%7
                          (=>
                           %%location_label%%10
                           false
                      )))))
                      (=>
                       (not (= carry_top@ 0))
                       %%switch_label%%1
                     ))
                     (and
                      (not %%switch_label%%1)
                      (=>
                       %%location_label%%11
                       (= carry_top@ 1)
                    )))
                    (=>
                     (= carry_top@ 1)
                     (=>
                      (= tmp%8 (= r_nat@ (Add (Sub a_nat@ b_nat@) (curve25519_dalek!specs.scalar52_specs.group_order.?
                          (I 0)
                      ))))
                      (and
                       (=>
                        %%location_label%%12
                        tmp%8
                       )
                       (=>
                        tmp%8
                        (=>
                         (= tmp%9 (< a_nat@ b_nat@))
                         (and
                          (=>
                           %%location_label%%13
                           tmp%9
                          )
                          (=>
                           tmp%9
                           (=>
                            (= tmp%10 (<= 0 (Add (Sub a_nat@ b_nat@) (curve25519_dalek!specs.scalar52_specs.group_order.?
                                (I 0)
                            ))))
                            (and
                             (=>
                              %%location_label%%14
                              tmp%10
                             )
                             (=>
                              tmp%10
                              (=>
                               (= tmp%11 (< (Add (Sub a_nat@ b_nat@) (curve25519_dalek!specs.scalar52_specs.group_order.?
                                   (I 0)
                                  )
                                 ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
                               ))
                               (and
                                (=>
                                 %%location_label%%15
                                 tmp%11
                                )
                                (=>
                                 tmp%11
                                 (=>
                                  (= tmp%12 (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)))
                                  (and
                                   (=>
                                    %%location_label%%16
                                    (req%vstd!arithmetic.div_mod.lemma_small_mod. r_nat@ tmp%12)
                                   )
                                   (=>
                                    (ens%vstd!arithmetic.div_mod.lemma_small_mod. r_nat@ tmp%12)
                                    (=>
                                     (= tmp%13 (Sub a_nat@ b_nat@))
                                     (=>
                                      (= tmp%14 (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0)))
                                      (and
                                       (=>
                                        %%location_label%%17
                                        (req%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. tmp%13 tmp%14)
                                       )
                                       (=>
                                        (ens%vstd!arithmetic.div_mod.lemma_mod_add_multiples_vanish. tmp%13 tmp%14)
                                        (=>
                                         (= tmp%15 (= r_nat@ (EucMod (Sub a_nat@ b_nat@) (curve25519_dalek!specs.scalar52_specs.group_order.?
                                             (I 0)
                                         ))))
                                         (and
                                          (=>
                                           %%location_label%%18
                                           tmp%15
                                          )
                                          (=>
                                           tmp%15
                                           %%switch_label%%0
       ))))))))))))))))))))))))))))))))))))
       (=>
        (not (= (uClip 64 (bitshr (I borrow!) (I 63))) 1))
        %%switch_label%%0
      ))
      (and
       (not %%switch_label%%0)
       (=>
        %%location_label%%19
        (= (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
           result!
          )
         ) (EucMod (Sub (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             a!
            )
           ) (curve25519_dalek!specs.scalar52_specs.scalar52_as_nat.? (Poly%curve25519_dalek!backend.serial.u64.scalar.Scalar52.
             b!
           ))
          ) (curve25519_dalek!specs.scalar52_specs.group_order.? (I 0))
 )))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
