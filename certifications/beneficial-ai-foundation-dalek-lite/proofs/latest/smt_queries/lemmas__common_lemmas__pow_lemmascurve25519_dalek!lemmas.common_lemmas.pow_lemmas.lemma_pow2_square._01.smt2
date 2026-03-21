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

;; MODULE 'module lemmas::common_lemmas::pow_lemmas'
;; curve25519-dalek/src/lemmas/common_lemmas/pow_lemmas.rs:135:1: 135:47 (#0)

;; query spun off because: spinoff_all

;; Fuel
(declare-const fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_denominator. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_multiples_vanish. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered.
 FuelId
)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_self_0. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_twice. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_bound. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.div_mod.lemma_mod_mod. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_basics_3. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_associative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_commutative. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_inequality. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_equality_converse. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way. FuelId)
(declare-const fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow0. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow1. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma0_pow. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_positive. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_adds. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_multiplies. FuelId)
(declare-const fuel%vstd!arithmetic.power.lemma_pow_mod_noop. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_pos. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_unfold. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_adds. FuelId)
(declare-const fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases. FuelId)
(declare-const fuel%vstd!raw_ptr.impl&%3.view. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq. FuelId)
(declare-const fuel%vstd!raw_ptr.ptrs_mut_eq_sized. FuelId)
(declare-const fuel%vstd!seq.impl&%0.spec_index. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_index_decreases. FuelId)
(declare-const fuel%vstd!seq.axiom_seq_empty. FuelId)
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
(declare-const fuel%vstd!view.impl&%16.view. FuelId)
(declare-const fuel%vstd!view.impl&%18.view. FuelId)
(declare-const fuel%vstd!view.impl&%20.view. FuelId)
(declare-const fuel%vstd!view.impl&%22.view. FuelId)
(declare-const fuel%vstd!view.impl&%24.view. FuelId)
(declare-const fuel%vstd!view.impl&%26.view. FuelId)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_mod_is_id.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u16_times_pow2_mod_is_id.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u32_times_pow2_mod_is_id.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_times_pow2_mod_is_id.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_times_pow2_mod_is_id.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.
 FuelId
)
(declare-const fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.
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
 (distinct fuel%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. fuel%vstd!arithmetic.div_mod.lemma_div_denominator.
  fuel%vstd!arithmetic.div_mod.lemma_div_multiples_vanish. fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple.
  fuel%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered. fuel%vstd!arithmetic.div_mod.lemma_multiply_divide_lt.
  fuel%vstd!arithmetic.div_mod.lemma_mod_self_0. fuel%vstd!arithmetic.div_mod.lemma_mod_twice.
  fuel%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. fuel%vstd!arithmetic.div_mod.lemma_add_mod_noop.
  fuel%vstd!arithmetic.div_mod.lemma_mod_bound. fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right.
  fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop.
  fuel%vstd!arithmetic.div_mod.lemma_mod_mod. fuel%vstd!arithmetic.mul.lemma_mul_basics_3.
  fuel%vstd!arithmetic.mul.lemma_mul_is_associative. fuel%vstd!arithmetic.mul.lemma_mul_is_commutative.
  fuel%vstd!arithmetic.mul.lemma_mul_inequality. fuel%vstd!arithmetic.mul.lemma_mul_equality_converse.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add. fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_add_other_way.
  fuel%vstd!arithmetic.mul.lemma_mul_is_distributive_sub. fuel%vstd!arithmetic.power.lemma_pow0.
  fuel%vstd!arithmetic.power.lemma_pow1. fuel%vstd!arithmetic.power.lemma0_pow. fuel%vstd!arithmetic.power.lemma_pow_positive.
  fuel%vstd!arithmetic.power.lemma_pow_adds. fuel%vstd!arithmetic.power.lemma_pow_multiplies.
  fuel%vstd!arithmetic.power.lemma_pow_mod_noop. fuel%vstd!arithmetic.power2.lemma_pow2_pos.
  fuel%vstd!arithmetic.power2.lemma_pow2_unfold. fuel%vstd!arithmetic.power2.lemma_pow2_adds.
  fuel%vstd!arithmetic.power2.lemma_pow2_strictly_increases. fuel%vstd!raw_ptr.impl&%3.view.
  fuel%vstd!raw_ptr.ptrs_mut_eq. fuel%vstd!raw_ptr.ptrs_mut_eq_sized. fuel%vstd!seq.impl&%0.spec_index.
  fuel%vstd!seq.axiom_seq_index_decreases. fuel%vstd!seq.axiom_seq_empty. fuel%vstd!seq.axiom_seq_push_len.
  fuel%vstd!seq.axiom_seq_push_index_same. fuel%vstd!seq.axiom_seq_push_index_different.
  fuel%vstd!seq.axiom_seq_ext_equal. fuel%vstd!seq.axiom_seq_ext_equal_deep. fuel%vstd!slice.impl&%2.spec_index.
  fuel%vstd!slice.axiom_spec_len. fuel%vstd!slice.axiom_slice_ext_equal. fuel%vstd!slice.axiom_slice_has_resolved.
  fuel%vstd!view.impl&%0.view. fuel%vstd!view.impl&%2.view. fuel%vstd!view.impl&%4.view.
  fuel%vstd!view.impl&%6.view. fuel%vstd!view.impl&%12.view. fuel%vstd!view.impl&%14.view.
  fuel%vstd!view.impl&%16.view. fuel%vstd!view.impl&%18.view. fuel%vstd!view.impl&%20.view.
  fuel%vstd!view.impl&%22.view. fuel%vstd!view.impl&%24.view. fuel%vstd!view.impl&%26.view.
  fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_mod_is_id.
  fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u16_times_pow2_mod_is_id.
  fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u32_times_pow2_mod_is_id.
  fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_times_pow2_mod_is_id.
  fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_times_pow2_mod_is_id.
  fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8. fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.
  fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32. fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.
  fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128. fuel%vstd!array.group_array_axioms.
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
(declare-sort slice%<u8.>. 0)
(declare-sort slice%<u16.>. 0)
(declare-sort slice%<u32.>. 0)
(declare-sort slice%<u64.>. 0)
(declare-sort slice%<u128.>. 0)
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
(declare-const TYPE%vstd!raw_ptr.Provenance. Type)
(declare-fun TYPE%vstd!raw_ptr.PtrData. (Dcr Type) Type)
(declare-fun TYPE%vstd!seq.Seq. (Dcr Type) Type)
(declare-fun Poly%vstd!raw_ptr.Provenance. (vstd!raw_ptr.Provenance.) Poly)
(declare-fun %Poly%vstd!raw_ptr.Provenance. (Poly) vstd!raw_ptr.Provenance.)
(declare-fun Poly%slice%<u8.>. (slice%<u8.>.) Poly)
(declare-fun %Poly%slice%<u8.>. (Poly) slice%<u8.>.)
(declare-fun Poly%slice%<u16.>. (slice%<u16.>.) Poly)
(declare-fun %Poly%slice%<u16.>. (Poly) slice%<u16.>.)
(declare-fun Poly%slice%<u32.>. (slice%<u32.>.) Poly)
(declare-fun %Poly%slice%<u32.>. (Poly) slice%<u32.>.)
(declare-fun Poly%slice%<u64.>. (slice%<u64.>.) Poly)
(declare-fun %Poly%slice%<u64.>. (Poly) slice%<u64.>.)
(declare-fun Poly%slice%<u128.>. (slice%<u128.>.) Poly)
(declare-fun %Poly%slice%<u128.>. (Poly) slice%<u128.>.)
(declare-fun Poly%allocator_global%. (allocator_global%.) Poly)
(declare-fun %Poly%allocator_global%. (Poly) allocator_global%.)
(declare-fun Poly%vstd!raw_ptr.PtrData. (vstd!raw_ptr.PtrData.) Poly)
(declare-fun %Poly%vstd!raw_ptr.PtrData. (Poly) vstd!raw_ptr.PtrData.)
(declare-fun Poly%tuple%0. (tuple%0.) Poly)
(declare-fun %Poly%tuple%0. (Poly) tuple%0.)
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
 (forall ((x slice%<u16.>.)) (!
   (= x (%Poly%slice%<u16.>. (Poly%slice%<u16.>. x)))
   :pattern ((Poly%slice%<u16.>. x))
   :qid internal_crate__slice__<u16.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<u16.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ (UINT 16)))
    (= x (Poly%slice%<u16.>. (%Poly%slice%<u16.>. x)))
   )
   :pattern ((has_type x (SLICE $ (UINT 16))))
   :qid internal_crate__slice__<u16.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<u16.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<u16.>.)) (!
   (has_type (Poly%slice%<u16.>. x) (SLICE $ (UINT 16)))
   :pattern ((has_type (Poly%slice%<u16.>. x) (SLICE $ (UINT 16))))
   :qid internal_crate__slice__<u16.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<u16.>_has_type_always_definition
)))
(assert
 (forall ((x slice%<u32.>.)) (!
   (= x (%Poly%slice%<u32.>. (Poly%slice%<u32.>. x)))
   :pattern ((Poly%slice%<u32.>. x))
   :qid internal_crate__slice__<u32.>_box_axiom_definition
   :skolemid skolem_internal_crate__slice__<u32.>_box_axiom_definition
)))
(assert
 (forall ((x Poly)) (!
   (=>
    (has_type x (SLICE $ (UINT 32)))
    (= x (Poly%slice%<u32.>. (%Poly%slice%<u32.>. x)))
   )
   :pattern ((has_type x (SLICE $ (UINT 32))))
   :qid internal_crate__slice__<u32.>_unbox_axiom_definition
   :skolemid skolem_internal_crate__slice__<u32.>_unbox_axiom_definition
)))
(assert
 (forall ((x slice%<u32.>.)) (!
   (has_type (Poly%slice%<u32.>. x) (SLICE $ (UINT 32)))
   :pattern ((has_type (Poly%slice%<u32.>. x) (SLICE $ (UINT 32))))
   :qid internal_crate__slice__<u32.>_has_type_always_definition
   :skolemid skolem_internal_crate__slice__<u32.>_has_type_always_definition
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

;; Trait-Bounds
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

;; Function-Decl vstd::seq::Seq::len
(declare-fun vstd!seq.Seq.len.? (Dcr Type Poly) Int)

;; Function-Decl vstd::seq::Seq::index
(declare-fun vstd!seq.Seq.index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::impl&%0::spec_index
(declare-fun vstd!seq.impl&%0.spec_index.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::seq::Seq::empty
(declare-fun vstd!seq.Seq.empty.? (Dcr Type) Poly)

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

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq
(declare-fun vstd!raw_ptr.view_reverse_for_eq.? (Dcr Type Poly) Poly)

;; Function-Decl vstd::raw_ptr::view_reverse_for_eq_sized
(declare-fun vstd!raw_ptr.view_reverse_for_eq_sized.? (Dcr Type Poly Poly) Poly)

;; Function-Decl vstd::arithmetic::power::pow
(declare-fun vstd!arithmetic.power.pow.? (Poly Poly) Int)

;; Function-Decl vstd::arithmetic::power2::pow2
(declare-fun vstd!arithmetic.power2.pow2.? (Poly) Int)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_sum_u8
(declare-fun curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.? (Poly Poly
  Poly Poly
 ) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u8.? (Poly
  Poly Poly Poly Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_sum_u16
(declare-fun curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.? (Poly
  Poly Poly Poly
 ) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u16.? (
  Poly Poly Poly Poly Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_sum_u32
(declare-fun curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.? (Poly
  Poly Poly Poly
 ) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u32.? (
  Poly Poly Poly Poly Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_sum_u64
(declare-fun curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.? (Poly
  Poly Poly Poly
 ) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u64.? (
  Poly Poly Poly Poly Fuel
 ) Int
)

;; Function-Decl curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_sum_u128
(declare-fun curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.? (Poly
  Poly Poly Poly
 ) Int
)
(declare-fun curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u128.?
 (Poly Poly Poly Poly Fuel) Int
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
    :qid user_vstd__seq__axiom_seq_push_len_2
    :skolemid skolem_user_vstd__seq__axiom_seq_push_len_2
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
    :qid user_vstd__seq__axiom_seq_push_index_same_3
    :skolemid skolem_user_vstd__seq__axiom_seq_push_index_same_3
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
    :qid user_vstd__seq__axiom_seq_push_index_different_4
    :skolemid skolem_user_vstd__seq__axiom_seq_push_index_different_4
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
          :qid user_vstd__seq__axiom_seq_ext_equal_5
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_5
    ))))))
    :pattern ((ext_eq false (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_6
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_6
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
          :qid user_vstd__seq__axiom_seq_ext_equal_deep_7
          :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_7
    ))))))
    :pattern ((ext_eq true (TYPE%vstd!seq.Seq. A&. A&) s1! s2!))
    :qid user_vstd__seq__axiom_seq_ext_equal_deep_8
    :skolemid skolem_user_vstd__seq__axiom_seq_ext_equal_deep_8
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
    :qid user_vstd__slice__axiom_spec_len_9
    :skolemid skolem_user_vstd__slice__axiom_spec_len_9
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
          :qid user_vstd__slice__axiom_slice_ext_equal_10
          :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_10
    ))))))
    :pattern ((ext_eq false (SLICE T&. T&) a1! a2!))
    :qid user_vstd__slice__axiom_slice_ext_equal_11
    :skolemid skolem_user_vstd__slice__axiom_slice_ext_equal_11
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
    :qid user_vstd__slice__axiom_slice_has_resolved_12
    :skolemid skolem_user_vstd__slice__axiom_slice_has_resolved_12
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_13
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_13
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
    :qid user_vstd__raw_ptr__ptrs_mut_eq_sized_14
    :skolemid skolem_user_vstd__raw_ptr__ptrs_mut_eq_sized_14
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_small_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_small_mod. (Int Int) Bool)
(declare-const %%global_location_label%%3 Bool)
(declare-const %%global_location_label%%4 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_small_mod. x! m!) (and
     (=>
      %%global_location_label%%3
      (< x! m!)
     )
     (=>
      %%global_location_label%%4
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
(declare-const %%global_location_label%%5 Bool)
(assert
 (forall ((x! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_fundamental_div_mod. x! d!) (=>
     %%global_location_label%%5
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
    :qid user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_15
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_fundamental_div_mod_15
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_denominator
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_denominator. (Int Int Int) Bool)
(declare-const %%global_location_label%%6 Bool)
(declare-const %%global_location_label%%7 Bool)
(declare-const %%global_location_label%%8 Bool)
(assert
 (forall ((x! Int) (c! Int) (d! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_denominator. x! c! d!) (and
     (=>
      %%global_location_label%%6
      (<= 0 x!)
     )
     (=>
      %%global_location_label%%7
      (< 0 c!)
     )
     (=>
      %%global_location_label%%8
      (< 0 d!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_div_denominator. x! c! d!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_div_denominator._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_div_denominator._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_div_denominator. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (c! Int) (d! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_div_denominator. x! c! d!) (and
     (not (= (Mul c! d!) 0))
     (= (EucDiv (EucDiv x! c!) d!) (EucDiv x! (Mul c! d!)))
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_div_denominator. x! c! d!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_div_denominator._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_div_denominator._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_div_denominator
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_div_denominator.)
  (forall ((x! Int) (c! Int) (d! Int)) (!
    (=>
     (and
      (and
       (<= 0 x!)
       (< 0 c!)
      )
      (< 0 d!)
     )
     (and
      (not (= (Mul c! d!) 0))
      (= (EucDiv (EucDiv x! c!) d!) (EucDiv x! (Mul c! d!)))
    ))
    :pattern ((EucDiv (EucDiv x! c!) d!))
    :qid user_vstd__arithmetic__div_mod__lemma_div_denominator_16
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_denominator_16
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_truncate_middle
(declare-fun req%vstd!arithmetic.div_mod.lemma_truncate_middle. (Int Int Int) Bool)
(declare-const %%global_location_label%%9 Bool)
(declare-const %%global_location_label%%10 Bool)
(declare-const %%global_location_label%%11 Bool)
(assert
 (forall ((x! Int) (b! Int) (c! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_truncate_middle. x! b! c!) (and
     (=>
      %%global_location_label%%9
      (<= 0 x!)
     )
     (=>
      %%global_location_label%%10
      (< 0 b!)
     )
     (=>
      %%global_location_label%%11
      (< 0 c!)
   )))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_truncate_middle. x! b! c!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_truncate_middle._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_truncate_middle._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_truncate_middle. (Int Int Int) Bool)
(assert
 (forall ((x! Int) (b! Int) (c! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_truncate_middle. x! b! c!) (and
     (< 0 (Mul b! c!))
     (= (EucMod (Mul b! x!) (Mul b! c!)) (Mul b! (EucMod x! c!)))
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_truncate_middle. x! b! c!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_truncate_middle._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_truncate_middle._definition
)))

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
    :qid user_vstd__arithmetic__div_mod__lemma_div_multiples_vanish_17
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_multiples_vanish_17
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
    :qid user_vstd__arithmetic__div_mod__lemma_div_by_multiple_18
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_by_multiple_18
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_div_by_multiple_is_strongly_ordered
(declare-fun req%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%15 Bool)
(declare-const %%global_location_label%%16 Bool)
(declare-const %%global_location_label%%17 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_div_by_multiple_is_strongly_ordered. x! y! m!
     z!
    ) (and
     (=>
      %%global_location_label%%15
      (< x! y!)
     )
     (=>
      %%global_location_label%%16
      (= y! (Mul m! z!))
     )
     (=>
      %%global_location_label%%17
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
    :qid user_vstd__arithmetic__div_mod__lemma_div_by_multiple_is_strongly_ordered_19
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_div_by_multiple_is_strongly_ordered_19
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_multiply_divide_lt
(declare-fun req%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. (Int Int Int) Bool)
(declare-const %%global_location_label%%18 Bool)
(declare-const %%global_location_label%%19 Bool)
(assert
 (forall ((a! Int) (b! Int) (c! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_multiply_divide_lt. a! b! c!) (and
     (=>
      %%global_location_label%%18
      (< 0 b!)
     )
     (=>
      %%global_location_label%%19
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
    :qid user_vstd__arithmetic__div_mod__lemma_multiply_divide_lt_20
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_multiply_divide_lt_20
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_self_0
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_self_0. (Int) Bool)
(declare-const %%global_location_label%%20 Bool)
(assert
 (forall ((m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_self_0. m!) (=>
     %%global_location_label%%20
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_self_0_21
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_self_0_21
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_twice
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_twice. (Int Int) Bool)
(declare-const %%global_location_label%%21 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_twice. x! m!) (=>
     %%global_location_label%%21
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_twice_22
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_twice_22
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_multiples_basic
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. (Int Int) Bool)
(declare-const %%global_location_label%%22 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_multiples_basic. x! m!) (=>
     %%global_location_label%%22
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_multiples_basic_23
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_multiples_basic_23
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_add_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_add_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%23 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_add_mod_noop. x! y! m!) (=>
     %%global_location_label%%23
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
    :qid user_vstd__arithmetic__div_mod__lemma_add_mod_noop_24
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_add_mod_noop_24
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_bound
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_bound. (Int Int) Bool)
(declare-const %%global_location_label%%24 Bool)
(assert
 (forall ((x! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_bound. x! m!) (=>
     %%global_location_label%%24
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_bound_25
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_bound_25
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_right
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. (Int Int Int) Bool)
(declare-const %%global_location_label%%25 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_right. x! y! m!) (=>
     %%global_location_label%%25
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_26
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_right_26
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop_general
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. (Int Int Int)
 Bool
)
(declare-const %%global_location_label%%26 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. x! y! m!) (=>
     %%global_location_label%%26
     (< 0 m!)
   ))
   :pattern ((req%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. x! y! m!))
   :qid internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_general._definition
   :skolemid skolem_internal_req__vstd!arithmetic.div_mod.lemma_mul_mod_noop_general._definition
)))
(declare-fun ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. (Int Int Int)
 Bool
)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. x! y! m!) (and
     (= (EucMod (Mul (EucMod x! m!) y!) m!) (EucMod (Mul x! y!) m!))
     (= (EucMod (Mul x! (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
     (= (EucMod (Mul (EucMod x! m!) (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
   ))
   :pattern ((ens%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general. x! y! m!))
   :qid internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_general._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.div_mod.lemma_mul_mod_noop_general._definition
)))

;; Broadcast vstd::arithmetic::div_mod::lemma_mul_mod_noop_general
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.div_mod.lemma_mul_mod_noop_general.)
  (forall ((x! Int) (y! Int) (m! Int)) (!
    (=>
     (< 0 m!)
     (and
      (and
       (= (EucMod (Mul (EucMod x! m!) y!) m!) (EucMod (Mul x! y!) m!))
       (= (EucMod (Mul x! (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
      )
      (= (EucMod (Mul (EucMod x! m!) (EucMod y! m!)) m!) (EucMod (Mul x! y!) m!))
    ))
    :pattern ((EucMod (Mul x! y!) m!))
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_general_27
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_general_27
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mul_mod_noop
(declare-fun req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%27 Bool)
(assert
 (forall ((x! Int) (y! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mul_mod_noop. x! y! m!) (=>
     %%global_location_label%%27
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
    :qid user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_28
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mul_mod_noop_28
))))

;; Function-Specs vstd::arithmetic::div_mod::lemma_mod_mod
(declare-fun req%vstd!arithmetic.div_mod.lemma_mod_mod. (Int Int Int) Bool)
(declare-const %%global_location_label%%28 Bool)
(declare-const %%global_location_label%%29 Bool)
(assert
 (forall ((x! Int) (a! Int) (b! Int)) (!
   (= (req%vstd!arithmetic.div_mod.lemma_mod_mod. x! a! b!) (and
     (=>
      %%global_location_label%%28
      (< 0 a!)
     )
     (=>
      %%global_location_label%%29
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
    :qid user_vstd__arithmetic__div_mod__lemma_mod_mod_29
    :skolemid skolem_user_vstd__arithmetic__div_mod__lemma_mod_mod_29
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
    :qid user_vstd__arithmetic__mul__lemma_mul_basics_3_30
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_basics_3_30
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_associative_31
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_associative_31
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_commutative_32
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_commutative_32
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_inequality
(declare-fun req%vstd!arithmetic.mul.lemma_mul_inequality. (Int Int Int) Bool)
(declare-const %%global_location_label%%30 Bool)
(declare-const %%global_location_label%%31 Bool)
(assert
 (forall ((x! Int) (y! Int) (z! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_inequality. x! y! z!) (and
     (=>
      %%global_location_label%%30
      (<= x! y!)
     )
     (=>
      %%global_location_label%%31
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
    :qid user_vstd__arithmetic__mul__lemma_mul_inequality_33
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_inequality_33
))))

;; Function-Specs vstd::arithmetic::mul::lemma_mul_equality_converse
(declare-fun req%vstd!arithmetic.mul.lemma_mul_equality_converse. (Int Int Int) Bool)
(declare-const %%global_location_label%%32 Bool)
(declare-const %%global_location_label%%33 Bool)
(assert
 (forall ((m! Int) (x! Int) (y! Int)) (!
   (= (req%vstd!arithmetic.mul.lemma_mul_equality_converse. m! x! y!) (and
     (=>
      %%global_location_label%%32
      (not (= m! 0))
     )
     (=>
      %%global_location_label%%33
      (= (Mul m! x!) (Mul m! y!))
   )))
   :pattern ((req%vstd!arithmetic.mul.lemma_mul_equality_converse. m! x! y!))
   :qid internal_req__vstd!arithmetic.mul.lemma_mul_equality_converse._definition
   :skolemid skolem_internal_req__vstd!arithmetic.mul.lemma_mul_equality_converse._definition
)))
(declare-fun ens%vstd!arithmetic.mul.lemma_mul_equality_converse. (Int Int Int) Bool)
(assert
 (forall ((m! Int) (x! Int) (y! Int)) (!
   (= (ens%vstd!arithmetic.mul.lemma_mul_equality_converse. m! x! y!) (= x! y!))
   :pattern ((ens%vstd!arithmetic.mul.lemma_mul_equality_converse. m! x! y!))
   :qid internal_ens__vstd!arithmetic.mul.lemma_mul_equality_converse._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.mul.lemma_mul_equality_converse._definition
)))

;; Broadcast vstd::arithmetic::mul::lemma_mul_equality_converse
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.mul.lemma_mul_equality_converse.)
  (forall ((m! Int) (x! Int) (y! Int)) (!
    (=>
     (and
      (not (= m! 0))
      (= (Mul m! x!) (Mul m! y!))
     )
     (= x! y!)
    )
    :pattern ((Mul m! x!) (Mul m! y!))
    :qid user_vstd__arithmetic__mul__lemma_mul_equality_converse_34
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_equality_converse_34
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_35
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_35
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_other_way_36
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_add_other_way_36
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
    :qid user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_37
    :skolemid skolem_user_vstd__arithmetic__mul__lemma_mul_is_distributive_sub_37
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow0
(declare-fun ens%vstd!arithmetic.power.lemma_pow0. (Int) Bool)
(assert
 (forall ((b! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma_pow0. b!) (= (vstd!arithmetic.power.pow.? (I b!)
      (I 0)
     ) 1
   ))
   :pattern ((ens%vstd!arithmetic.power.lemma_pow0. b!))
   :qid internal_ens__vstd!arithmetic.power.lemma_pow0._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma_pow0._definition
)))

;; Broadcast vstd::arithmetic::power::lemma_pow0
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma_pow0.)
  (forall ((b! Poly)) (!
    (=>
     (has_type b! INT)
     (= (vstd!arithmetic.power.pow.? b! (I 0)) 1)
    )
    :pattern ((vstd!arithmetic.power.pow.? b! (I 0)))
    :qid user_vstd__arithmetic__power__lemma_pow0_38
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow0_38
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
    :qid user_vstd__arithmetic__power__lemma_pow1_39
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow1_39
))))

;; Function-Specs vstd::arithmetic::power::lemma0_pow
(declare-fun req%vstd!arithmetic.power.lemma0_pow. (Int) Bool)
(declare-const %%global_location_label%%34 Bool)
(assert
 (forall ((e! Int)) (!
   (= (req%vstd!arithmetic.power.lemma0_pow. e!) (=>
     %%global_location_label%%34
     (> e! 0)
   ))
   :pattern ((req%vstd!arithmetic.power.lemma0_pow. e!))
   :qid internal_req__vstd!arithmetic.power.lemma0_pow._definition
   :skolemid skolem_internal_req__vstd!arithmetic.power.lemma0_pow._definition
)))
(declare-fun ens%vstd!arithmetic.power.lemma0_pow. (Int) Bool)
(assert
 (forall ((e! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma0_pow. e!) (= (vstd!arithmetic.power.pow.? (I 0)
      (I e!)
     ) 0
   ))
   :pattern ((ens%vstd!arithmetic.power.lemma0_pow. e!))
   :qid internal_ens__vstd!arithmetic.power.lemma0_pow._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma0_pow._definition
)))

;; Broadcast vstd::arithmetic::power::lemma0_pow
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma0_pow.)
  (forall ((e! Poly)) (!
    (=>
     (has_type e! NAT)
     (=>
      (> (%I e!) 0)
      (= (vstd!arithmetic.power.pow.? (I 0) e!) 0)
    ))
    :pattern ((vstd!arithmetic.power.pow.? (I 0) e!))
    :qid user_vstd__arithmetic__power__lemma0_pow_40
    :skolemid skolem_user_vstd__arithmetic__power__lemma0_pow_40
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow_positive
(declare-fun req%vstd!arithmetic.power.lemma_pow_positive. (Int Int) Bool)
(declare-const %%global_location_label%%35 Bool)
(assert
 (forall ((b! Int) (e! Int)) (!
   (= (req%vstd!arithmetic.power.lemma_pow_positive. b! e!) (=>
     %%global_location_label%%35
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
    :qid user_vstd__arithmetic__power__lemma_pow_positive_41
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_positive_41
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
    :qid user_vstd__arithmetic__power__lemma_pow_adds_42
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_adds_42
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
    :qid user_vstd__arithmetic__power__lemma_pow_multiplies_43
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_multiplies_43
))))

;; Function-Specs vstd::arithmetic::power::lemma_pow_mod_noop
(declare-fun req%vstd!arithmetic.power.lemma_pow_mod_noop. (Int Int Int) Bool)
(declare-const %%global_location_label%%36 Bool)
(assert
 (forall ((b! Int) (e! Int) (m! Int)) (!
   (= (req%vstd!arithmetic.power.lemma_pow_mod_noop. b! e! m!) (=>
     %%global_location_label%%36
     (> m! 0)
   ))
   :pattern ((req%vstd!arithmetic.power.lemma_pow_mod_noop. b! e! m!))
   :qid internal_req__vstd!arithmetic.power.lemma_pow_mod_noop._definition
   :skolemid skolem_internal_req__vstd!arithmetic.power.lemma_pow_mod_noop._definition
)))
(declare-fun ens%vstd!arithmetic.power.lemma_pow_mod_noop. (Int Int Int) Bool)
(assert
 (forall ((b! Int) (e! Int) (m! Int)) (!
   (= (ens%vstd!arithmetic.power.lemma_pow_mod_noop. b! e! m!) (= (EucMod (vstd!arithmetic.power.pow.?
       (I (EucMod b! m!)) (I e!)
      ) m!
     ) (EucMod (vstd!arithmetic.power.pow.? (I b!) (I e!)) m!)
   ))
   :pattern ((ens%vstd!arithmetic.power.lemma_pow_mod_noop. b! e! m!))
   :qid internal_ens__vstd!arithmetic.power.lemma_pow_mod_noop._definition
   :skolemid skolem_internal_ens__vstd!arithmetic.power.lemma_pow_mod_noop._definition
)))

;; Broadcast vstd::arithmetic::power::lemma_pow_mod_noop
(assert
 (=>
  (fuel_bool fuel%vstd!arithmetic.power.lemma_pow_mod_noop.)
  (forall ((b! Int) (e! Poly) (m! Int)) (!
    (=>
     (has_type e! NAT)
     (=>
      (> m! 0)
      (= (EucMod (vstd!arithmetic.power.pow.? (I (EucMod b! m!)) e!) m!) (EucMod (vstd!arithmetic.power.pow.?
         (I b!) e!
        ) m!
    ))))
    :pattern ((vstd!arithmetic.power.pow.? (I (EucMod b! m!)) e!))
    :qid user_vstd__arithmetic__power__lemma_pow_mod_noop_44
    :skolemid skolem_user_vstd__arithmetic__power__lemma_pow_mod_noop_44
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
(declare-const %%global_location_label%%37 Bool)
(assert
 (forall ((e! Int)) (!
   (= (req%vstd!arithmetic.power2.lemma_pow2_unfold. e!) (=>
     %%global_location_label%%37
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
(declare-const %%global_location_label%%38 Bool)
(assert
 (forall ((e1! Int) (e2! Int)) (!
   (= (req%vstd!arithmetic.power2.lemma_pow2_strictly_increases. e1! e2!) (=>
     %%global_location_label%%38
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

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_sum_u8
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.
 Fuel
)
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u8.? coefs! offset!
     step! k! fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u8.? coefs! offset!
     step! k! zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u8.? coefs!
     offset! step! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8._fuel_to_zero_definition
)))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 8)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u8.? coefs! offset!
      step! k! (succ fuel%)
     ) (ite
      (= (%I k!) 0)
      (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $
            (UINT 8)
           ) coefs!
          ) offset!
         )
        ) (vstd!arithmetic.power2.pow2.? (I 0))
      ))
      (nClip (Add (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u8.? coefs!
         offset! step! (I (nClip (Sub (%I k!) 1))) fuel%
        ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE
              $ (UINT 8)
             ) coefs!
            ) (I (nClip (Add (%I offset!) (%I k!))))
           )
          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (%I k!) (%I step!)))))
   )))))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u8.? coefs!
     offset! step! k! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.)
  (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly)) (!
    (=>
     (and
      (has_type coefs! (SLICE $ (UINT 8)))
      (has_type offset! NAT)
      (has_type step! NAT)
      (has_type k! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.? coefs! offset! step!
       k!
      ) (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u8.? coefs! offset!
       step! k! (succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.)
    )))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.? coefs! offset!
      step! k!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.?_definition
))))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 8)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.? coefs! offset!
      step! k!
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.? coefs! offset!
     step! k!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.?_pre_post_definition
)))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 8)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u8.? coefs! offset!
      step! k! fuel%
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u8.? coefs!
     offset! step! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec__pow2_sum_u8.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec__pow2_sum_u8.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_sum_u16
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.
 Fuel
)
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u16.? coefs! offset!
     step! k! fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u16.? coefs! offset!
     step! k! zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u16.? coefs!
     offset! step! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16._fuel_to_zero_definition
)))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 16)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u16.? coefs! offset!
      step! k! (succ fuel%)
     ) (ite
      (= (%I k!) 0)
      (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 16) (vstd!view.View.view.? $slice (SLICE
            $ (UINT 16)
           ) coefs!
          ) offset!
         )
        ) (vstd!arithmetic.power2.pow2.? (I 0))
      ))
      (nClip (Add (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u16.? coefs!
         offset! step! (I (nClip (Sub (%I k!) 1))) fuel%
        ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 16) (vstd!view.View.view.? $slice (SLICE
              $ (UINT 16)
             ) coefs!
            ) (I (nClip (Add (%I offset!) (%I k!))))
           )
          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (%I k!) (%I step!)))))
   )))))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u16.? coefs!
     offset! step! k! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.)
  (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly)) (!
    (=>
     (and
      (has_type coefs! (SLICE $ (UINT 16)))
      (has_type offset! NAT)
      (has_type step! NAT)
      (has_type k! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.? coefs! offset!
       step! k!
      ) (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u16.? coefs! offset!
       step! k! (succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.)
    )))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.? coefs! offset!
      step! k!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.?_definition
))))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 16)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.? coefs! offset!
      step! k!
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.? coefs! offset!
     step! k!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u16.?_pre_post_definition
)))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 16)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u16.? coefs! offset!
      step! k! fuel%
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u16.? coefs!
     offset! step! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec__pow2_sum_u16.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec__pow2_sum_u16.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_sum_u32
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.
 Fuel
)
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u32.? coefs! offset!
     step! k! fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u32.? coefs! offset!
     step! k! zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u32.? coefs!
     offset! step! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32._fuel_to_zero_definition
)))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 32)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u32.? coefs! offset!
      step! k! (succ fuel%)
     ) (ite
      (= (%I k!) 0)
      (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 32) (vstd!view.View.view.? $slice (SLICE
            $ (UINT 32)
           ) coefs!
          ) offset!
         )
        ) (vstd!arithmetic.power2.pow2.? (I 0))
      ))
      (nClip (Add (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u32.? coefs!
         offset! step! (I (nClip (Sub (%I k!) 1))) fuel%
        ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 32) (vstd!view.View.view.? $slice (SLICE
              $ (UINT 32)
             ) coefs!
            ) (I (nClip (Add (%I offset!) (%I k!))))
           )
          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (%I k!) (%I step!)))))
   )))))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u32.? coefs!
     offset! step! k! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.)
  (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly)) (!
    (=>
     (and
      (has_type coefs! (SLICE $ (UINT 32)))
      (has_type offset! NAT)
      (has_type step! NAT)
      (has_type k! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.? coefs! offset!
       step! k!
      ) (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u32.? coefs! offset!
       step! k! (succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.)
    )))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.? coefs! offset!
      step! k!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.?_definition
))))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 32)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.? coefs! offset!
      step! k!
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.? coefs! offset!
     step! k!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u32.?_pre_post_definition
)))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 32)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u32.? coefs! offset!
      step! k! fuel%
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u32.? coefs!
     offset! step! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec__pow2_sum_u32.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec__pow2_sum_u32.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_sum_u64
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.
 Fuel
)
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u64.? coefs! offset!
     step! k! fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u64.? coefs! offset!
     step! k! zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u64.? coefs!
     offset! step! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64._fuel_to_zero_definition
)))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 64)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u64.? coefs! offset!
      step! k! (succ fuel%)
     ) (ite
      (= (%I k!) 0)
      (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $slice (SLICE
            $ (UINT 64)
           ) coefs!
          ) offset!
         )
        ) (vstd!arithmetic.power2.pow2.? (I 0))
      ))
      (nClip (Add (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u64.? coefs!
         offset! step! (I (nClip (Sub (%I k!) 1))) fuel%
        ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 64) (vstd!view.View.view.? $slice (SLICE
              $ (UINT 64)
             ) coefs!
            ) (I (nClip (Add (%I offset!) (%I k!))))
           )
          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (%I k!) (%I step!)))))
   )))))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u64.? coefs!
     offset! step! k! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.)
  (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly)) (!
    (=>
     (and
      (has_type coefs! (SLICE $ (UINT 64)))
      (has_type offset! NAT)
      (has_type step! NAT)
      (has_type k! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.? coefs! offset!
       step! k!
      ) (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u64.? coefs! offset!
       step! k! (succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.)
    )))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.? coefs! offset!
      step! k!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.?_definition
))))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 64)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.? coefs! offset!
      step! k!
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.? coefs! offset!
     step! k!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u64.?_pre_post_definition
)))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 64)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u64.? coefs! offset!
      step! k! fuel%
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u64.? coefs!
     offset! step! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec__pow2_sum_u64.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec__pow2_sum_u64.?_pre_post_rec_definition
)))

;; Function-Axioms curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_sum_u128
(assert
 (fuel_bool_default fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.)
)
(declare-const fuel_nat%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.
 Fuel
)
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u128.? coefs! offset!
     step! k! fuel%
    ) (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u128.? coefs! offset!
     step! k! zero
   ))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u128.? coefs!
     offset! step! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128._fuel_to_zero_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128._fuel_to_zero_definition
)))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 128)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u128.? coefs! offset!
      step! k! (succ fuel%)
     ) (ite
      (= (%I k!) 0)
      (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $slice (SLICE
            $ (UINT 128)
           ) coefs!
          ) offset!
         )
        ) (vstd!arithmetic.power2.pow2.? (I 0))
      ))
      (nClip (Add (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u128.? coefs!
         offset! step! (I (nClip (Sub (%I k!) 1))) fuel%
        ) (nClip (Mul (%I (vstd!seq.Seq.index.? $ (UINT 128) (vstd!view.View.view.? $slice (SLICE
              $ (UINT 128)
             ) coefs!
            ) (I (nClip (Add (%I offset!) (%I k!))))
           )
          ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (%I k!) (%I step!)))))
   )))))))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u128.? coefs!
     offset! step! k! (succ fuel%)
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128._fuel_to_body_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128._fuel_to_body_definition
)))
(assert
 (=>
  (fuel_bool fuel%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.)
  (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly)) (!
    (=>
     (and
      (has_type coefs! (SLICE $ (UINT 128)))
      (has_type offset! NAT)
      (has_type step! NAT)
      (has_type k! NAT)
     )
     (= (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.? coefs! offset!
       step! k!
      ) (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u128.? coefs! offset!
       step! k! (succ fuel_nat%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.)
    )))
    :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.? coefs!
      offset! step! k!
    ))
    :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.?_definition
    :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.?_definition
))))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 128)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.? coefs! offset!
      step! k!
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.? coefs!
     offset! step! k!
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.?_pre_post_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u128.?_pre_post_definition
)))
(assert
 (forall ((coefs! Poly) (offset! Poly) (step! Poly) (k! Poly) (fuel% Fuel)) (!
   (=>
    (and
     (has_type coefs! (SLICE $ (UINT 128)))
     (has_type offset! NAT)
     (has_type step! NAT)
     (has_type k! NAT)
    )
    (<= 0 (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u128.? coefs!
      offset! step! k! fuel%
   )))
   :pattern ((curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec%pow2_sum_u128.? coefs!
     offset! step! k! fuel%
   ))
   :qid internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec__pow2_sum_u128.?_pre_post_rec_definition
   :skolemid skolem_internal_curve25519_dalek!lemmas.common_lemmas.pow_lemmas.rec__pow2_sum_u128.?_pre_post_rec_definition
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::mul_lemmas::lemma_mul_le
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. (Int
  Int Int Int
 ) Bool
)
(declare-const %%global_location_label%%39 Bool)
(declare-const %%global_location_label%%40 Bool)
(assert
 (forall ((a1! Int) (b1! Int) (a2! Int) (b2! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_le. a1! b1! a2!
     b2!
    ) (and
     (=>
      %%global_location_label%%39
      (<= a1! b1!)
     )
     (=>
      %%global_location_label%%40
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::mul_lemmas::lemma_mul_distributive_8_terms
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_distributive_8_terms.
 (Int Int Int Int Int Int Int Int Int) Bool
)
(assert
 (forall ((n! Int) (x1! Int) (x2! Int) (x3! Int) (x4! Int) (x5! Int) (x6! Int) (x7! Int)
   (x8! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_distributive_8_terms.
     n! x1! x2! x3! x4! x5! x6! x7! x8!
    ) (let
     ((tmp%%$ (Mul (Add (Add (Add (Add (Add (Add (Add x1! x2!) x3!) x4!) x5!) x6!) x7!) x8!)
        n!
     )))
     (and
      (= (Mul n! (Add (Add (Add (Add (Add (Add (Add x1! x2!) x3!) x4!) x5!) x6!) x7!) x8!))
       tmp%%$
      )
      (= tmp%%$ (Add (Add (Add (Add (Add (Add (Add (Mul n! x1!) (Mul n! x2!)) (Mul n! x3!)) (
             Mul n! x4!
            )
           ) (Mul n! x5!)
          ) (Mul n! x6!)
         ) (Mul n! x7!)
        ) (Mul n! x8!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_distributive_8_terms.
     n! x1! x2! x3! x4! x5! x6! x7! x8!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_distributive_8_terms._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.mul_lemmas.lemma_mul_distributive_8_terms._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_distributivity_over_word
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
 (Int Int Int Int Int Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%41 Bool)
(assert
 (forall ((word! Int) (byte0! Int) (byte1! Int) (byte2! Int) (byte3! Int) (byte4! Int)
   (byte5! Int) (byte6! Int) (byte7! Int) (exp! Int)
  ) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
     word! byte0! byte1! byte2! byte3! byte4! byte5! byte6! byte7! exp!
    ) (=>
     %%global_location_label%%41
     (= word! (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip
                     (Mul byte0! (vstd!arithmetic.power2.pow2.? (I 0)))
                    ) (nClip (Mul byte1! (vstd!arithmetic.power2.pow2.? (I 8))))
                   )
                  ) (nClip (Mul byte2! (vstd!arithmetic.power2.pow2.? (I 16))))
                 )
                ) (nClip (Mul byte3! (vstd!arithmetic.power2.pow2.? (I 24))))
               )
              ) (nClip (Mul byte4! (vstd!arithmetic.power2.pow2.? (I 32))))
             )
            ) (nClip (Mul byte5! (vstd!arithmetic.power2.pow2.? (I 40))))
           )
          ) (nClip (Mul byte6! (vstd!arithmetic.power2.pow2.? (I 48))))
         )
        ) (nClip (Mul byte7! (vstd!arithmetic.power2.pow2.? (I 56))))
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
     word! byte0! byte1! byte2! byte3! byte4! byte5! byte6! byte7! exp!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
 (Int Int Int Int Int Int Int Int Int Int) Bool
)
(assert
 (forall ((word! Int) (byte0! Int) (byte1! Int) (byte2! Int) (byte3! Int) (byte4! Int)
   (byte5! Int) (byte6! Int) (byte7! Int) (exp! Int)
  ) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
     word! byte0! byte1! byte2! byte3! byte4! byte5! byte6! byte7! exp!
    ) (= (nClip (Mul word! (vstd!arithmetic.power2.pow2.? (I exp!)))) (nClip (Add (nClip
        (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Add (nClip (Mul byte0! (vstd!arithmetic.power2.pow2.?
                      (I exp!)
                    ))
                   ) (nClip (Mul byte1! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 8))))))
                  )
                 ) (nClip (Mul byte2! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 16))))))
                )
               ) (nClip (Mul byte3! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 24))))))
              )
             ) (nClip (Mul byte4! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 32))))))
            )
           ) (nClip (Mul byte5! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 40))))))
          )
         ) (nClip (Mul byte6! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 48))))))
        )
       ) (nClip (Mul byte7! (vstd!arithmetic.power2.pow2.? (I (nClip (Add exp! 56))))))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word.
     word! byte0! byte1! byte2! byte3! byte4! byte5! byte6! byte7! exp!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_distributivity_over_word._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u128_pow2_le_max
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max.
 (Int) Bool
)
(declare-const %%global_location_label%%42 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u128_pow2_le_max. k!)
    (=>
     %%global_location_label%%42
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u64_pow2_le_max
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max.
 (Int) Bool
)
(declare-const %%global_location_label%%43 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_le_max. k!)
    (=>
     %%global_location_label%%43
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_div_strictly_bounded
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%44 Bool)
(declare-const %%global_location_label%%45 Bool)
(declare-const %%global_location_label%%46 Bool)
(assert
 (forall ((x! Int) (a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_div_strictly_bounded.
     x! a! b!
    ) (and
     (=>
      %%global_location_label%%44
      (> a! 0)
     )
     (=>
      %%global_location_label%%45
      (>= b! 0)
     )
     (=>
      %%global_location_label%%46
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::div_mod_lemmas::lemma_int_nat_mod_equiv
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv.
 (Int Int) Bool
)
(declare-const %%global_location_label%%47 Bool)
(declare-const %%global_location_label%%48 Bool)
(assert
 (forall ((v! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.div_mod_lemmas.lemma_int_nat_mod_equiv.
     v! m!
    ) (and
     (=>
      %%global_location_label%%47
      (>= v! 0)
     )
     (=>
      %%global_location_label%%48
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_mul_bound_general
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_bound_general.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%49 Bool)
(assert
 (forall ((a! Int) (s! Int) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_bound_general.
     a! s! k!
    ) (=>
     %%global_location_label%%49
     (< a! (vstd!arithmetic.power2.pow2.? (I s!)))
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_bound_general.
     a! s! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_bound_general._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_bound_general._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_bound_general.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (s! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_bound_general.
     a! s! k!
    ) (and
     (<= (nClip (Mul (vstd!arithmetic.power2.pow2.? (I k!)) a!)) (Sub (vstd!arithmetic.power2.pow2.?
        (I (nClip (Add k! s!)))
       ) (vstd!arithmetic.power2.pow2.? (I k!))
     ))
     (<= (nClip (Mul a! (vstd!arithmetic.power2.pow2.? (I k!)))) (Sub (vstd!arithmetic.power2.pow2.?
        (I (nClip (Add k! s!)))
       ) (vstd!arithmetic.power2.pow2.? (I k!))
     ))
     (< (Sub (vstd!arithmetic.power2.pow2.? (I (nClip (Add k! s!)))) (vstd!arithmetic.power2.pow2.?
        (I k!)
       )
      ) (vstd!arithmetic.power2.pow2.? (I (nClip (Add k! s!))))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_bound_general.
     a! s! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_bound_general._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_bound_general._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_mul_mod
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_mod.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%50 Bool)
(assert
 (forall ((x! Int) (k! Int) (s! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_mod. x! k!
     s!
    ) (=>
     %%global_location_label%%50
     (<= k! s!)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_mod.
     x! k! s!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_mod.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (k! Int) (s! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_mod. x! k!
     s!
    ) (= (EucMod (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I k!)))) (vstd!arithmetic.power2.pow2.?
       (I s!)
      )
     ) (nClip (Mul (EucMod x! (vstd!arithmetic.power2.pow2.? (I (nClip (Sub s! k!))))) (
        vstd!arithmetic.power2.pow2.? (I k!)
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_mod.
     x! k! s!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_binary_sum_mod_decomposition
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_mod_decomposition.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%51 Bool)
(assert
 (forall ((a! Int) (b! Int) (s! Int) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_mod_decomposition.
     a! b! s! k!
    ) (=>
     %%global_location_label%%51
     (< a! (vstd!arithmetic.power2.pow2.? (I s!)))
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_mod_decomposition.
     a! b! s! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_mod_decomposition._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_mod_decomposition._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_mod_decomposition.
 (Int Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (s! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_mod_decomposition.
     a! b! s! k!
    ) (= (EucMod (nClip (Add a! (nClip (Mul b! (vstd!arithmetic.power2.pow2.? (I s!))))))
      (vstd!arithmetic.power2.pow2.? (I k!))
     ) (nClip (Add (EucMod a! (vstd!arithmetic.power2.pow2.? (I k!))) (EucMod (nClip (Mul b!
          (vstd!arithmetic.power2.pow2.? (I s!))
         )
        ) (vstd!arithmetic.power2.pow2.? (I k!))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_mod_decomposition.
     a! b! s! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_mod_decomposition._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_mod_decomposition._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_modular_bit_partitioning
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_modular_bit_partitioning.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%52 Bool)
(declare-const %%global_location_label%%53 Bool)
(assert
 (forall ((a! Int) (b! Int) (k! Int) (n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_modular_bit_partitioning.
     a! b! k! n!
    ) (and
     (=>
      %%global_location_label%%52
      (<= k! n!)
     )
     (=>
      %%global_location_label%%53
      (< a! (vstd!arithmetic.power2.pow2.? (I k!)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_modular_bit_partitioning.
     a! b! k! n!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_modular_bit_partitioning._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_modular_bit_partitioning._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_modular_bit_partitioning.
 (Int Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (k! Int) (n! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_modular_bit_partitioning.
     a! b! k! n!
    ) (= (EucMod (nClip (Add a! (nClip (Mul b! (vstd!arithmetic.power2.pow2.? (I k!))))))
      (vstd!arithmetic.power2.pow2.? (I n!))
     ) (nClip (Add (EucMod a! (vstd!arithmetic.power2.pow2.? (I k!))) (nClip (Mul (EucMod b!
          (vstd!arithmetic.power2.pow2.? (I (nClip (Sub n! k!))))
         ) (vstd!arithmetic.power2.pow2.? (I k!))
   ))))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_modular_bit_partitioning.
     a! b! k! n!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_modular_bit_partitioning._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_modular_bit_partitioning._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_binary_sum_div_decomposition
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_div_decomposition.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%54 Bool)
(assert
 (forall ((a! Int) (b! Int) (s! Int) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_div_decomposition.
     a! b! s! k!
    ) (=>
     %%global_location_label%%54
     (< a! (vstd!arithmetic.power2.pow2.? (I s!)))
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_div_decomposition.
     a! b! s! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_div_decomposition._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_div_decomposition._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_div_decomposition.
 (Int Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (s! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_div_decomposition.
     a! b! s! k!
    ) (= (EucDiv (nClip (Add a! (nClip (Mul b! (vstd!arithmetic.power2.pow2.? (I s!))))))
      (vstd!arithmetic.power2.pow2.? (I k!))
     ) (nClip (Add (EucDiv a! (vstd!arithmetic.power2.pow2.? (I k!))) (EucDiv (nClip (Mul b!
          (vstd!arithmetic.power2.pow2.? (I s!))
         )
        ) (vstd!arithmetic.power2.pow2.? (I k!))
   )))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_div_decomposition.
     a! b! s! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_div_decomposition._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_binary_sum_div_decomposition._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_div_mod
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_div_mod.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (k! Int) (s! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_div_mod. x! k!
     s!
    ) (= (EucMod (EucDiv x! (vstd!arithmetic.power2.pow2.? (I k!))) (vstd!arithmetic.power2.pow2.?
       (I s!)
      )
     ) (EucDiv (EucMod x! (vstd!arithmetic.power2.pow2.? (I (nClip (Add s! k!))))) (vstd!arithmetic.power2.pow2.?
       (I k!)
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_div_mod.
     x! k! s!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_div_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_div_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_chunk_extraction_commutes_with_mod
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_chunk_extraction_commutes_with_mod.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%55 Bool)
(declare-const %%global_location_label%%56 Bool)
(assert
 (forall ((x! Int) (k! Int) (b! Int) (m! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_chunk_extraction_commutes_with_mod.
     x! k! b! m!
    ) (and
     (=>
      %%global_location_label%%55
      (> b! 0)
     )
     (=>
      %%global_location_label%%56
      (<= (nClip (Add (nClip (Mul k! b!)) b!)) m!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_chunk_extraction_commutes_with_mod.
     x! k! b! m!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_chunk_extraction_commutes_with_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_chunk_extraction_commutes_with_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_chunk_extraction_commutes_with_mod.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (k! Int) (b! Int) (m! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_chunk_extraction_commutes_with_mod.
     x! k! b! m!
    ) (= (EucMod (EucDiv x! (vstd!arithmetic.power2.pow2.? (I (nClip (Mul k! b!))))) (vstd!arithmetic.power2.pow2.?
       (I b!)
      )
     ) (EucMod (EucDiv (EucMod x! (vstd!arithmetic.power2.pow2.? (I m!))) (vstd!arithmetic.power2.pow2.?
        (I (nClip (Mul k! b!)))
       )
      ) (vstd!arithmetic.power2.pow2.? (I b!))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_chunk_extraction_commutes_with_mod.
     x! k! b! m!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_chunk_extraction_commutes_with_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_chunk_extraction_commutes_with_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_div_bound
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_div_bound.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%57 Bool)
(declare-const %%global_location_label%%58 Bool)
(assert
 (forall ((x! Int) (a! Int) (b! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_div_bound. x! a! b!)
    (and
     (=>
      %%global_location_label%%57
      (<= a! b!)
     )
     (=>
      %%global_location_label%%58
      (< x! (vstd!arithmetic.power2.pow2.? (I b!)))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_div_bound. x!
     a! b!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_div_bound._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_div_bound._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_div_bound.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (a! Int) (b! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_div_bound. x! a! b!)
    (< (EucDiv x! (vstd!arithmetic.power2.pow2.? (I a!))) (vstd!arithmetic.power2.pow2.?
      (I (nClip (Sub b! a!)))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_div_bound. x!
     a! b!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_div_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_div_bound._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_even
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even.
 (Int) Bool
)
(declare-const %%global_location_label%%59 Bool)
(assert
 (forall ((n! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_even. n!) (=>
     %%global_location_label%%59
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u8_lt_pow2_8
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_lt_pow2_8.
 (Int) Bool
)
(assert
 (forall ((x! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_lt_pow2_8. x!) (
     < x! (vstd!arithmetic.power2.pow2.? (I 8))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_lt_pow2_8.
     x!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_lt_pow2_8._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_lt_pow2_8._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u8_pow2_mul_bound
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_bound.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_bound. a!
     k!
    ) (and
     (<= (Mul (vstd!arithmetic.power2.pow2.? (I k!)) a!) (Sub (vstd!arithmetic.power2.pow2.?
        (I (nClip (Add k! 8)))
       ) (vstd!arithmetic.power2.pow2.? (I k!))
     ))
     (<= (Mul a! (vstd!arithmetic.power2.pow2.? (I k!))) (Sub (vstd!arithmetic.power2.pow2.?
        (I (nClip (Add k! 8)))
       ) (vstd!arithmetic.power2.pow2.? (I k!))
     ))
     (< (Sub (vstd!arithmetic.power2.pow2.? (I (nClip (Add k! 8)))) (vstd!arithmetic.power2.pow2.?
        (I k!)
       )
      ) (vstd!arithmetic.power2.pow2.? (I (nClip (Add k! 8))))
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_bound.
     a! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_bound._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u64_pow2_bound
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_bound.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_bound. a!)
    (= (< a! (vstd!arithmetic.power2.pow2.? (I 64))) (<= a! 18446744073709551615))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_bound.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_pow2_bound._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u8_times_pow2_fits_u64
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_fits_u64.
 (Int Int) Bool
)
(declare-const %%global_location_label%%60 Bool)
(assert
 (forall ((a! Int) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_fits_u64.
     a! k!
    ) (=>
     %%global_location_label%%60
     (<= (Add k! 8) 64)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_fits_u64.
     a! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_fits_u64._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_fits_u64._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_fits_u64.
 (Int Int) Bool
)
(assert
 (forall ((a! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_fits_u64.
     a! k!
    ) (<= (Mul a! (vstd!arithmetic.power2.pow2.? (I k!))) 18446744073709551615)
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_fits_u64.
     a! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_fits_u64._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_times_pow2_fits_u64._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::pow2_MUL_div
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. (Int
  Int Int
 ) Bool
)
(declare-const %%global_location_label%%61 Bool)
(assert
 (forall ((x! Int) (k! Int) (s! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. x! k! s!) (
     =>
     %%global_location_label%%61
     (>= k! s!)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. x! k!
     s!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. (Int
  Int Int
 ) Bool
)
(assert
 (forall ((x! Int) (k! Int) (s! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. x! k! s!) (
     = (EucDiv (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I k!)))) (vstd!arithmetic.power2.pow2.?
       (I s!)
      )
     ) (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I (nClip (Sub k! s!))))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div. x! k!
     s!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_MUL_div._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u64_div_pow2_preserves_decomposition
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_div_pow2_preserves_decomposition.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%62 Bool)
(declare-const %%global_location_label%%63 Bool)
(declare-const %%global_location_label%%64 Bool)
(assert
 (forall ((a! Int) (b! Int) (s! Int) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_div_pow2_preserves_decomposition.
     a! b! s! k!
    ) (and
     (=>
      %%global_location_label%%62
      (< a! (vstd!arithmetic.power2.pow2.? (I s!)))
     )
     (=>
      %%global_location_label%%63
      (<= (Add a! (Mul b! (vstd!arithmetic.power2.pow2.? (I s!)))) 18446744073709551615)
     )
     (=>
      %%global_location_label%%64
      (let
       ((tmp%%$ s!))
       (and
        (<= k! tmp%%$)
        (< tmp%%$ 64)
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_div_pow2_preserves_decomposition.
     a! b! s! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_div_pow2_preserves_decomposition._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_div_pow2_preserves_decomposition._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_div_pow2_preserves_decomposition.
 (Int Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (s! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_div_pow2_preserves_decomposition.
     a! b! s! k!
    ) (and
     (< (EucDiv a! (vstd!arithmetic.power2.pow2.? (I k!))) (vstd!arithmetic.power2.pow2.?
       (I (nClip (Sub s! k!)))
     ))
     (= (EucDiv (nClip (Mul b! (vstd!arithmetic.power2.pow2.? (I s!)))) (vstd!arithmetic.power2.pow2.?
        (I k!)
       )
      ) (Mul b! (vstd!arithmetic.power2.pow2.? (I (nClip (Sub s! k!)))))
     )
     (<= (Add (EucDiv a! (vstd!arithmetic.power2.pow2.? (I k!))) (Mul b! (vstd!arithmetic.power2.pow2.?
         (I (nClip (Sub s! k!)))
       ))
      ) 18446744073709551615
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_div_pow2_preserves_decomposition.
     a! b! s! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_div_pow2_preserves_decomposition._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u64_div_pow2_preserves_decomposition._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u8_pow2_bound
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_bound.
 (Int) Bool
)
(assert
 (forall ((a! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_bound. a!)
    (= (< a! (vstd!arithmetic.power2.pow2.? (I 8))) (<= a! 255))
   )
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_bound.
     a!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_bound._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_bound._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_mul_div
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div.
 (Int Int Int) Bool
)
(declare-const %%global_location_label%%65 Bool)
(assert
 (forall ((x! Int) (k! Int) (s! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div. x! k!
     s!
    ) (=>
     %%global_location_label%%65
     (<= k! s!)
   ))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div.
     x! k! s!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div.
 (Int Int Int) Bool
)
(assert
 (forall ((x! Int) (k! Int) (s! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div. x! k!
     s!
    ) (= (EucDiv (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I k!)))) (vstd!arithmetic.power2.pow2.?
       (I s!)
      )
     ) (EucDiv x! (vstd!arithmetic.power2.pow2.? (I (nClip (Sub s! k!)))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div.
     x! k! s!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_mul_div_mod_small_mul
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mul.
 (Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%66 Bool)
(declare-const %%global_location_label%%67 Bool)
(declare-const %%global_location_label%%68 Bool)
(assert
 (forall ((x! Int) (px! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mul.
     x! px! k! s! t!
    ) (and
     (=>
      %%global_location_label%%66
      (< x! (vstd!arithmetic.power2.pow2.? (I px!)))
     )
     (=>
      %%global_location_label%%67
      (<= k! s!)
     )
     (=>
      %%global_location_label%%68
      (<= px! (Sub (nClip (Add t! s!)) k!))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mul.
     x! px! k! s! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mul._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mul._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mul.
 (Int Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (px! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mul.
     x! px! k! s! t!
    ) (= (EucMod (EucDiv (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I k!)))) (vstd!arithmetic.power2.pow2.?
        (I s!)
       )
      ) (vstd!arithmetic.power2.pow2.? (I t!))
     ) (EucDiv x! (vstd!arithmetic.power2.pow2.? (I (nClip (Sub s! k!)))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mul.
     x! px! k! s! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mul._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mul._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u8_pow2_mul_div_mod_small_mul
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_mul.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%69 Bool)
(declare-const %%global_location_label%%70 Bool)
(assert
 (forall ((x! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_mul.
     x! k! s! t!
    ) (and
     (=>
      %%global_location_label%%69
      (<= k! s!)
     )
     (=>
      %%global_location_label%%70
      (<= 8 (Sub (nClip (Add t! s!)) k!))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_mul.
     x! k! s! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_mul._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_mul._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_mul.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_mul.
     x! k! s! t!
    ) (= (EucMod (EucDiv (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I k!)))) (vstd!arithmetic.power2.pow2.?
        (I s!)
       )
      ) (vstd!arithmetic.power2.pow2.? (I t!))
     ) (EucDiv x! (vstd!arithmetic.power2.pow2.? (I (nClip (Sub s! k!)))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_mul.
     x! k! s! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_mul._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_mul._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_mul_div_mod_small_div
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_div.
 (Int Int Int Int Int) Bool
)
(declare-const %%global_location_label%%71 Bool)
(declare-const %%global_location_label%%72 Bool)
(declare-const %%global_location_label%%73 Bool)
(assert
 (forall ((x! Int) (px! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_div.
     x! px! k! s! t!
    ) (and
     (=>
      %%global_location_label%%71
      (< x! (vstd!arithmetic.power2.pow2.? (I px!)))
     )
     (=>
      %%global_location_label%%72
      (<= s! k!)
     )
     (=>
      %%global_location_label%%73
      (<= (Sub (nClip (Add px! k!)) s!) t!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_div.
     x! px! k! s! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_div._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_div._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_div.
 (Int Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (px! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_div.
     x! px! k! s! t!
    ) (= (EucMod (EucDiv (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I k!)))) (vstd!arithmetic.power2.pow2.?
        (I s!)
       )
      ) (vstd!arithmetic.power2.pow2.? (I t!))
     ) (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I (nClip (Sub k! s!))))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_div.
     x! px! k! s! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_div._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_div._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u8_pow2_mul_div_mod_small_div
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_div.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%74 Bool)
(declare-const %%global_location_label%%75 Bool)
(assert
 (forall ((x! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_div.
     x! k! s! t!
    ) (and
     (=>
      %%global_location_label%%74
      (<= s! k!)
     )
     (=>
      %%global_location_label%%75
      (<= (Sub (Add 8 k!) s!) t!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_div.
     x! k! s! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_div._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_div._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_div.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_div.
     x! k! s! t!
    ) (= (EucMod (EucDiv (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I k!)))) (vstd!arithmetic.power2.pow2.?
        (I s!)
       )
      ) (vstd!arithmetic.power2.pow2.? (I t!))
     ) (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I (nClip (Sub k! s!))))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_div.
     x! k! s! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_div._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_mul_div_mod_small_div._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_mul_div_mod_close_mod
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_close_mod.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%76 Bool)
(declare-const %%global_location_label%%77 Bool)
(assert
 (forall ((x! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_close_mod.
     x! k! s! t!
    ) (and
     (=>
      %%global_location_label%%76
      (<= s! k!)
     )
     (=>
      %%global_location_label%%77
      (<= (Sub k! s!) t!)
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_close_mod.
     x! k! s! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_close_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_close_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_close_mod.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_close_mod.
     x! k! s! t!
    ) (= (EucMod (EucDiv (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I k!)))) (vstd!arithmetic.power2.pow2.?
        (I s!)
       )
      ) (vstd!arithmetic.power2.pow2.? (I t!))
     ) (nClip (Mul (EucMod x! (vstd!arithmetic.power2.pow2.? (I (nClip (Sub t! (Sub k! s!))))))
       (vstd!arithmetic.power2.pow2.? (I (nClip (Sub k! s!))))
   ))))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_close_mod.
     x! k! s! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_close_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_close_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_mul_div_mod_small_mod
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mod.
 (Int Int Int Int) Bool
)
(declare-const %%global_location_label%%78 Bool)
(declare-const %%global_location_label%%79 Bool)
(assert
 (forall ((x! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mod.
     x! k! s! t!
    ) (and
     (=>
      %%global_location_label%%78
      (<= s! k!)
     )
     (=>
      %%global_location_label%%79
      (<= t! (Sub k! s!))
   )))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mod.
     x! k! s! t!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mod._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mod._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mod.
 (Int Int Int Int) Bool
)
(assert
 (forall ((x! Int) (k! Int) (s! Int) (t! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mod.
     x! k! s! t!
    ) (= (EucMod (EucDiv (nClip (Mul x! (vstd!arithmetic.power2.pow2.? (I k!)))) (vstd!arithmetic.power2.pow2.?
        (I s!)
       )
      ) (vstd!arithmetic.power2.pow2.? (I t!))
     ) 0
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mod.
     x! k! s! t!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mod._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_mul_div_mod_small_mod._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_sum_u8_bounds
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_sum_u8_bounds.
 (slice%<u8.>. Int Int Int) Bool
)
(declare-const %%global_location_label%%80 Bool)
(declare-const %%global_location_label%%81 Bool)
(assert
 (forall ((coefs! slice%<u8.>.) (offset! Int) (step! Int) (k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_sum_u8_bounds.
     coefs! offset! step! k!
    ) (and
     (=>
      %%global_location_label%%80
      (<= (nClip (Add offset! k!)) (vstd!slice.spec_slice_len.? $ (UINT 8) (Poly%slice%<u8.>.
         coefs!
     ))))
     (=>
      %%global_location_label%%81
      (forall ((i$ Int)) (!
        (=>
         (<= 0 i$)
         (=>
          (let
           ((tmp%%$ i$))
           (and
            (<= 0 tmp%%$)
            (<= tmp%%$ k!)
          ))
          (< (%I (vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT 8))
              (Poly%slice%<u8.>. coefs!)
             ) (I (nClip (Add offset! i$)))
            )
           ) (vstd!arithmetic.power2.pow2.? (I step!))
        )))
        :pattern ((vstd!seq.Seq.index.? $ (UINT 8) (vstd!view.View.view.? $slice (SLICE $ (UINT
             8
            )
           ) (Poly%slice%<u8.>. coefs!)
          ) (I (nClip (Add offset! i$)))
        ))
        :qid user_curve25519_dalek__lemmas__common_lemmas__pow_lemmas__lemma_pow2_sum_u8_bounds_153
        :skolemid skolem_user_curve25519_dalek__lemmas__common_lemmas__pow_lemmas__lemma_pow2_sum_u8_bounds_153
   )))))
   :pattern ((req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_sum_u8_bounds.
     coefs! offset! step! k!
   ))
   :qid internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_sum_u8_bounds._definition
   :skolemid skolem_internal_req__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_sum_u8_bounds._definition
)))
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_sum_u8_bounds.
 (slice%<u8.>. Int Int Int) Bool
)
(assert
 (forall ((coefs! slice%<u8.>.) (offset! Int) (step! Int) (k! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_sum_u8_bounds.
     coefs! offset! step! k!
    ) (< (curve25519_dalek!lemmas.common_lemmas.pow_lemmas.pow2_sum_u8.? (Poly%slice%<u8.>.
       coefs!
      ) (I offset!) (I step!) (I k!)
     ) (vstd!arithmetic.power2.pow2.? (I (nClip (Mul (nClip (Add k! 1)) step!))))
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_sum_u8_bounds.
     coefs! offset! step! k!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_sum_u8_bounds._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow2_sum_u8_bounds._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_two_factoring
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_two_factoring.
 (Int Int Int) Bool
)
(assert
 (forall ((a! Int) (b! Int) (v! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_two_factoring. a! b!
     v!
    ) (= (Mul (vstd!arithmetic.power2.pow2.? (I (nClip (Add a! b!)))) v!) (Mul (vstd!arithmetic.power2.pow2.?
       (I a!)
      ) (Mul (vstd!arithmetic.power2.pow2.? (I b!)) v!)
   )))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_two_factoring.
     a! b! v!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_two_factoring._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_two_factoring._definition
)))

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_u8_pow2_le_max
(declare-fun req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max.
 (Int) Bool
)
(declare-const %%global_location_label%%82 Bool)
(assert
 (forall ((k! Int)) (!
   (= (req%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_u8_pow2_le_max. k!)
    (=>
     %%global_location_label%%82
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

;; Function-Specs curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow_nat_is_nat
(declare-fun ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nat_is_nat.
 (Int Int) Bool
)
(assert
 (forall ((v! Int) (i! Int)) (!
   (= (ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nat_is_nat. v! i!)
    (>= (vstd!arithmetic.power.pow.? (I v!) (I (vstd!arithmetic.power2.pow2.? (I i!))))
     0
   ))
   :pattern ((ens%curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nat_is_nat.
     v! i!
   ))
   :qid internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nat_is_nat._definition
   :skolemid skolem_internal_ens__curve25519_dalek!lemmas.common_lemmas.pow_lemmas.lemma_pow_nat_is_nat._definition
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

;; Function-Def curve25519_dalek::lemmas::common_lemmas::pow_lemmas::lemma_pow2_square
;; curve25519-dalek/src/lemmas/common_lemmas/pow_lemmas.rs:135:1: 135:47 (#0)
(get-info :all-statistics)
(push)
 (declare-const v! Int)
 (declare-const i! Int)
 (declare-const tmp%1 Int)
 (declare-const tmp%2 Int)
 (declare-const tmp%3 Int)
 (assert
  fuel_defaults
 )
 (assert
  (<= 0 i!)
 )
 ;; precondition not satisfied
 (declare-const %%location_label%%0 Bool)
 ;; postcondition not satisfied
 (declare-const %%location_label%%1 Bool)
 (assert
  (not (=>
    (= tmp%1 (vstd!arithmetic.power2.pow2.? (I i!)))
    (=>
     (= tmp%2 (vstd!arithmetic.power2.pow2.? (I i!)))
     (=>
      (ens%vstd!arithmetic.power.lemma_pow_adds. v! tmp%1 tmp%2)
      (=>
       (= tmp%3 (nClip (Add i! 1)))
       (and
        (=>
         %%location_label%%0
         (req%vstd!arithmetic.power2.lemma_pow2_unfold. tmp%3)
        )
        (=>
         (ens%vstd!arithmetic.power2.lemma_pow2_unfold. tmp%3)
         (=>
          %%location_label%%1
          (= (Mul (vstd!arithmetic.power.pow.? (I v!) (I (vstd!arithmetic.power2.pow2.? (I i!))))
            (vstd!arithmetic.power.pow.? (I v!) (I (vstd!arithmetic.power2.pow2.? (I i!))))
           ) (vstd!arithmetic.power.pow.? (I v!) (I (vstd!arithmetic.power2.pow2.? (I (nClip (Add
                 i! 1
 ))))))))))))))))
 (get-info :version)
 (set-option :rlimit 30000000)
 (check-sat)
 (set-option :rlimit 0)
(pop)
